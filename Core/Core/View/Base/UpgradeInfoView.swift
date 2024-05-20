//
//  UpgradeInfoView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 8.05.24.
//

import SwiftUI
import Theme

public class UpgradeInfoViewModel: ObservableObject {
    let productName: String
    let sku: String
    let storeInteractor: StoreInteractorProtocol
    
    @Published var isLoading: Bool = false
    @Published var product: StoreProduct?
    @Published var error: Error?
    var price: String {
        guard let product = product, let price = product.localizedPrice else { return "" }
        return price
    }

    public init(productName: String, sku: String, storeInteractor: StoreInteractorProtocol ) {
        self.productName = productName
        self.sku = sku
        self.storeInteractor = storeInteractor
    }
    
    @MainActor
    func fetchProduct() async {
        do {
            isLoading = true
            self.product = try await storeInteractor.fetchProduct(sku: sku)
            isLoading = false
        } catch let error {
            self.error = error
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
                    StyledButton(
                        "\(CoreLocalization.CourseUpgrade.View.Button.upgradeNow) \(viewModel.price)",
                        action: {
                            
                        },
                        color: Theme.Colors.accentButtonColor,
                        textColor: Theme.Colors.styledButtonText,
                        leftImage: Image(systemName: "lock.fill"),
                        imagesStyle: .attachedToText,
                        isTitleTracking: false,
                        isLimitedOnPad: false)
                    .opacity(viewModel.isLoading ? 0 : 1)
                    
                    ProgressBar(size: 40, lineWidth: 8)
                        .opacity(viewModel.isLoading ? 1 : 0)
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
            storeInteractor: StoreInteractorMock(handler: StoreKitHandlerMock())
        )
    )
}
#endif
