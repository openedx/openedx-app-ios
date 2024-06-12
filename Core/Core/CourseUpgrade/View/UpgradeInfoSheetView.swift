//
//  UpgradeInfoSheetView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

public struct UpgradeInfoSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: UpgradeInfoViewModel
    
    public init(viewModel: UpgradeInfoViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        NavigationView {
            UpgradeInfoView(
                isFindCourseButtonVisible: false,
                viewModel: viewModel
            )
            .background {
                Theme.Colors.background
                    .ignoresSafeArea()
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
    UpgradeInfoSheetView(
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
        )
    )
}
#endif
