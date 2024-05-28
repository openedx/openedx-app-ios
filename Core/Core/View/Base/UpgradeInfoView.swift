//
//  UpgradeInfoView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 8.05.24.
//

import Swinject
import SwiftUI
import Theme

import Combine
class PaymentSnackbarModifierViewModel: ObservableObject {
    @Published var showPaymentSuccess: Bool = false
    var isOnScreen: Bool = false
    private var cancellations: [AnyCancellable] = []
    init() {
        NotificationCenter.default
            .publisher(for: .courseUpgradeCompletionNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.isOnScreen {
                        self.showPaymentSuccess = true
                    }
                }
            }
            .store(in: &cancellations)
    }
}

extension View {
    public func paymentSnackbar() -> some View {
        modifier(PaymentSnackbarModifier())
    }
}

private struct PaymentSnackbarModifier: ViewModifier {
    @StateObject var viewModel: PaymentSnackbarModifierViewModel = .init()
    func body(content: Content) -> some View {
        ZStack {
            content
                .onAppear {
                    viewModel.isOnScreen = true
                }
                .onDisappear {
                    viewModel.isOnScreen = false
                }
            if viewModel.showPaymentSuccess {
                VStack {
                    Spacer()
                    SnackBarView(
                        message: CoreLocalization.CourseUpgrade.successMessage,
                        textColor: Theme.Colors.white,
                        bgColor: Theme.Colors.success
                    )
                }
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.showPaymentSuccess = false
                    }
                }
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeInOut, value: viewModel.showPaymentSuccess)
    }
}

public class UpgradeInfoViewModel: ObservableObject {
    let productName: String
    let sku: String
    let courseID: String
    let screen: CourseUpgradeScreen
    let handler: CourseUpgradeHandlerProtocol
    let analytics: CoreAnalytics
    
    @Published var isLoading: Bool = false
    @Published var product: StoreProductInfo?
    @Published var error: Error?
    var price: String {
        guard let product = product, let price = product.localizedPrice else { return "" }
        return price
    }

    public init(
        productName: String,
        sku: String,
        courseID: String,
        screen: CourseUpgradeScreen,
        handler: CourseUpgradeHandlerProtocol,
        analytics: CoreAnalytics
    ) {
        self.productName = productName
        self.sku = sku
        self.courseID = courseID
        self.screen = screen
        self.handler = handler
        self.analytics = analytics
    }
    
    @MainActor
    func fetchProduct() async {
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
        guard let topController = UIApplication.topViewController(),
        let error = error as? UpgradeError else { return }

        let alertController = UIAlertController().showAlert(
            withTitle: CoreLocalization.CourseUpgrade.FailureAlert.alertTitle,
            message: CoreLocalization.CourseUpgrade.FailureAlert.priceFetchErrorMessage,
            onViewController: topController) { _, _, _ in }

        if error != .productNotExist {
            alertController.addButton(
                withTitle: CoreLocalization.CourseUpgrade.FailureAlert.priceFetchError) { [weak self] _ in
                    guard let self else { return }
                    Task {
                        await self.fetchProduct()
                    }
                    
                    self.analytics.trackCourseUpgradeErrorAction(
                        courseID: self.courseID,
                        blockID: "",
                        pacing: "pacing",
                        coursePrice: "",
                        screen: self.screen,
                        errorAction: UpgradeErrorAction.reloadPrice.rawValue,
                        error: "price",
                        flowType: UpgradeMode.userInitiated.rawValue
                    )
                }
        }

        let cancelButtonTitle = error == .productNotExist ? CoreLocalization.ok : CoreLocalization.Alert.cancel
        alertController.addButton(withTitle: cancelButtonTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            self.error = error
            self.analytics.trackCourseUpgradeErrorAction(
                courseID: self.courseID,
                blockID: "",
                pacing: "pacing",
                coursePrice: "",
                screen: self.screen,
                errorAction: UpgradeErrorAction.close.rawValue,
                error: "price",
                flowType: UpgradeMode.userInitiated.rawValue
            )
        }
    }

    @MainActor
    func purchase() {
        isLoading = true
        Task {
            await handler.upgradeCourse(
                sku: sku,
                mode: .userInitiated,
                productInfo: product,
                pacing: "pacing",
                courseID: courseID,
                componentID: nil,
                screen: screen,
                completion: {[weak self] state in
                    guard let self else { return }
                    switch state {
                    case .verify:
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    case .error:
                        DispatchQueue.main.async {
                            self.isLoading = false
                        }
                    default:
                        debugPrint("Upgrade state changed: \(state)")
                    }
                }
            )
        }
    }
}

struct UpgradeInfoCellView: View {
    var title: String
    
    var body: some View {
        HStack(spacing: 10) {
            UpgradeInfoPointView()
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.bodyLarge)
        }
    }
}

struct UpgradeInfoPointView: View {
    var body: some View {
        ZStack {
            Circle()
                .fill(Theme.Colors.success)
                .opacity(0.1)
            Image(systemName: "checkmark")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Theme.Colors.success)
                .font(.title.bold())
                .padding(8)
        }
        .frame(width: 30, height: 30)
    }
}

public struct UpgradeInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UpgradeInfoViewModel
    
    public init(viewModel: UpgradeInfoViewModel) {
        self.viewModel = viewModel
    }
    
    private var shouldHideText: Bool {
        viewModel.isLoading && !viewModel.price.isEmpty
    }
    
    private var shouldHideButton: Bool {
        viewModel.isLoading && viewModel.price.isEmpty
    }
    
    private var buttonText: String {
        shouldHideText ? "" : "\(CoreLocalization.CourseUpgrade.View.Button.upgradeNow) \(viewModel.price)"
    }
    
    private var buttonImage: Image? {
        shouldHideText ? nil : Image(systemName: "lock.fill")
    }
    
    public var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("\(CoreLocalization.CourseUpgrade.View.title) \(viewModel.productName)")
                            .font(Theme.Fonts.titleLarge)
                        UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.first)
                        UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.second)
                        UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.third)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 30)
                }
                Spacer()
                ZStack {
                    if viewModel.error == nil {
                        StyledButton(
                            buttonText,
                            action: {
                                viewModel.purchase()
                            },
                            color: Theme.Colors.accentButtonColor,
                            textColor: Theme.Colors.styledButtonText,
                            leftImage: buttonImage,
                            imagesStyle: .attachedToText,
                            isTitleTracking: false,
                            isLimitedOnPad: false)
                        .opacity(shouldHideButton ? 0 : 1)
                        .disabled(viewModel.isLoading)
                        
                        ProgressBar(size: 30, lineWidth: 8)
                            .opacity(viewModel.isLoading ? 1 : 0)
                    }
                }
                .padding(20)
            }
            .background {
                Theme.Colors.background
                    .ignoresSafeArea()
            }
            .task {
                await viewModel.fetchProduct()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .accessibilityIdentifier("close_button")
                }
            }
        }
    }
}

#if DEBUG
#Preview {
    UpgradeInfoView(
        viewModel: UpgradeInfoViewModel(
            productName: "Preview",
            sku: "SKU",
            courseID: "",
            screen: .dashboard,
            handler: CourseUpgradeHandlerProtocolMock(),
            analytics: CoreAnalyticsMock()
        )
    )
}
#endif