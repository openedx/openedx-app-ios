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
            // TODO: show error state
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
                .fill(Theme.Colors.accentColor)
                .opacity(0.1)
            Image(systemName: "checkmark")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Theme.Colors.accentColor)
                .font(.title.bold())
                .padding(8)
        }
        .frame(width: 30, height: 30)
    }
}

public struct UpgradeInfoView: View {
    @ObservedObject var viewModel: UpgradeInfoViewModel
    
    public init(viewModel: UpgradeInfoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("\(CoreLocalization.CourseUpgrade.View.title) \(viewModel.productName)")
                        .font(Theme.Fonts.displaySmall)
                    UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.first)
                    UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.second)
                    UpgradeInfoCellView(title: CoreLocalization.CourseUpgrade.View.Option.third)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            Spacer()
            ZStack {
                StyledButton(
                    CoreLocalization.CourseUpgrade.View.Button.upgradeNow,
                    action: {
                        
                    },
                    color: Theme.Colors.accentButtonColor,
                    textColor: Theme.Colors.primaryButtonTextColor,
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
        .task {
            await viewModel.fetchProduct()
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
