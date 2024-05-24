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
            content
                .onAppear {
                    viewModel.isOnScreen = true
                }
                .onDisappear {
                    viewModel.isOnScreen = false
                }
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        if viewModel.showPaymentSuccess {
                            SnackBarView(
                                message: CoreLocalization.CourseUpgrade.successMessage,
                                textColor: Theme.Colors.white,
                                bgColor: Theme.Colors.success
                            )
                                .transition(.move(edge: .bottom))
                                .onAppear {
                                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                        viewModel.showPaymentSuccess = false
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .animation(.easeInOut, value: viewModel.showPaymentSuccess)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
    }
}

public class UpgradeInfoViewModel: ObservableObject {
    let productName: String
    let sku: String
    let courseID: String
    let screen: CourseUpgradeScreen
    let handler: CourseUpgradeHandlerProtocol
    
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
        sku: String,
        courseID: String,
        screen: CourseUpgradeScreen,
        handler: CourseUpgradeHandlerProtocol
    ) {
        self.productName = productName
        self.sku = sku
        self.courseID = courseID
        self.screen = screen
        self.handler = handler
    }
    
    @MainActor
    func fetchProduct() async {
        do {
            isLoading = true
            self.product = try await handler.fetchProduct(sku: sku)
            isLoading = false
        } catch let error {
            self.error = error
        }
    }

    func purchase() {
        isLoading = true
        interactiveDismissDisabled = true
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
                        if !viewModel.interactiveDismissDisabled {
                            dismiss()
                        }
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .accessibilityIdentifier("close_button")
                }
            }
        }
        .interactiveDismissDisabled(viewModel.interactiveDismissDisabled)
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
            handler: CourseUpgradeHandlerProtocolMock()
        )
    )
}
#endif
