//
//  CourseUpgradeHandler.swift
//  Core
//
//  Created by Saeed Bashir on 4/23/24.
//

import Foundation

public enum CourseUpgradeScreen: String {
    case dashboard
    case courseDashboard = "course_dashboard"
    case courseComponent = "course_component"
    case unknown
}

public enum UpgradeMode: String {
    case silent
    case userInitiated = "user_initiated"
    case restore
}

public enum UpgradeState {
    case initial
    case basket
    case checkout
    case payment
    case verify
    case complete
    case error(UpgradeError)
}

public class CourseUpgradeHandler: CourseUpgradeHandlerProtocol {
    static var ecommerceURL: String = ""
    
    private var completion: UpgradeCompletionHandler?
    private var basketID: Int = 0
    private(set) var courseSku: String?
    private(set) var upgradeMode: UpgradeMode = .userInitiated
    private(set) var productInfo: StoreProductInfo?
    private var interactor: CourseUpgradeInteractorProtocol
    private var storeKitHandler: StoreKitHandlerProtocol
    private let helper: CourseUpgradeHelperProtocol
    private var courseID: String = ""
    private var componentID: String?

    private(set) var state: UpgradeState = .initial {
        didSet {
            helper.handleCourseUpgrade(
                upgradeHadler: self,
                state: upgradeState,
                delegate: nil)
            completion?(state)
        }
    }
    
    private var upgradeState: UpgradeCompletionState {
        switch state {
        case .initial:
            return .initial
        case .basket, .checkout, .payment:
            return .payment
        case .verify:
            return .fulfillment(showLoader: upgradeMode == .userInitiated)
        case .complete:
            return .success(courseID, componentID)
        case .error(let error):
            return .error(error)
        }
    }

    public init(config: ConfigProtocol,
                interactor: CourseUpgradeInteractorProtocol,
                storeKitHandler: StoreKitHandlerProtocol,
                helper: CourseUpgradeHelperProtocol
    ) {
        self.interactor = interactor
        self.storeKitHandler = storeKitHandler
        self.helper = helper
        CourseUpgradeHandler.ecommerceURL = config.ecommerceURL ?? ""
    }
    
    public func upgradeCourse(
        sku: String?,
        mode: UpgradeMode = .userInitiated,
        productInfo: StoreProductInfo?,
        pacing: String,
        courseID: String,
        componentID: String?,
        screen: CourseUpgradeScreen,
        completion: UpgradeCompletionHandler?
    ) async {
        self.completion = completion
        self.upgradeMode = mode
        self.courseID = courseID
        self.componentID = componentID
        self.productInfo = productInfo
        courseSku = sku
        guard let sku = sku, !sku.isEmpty else {
            state = .error(.generalError(error(message: "course sku is missing")))
            return
        }
        
        guard let productInfo = productInfo else {
            state = .error(.generalError(error(message: "product info is missing")))
            return
        }
        
        helper.setData(
            courseID: courseID,
            pacing: pacing,
            blockID: componentID,
            localizedCoursePrice: productInfo.localizedPrice ?? "",
            screen: screen
        )
        state = .initial
        await proceedWithUpgrade(sku: sku)
    }
    
    @MainActor
    private func proceedWithUpgrade(sku: String) async {
        state = .basket
        
        do {
            let basket = try await interactor.addBasket(sku: sku)
            basketID = basket.basketID
            await checkout(basketID: basketID, sku: sku)
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(.basketError(error))
            }
        }
    }
    
    @MainActor
    private func checkout(basketID: Int, sku: String) async {
        // Checkout API
        guard basketID > 0 else {
            state = .error(.checkoutError(error(message: "invalid basket id < zero")))
            return
        }
        
        state = .checkout
        do {
            _ = try await interactor.checkoutBasket(basketID: basketID)
            if upgradeMode != .userInitiated {
                await reverifyPayment()
            } else {
                let response = await makePayment(sku: sku)
                await verifyResponse(response)
            }
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(.checkoutError(error))
            }
        }
    }
    
    @MainActor
    private func makePayment(sku: String) async -> StoreKitUpgradeResponse {
        state = .payment
        return await storeKitHandler.purchaseProduct(sku)
    }
    
    private func verifyResponse(_ response: StoreKitUpgradeResponse) async {
        if let receipt = response.receipt, response.success {
            await verifyPayment(receipt)
        } else {
            await MainActor.run {
                state = .error(response.error ?? .paymentError(nil))
            }
        }
    }
    
    @MainActor
    private func verifyPayment(_ receipt: String) async {
        state = .verify
        
        do {
            try await interactor.fulfillCheckout(
                basketID: basketID,
                price: productInfo?.price ?? 0.0,
                currencyCode: productInfo?.currencySymbol ?? "",
                receipt: receipt
            )
            state = .complete
            
        } catch let error {
            if error.isInternetError {
                
            } else {
                state = .error(.verifyReceiptError(error))
            }
        }
    }
    
    // Give an option of retry to learner
    func reverifyPayment() async {
        let response = await storeKitHandler.purchaseReceipt()
        await verifyResponse(response)
    }
    
    public func fetchProduct(sku: String) async throws -> StoreProductInfo {
        try await storeKitHandler.fetchProduct(sku: sku)
    }
}

extension CourseUpgradeHandler {
    // IAP error messages

    fileprivate func error(message: String) -> Error {
        return NSError(domain: "edx.app.courseupgrade", code: 1010, userInfo: [NSLocalizedDescriptionKey: message])
    }
}
