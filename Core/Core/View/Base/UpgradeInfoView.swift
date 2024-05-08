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

    public init(productName: String) {
        self.productName = productName
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
                    Text("\(CoreLocalization.Payments.View.title) \(viewModel.productName)")
                        .font(Theme.Fonts.displaySmall)
                    UpgradeInfoCellView(title: CoreLocalization.Payments.Option.first)
                    UpgradeInfoCellView(title: CoreLocalization.Payments.Option.second)
                    UpgradeInfoCellView(title: CoreLocalization.Payments.Option.third)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            Spacer()
            StyledButton(
                CoreLocalization.Payments.Button.upgrade,
                action: {
                    
                },
                color: Theme.Colors.accentButtonColor,
                textColor: Theme.Colors.primaryButtonTextColor,
                leftImage: Image(systemName: "lock.fill"),
                imagesStyle: .attachedToText,
                isTitleTracking: false,
                isLimitedOnPad: false)
            .padding(20)
        }
    }
}

#if DEBUG
#Preview {
    UpgradeInfoView(viewModel: UpgradeInfoViewModel(productName: "Preview"))
}
#endif
