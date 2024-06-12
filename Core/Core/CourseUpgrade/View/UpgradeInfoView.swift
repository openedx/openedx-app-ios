//
//  UpgradeInfoView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

public struct UpgradeInfoView<Content>: View where Content: View {
    let isFindCourseButtonVisible: Bool
    private let headerView: () -> Content
    private let findAction: (() -> Void)?
    @StateObject var viewModel: UpgradeInfoViewModel
    
    public init(
        isFindCourseButtonVisible: Bool,
        image: Image? = nil,
        viewModel: UpgradeInfoViewModel,
        findAction: (() -> Void)? = nil,
        @ViewBuilder headerView: @escaping () -> Content = {EmptyView()}
    ) {
        self.isFindCourseButtonVisible = isFindCourseButtonVisible
        self._viewModel = .init(wrappedValue: viewModel)
        self.headerView = headerView
        self.findAction = findAction
    }
    
    private var shouldHideText: Bool {
        viewModel.isLoading && !viewModel.price.isEmpty
    }
    
    private var shouldHideButton: Bool {
        viewModel.isLoading
    }
    
    private var buttonText: String {
        shouldHideText ? "" : "\(CoreLocalization.CourseUpgrade.View.Button.upgradeNow) \(viewModel.price)"
    }
    
    private var buttonImage: Image? {
        shouldHideText ? nil : Image(systemName: "lock.fill")
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                headerView()
                VStack(alignment: .leading, spacing: 20) {
                    if !viewModel.productName.isEmpty {
                        Text("\(CoreLocalization.CourseUpgrade.View.title) \(viewModel.productName)")
                            .font(Theme.Fonts.titleLarge)
                    }
                    
                    if !viewModel.message.isEmpty {
                        Text(viewModel.message)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(Theme.Fonts.bodyLarge)
                    }
                    
                    UpgradeOptionsView()
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
            }
            Spacer(minLength: 20)
            if isFindCourseButtonVisible {
                StyledButton(
                    CoreLocalization.CourseUpgrade.Button.findCourse,
                    action: {
                        findAction?()
                    },
                    isTransparent: true,
                    isTitleTracking: false
                )
                .frame(height: 42)
                .colorMultiply(Theme.Colors.accentColor)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            ZStack {
                if viewModel.error == nil && !viewModel.sku.isEmpty {
                    StyledButton(
                        buttonText,
                        action: {
                            Task {
                                await viewModel.purchase()
                            }
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
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
        .task {
            await viewModel.fetchProduct()
        }
    }
}

#if DEBUG
#Preview {
    UpgradeInfoView(
        isFindCourseButtonVisible: true,
        viewModel: UpgradeInfoViewModel(
            productName: "Preview",
            message: "",
            sku: "SKU",
            courseID: "",
            screen: .dashboard,
            handler: CourseUpgradeHandlerProtocolMock(),
            pacing: "self",
            analytics: CoreAnalyticsMock(),
            router: BaseRouterMock()
        ),
        findAction: nil
    )
}
#endif
