//
//  UpgradeInfoViewModel.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import UIKit

public class UpgradeInfoViewModel: ObservableObject {
    let productName: String
    let message: String
    let sku: String
    let courseID: String
    let screen: CourseUpgradeScreen
    let handler: CourseUpgradeHandlerProtocol
    let pacing: String
    let analytics: CoreAnalytics
    let router: BaseRouter
    
    @Published var isLoading: Bool = false
    @Published var product: StoreProductInfo?
    @Published var error: Error?
    @Published var interactiveDismissDisabled: Bool = false
    var price: String {
        guard let product = product, let price = product.localizedPrice else { return "" }
        return price
    }

    public init(
        productName: String,
        message: String,
        sku: String,
        courseID: String,
        screen: CourseUpgradeScreen,
        handler: CourseUpgradeHandlerProtocol,
        pacing: String,
        analytics: CoreAnalytics,
        router: BaseRouter
    ) {
        self.productName = productName
        self.sku = sku
        self.courseID = courseID
        self.screen = screen
        self.handler = handler
        self.pacing = pacing
        self.analytics = analytics
        self.router = router
        self.message = message
    }
    
    @MainActor
    public func fetchProduct() async {
        guard !sku.isEmpty else {
            isLoading = false
            return
        }
        do {
            isLoading = true
            product = try await handler.fetchProduct(sku: sku)
            isLoading = false
        } catch let error {
            showPriceLoadError(error: error)
        }
    }
    
    @MainActor
    private func showPriceLoadError(error: Error) {
        guard let error = error as? UpgradeError else { return }

        analytics.trackCourseUpgradeLoadError(
            courseID: courseID,
            blockID: "",
            pacing: pacing,
            screen: screen
        )
        
        var actions: [UIAlertAction] = []
        
        if error != .productNotExist {
            actions.append(
                UIAlertAction(
                    title: CoreLocalization.CourseUpgrade.FailureAlert.priceFetchError,
                    style: .default
                ) {[weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.fetchProduct()
                    }
                    
                    self.analytics.trackCourseUpgradeErrorAction(
                        courseID: self.courseID,
                        blockID: "",
                        pacing: pacing,
                        coursePrice: "",
                        screen: self.screen,
                        errorAction: UpgradeErrorAction.reloadPrice.rawValue,
                        error: "price",
                        flowType: .userInitiated
                    )
                }
            )
        }

        let cancelButtonTitle = error == .productNotExist ? CoreLocalization.ok : CoreLocalization.Alert.cancel
        actions.append(
            UIAlertAction(
                title: cancelButtonTitle,
                style: .default
            ) { [weak self] _ in
                guard let self else { return }
                self.error = error
                self.isLoading = false
                self.analytics.trackCourseUpgradeErrorAction(
                    courseID: self.courseID,
                    blockID: "",
                    pacing: pacing,
                    coursePrice: nil,
                    screen: self.screen,
                    errorAction: UpgradeErrorAction.close.rawValue,
                    error: "price",
                    flowType: .userInitiated
                )
            }
        )
        router.presentNativeAlert(
            title: CoreLocalization.CourseUpgrade.FailureAlert.alertTitle,
            message: CoreLocalization.CourseUpgrade.FailureAlert.priceFetchErrorMessage,
            actions: actions
        )
    }

    public func purchase() async {
        isLoading = true
        interactiveDismissDisabled = true
        analytics.trackUpgradeNow(
            courseID: courseID,
            blockID: "",
            pacing: pacing,
            screen: screen,
            coursePrice: product?.localizedPrice ?? ""
        )
        await handler.upgradeCourse(
            sku: sku,
            mode: .userInitiated,
            productInfo: product,
            pacing: pacing,
            courseID: courseID,
            componentID: nil,
            screen: screen,
            completion: {[weak self] state in
                guard let self = self else { return }
                switch state {
                case .error:
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.interactiveDismissDisabled = false
                    }
                case .complete:
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.interactiveDismissDisabled = false
                    }
                default:
                    print("Upgrade state changed: \(state)")
                }
            }
        )
    }
}
