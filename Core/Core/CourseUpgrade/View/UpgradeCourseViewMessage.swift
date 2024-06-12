//
//  UpgradeCourseViewMessage.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

public struct UpgradeCourseViewMessage: View {
    let message: String
    let icon: Image
    @Binding var coordinate: CGFloat
    @Binding var collapsed: Bool
    @Binding var shouldShowUpgradeButton: Bool
    @Binding var shouldHideMenuBar: Bool
    let backAction: (() -> Void)?
    
    public init(
        message: String,
        icon: Image,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        shouldShowUpgradeButton: Binding<Bool>,
        shouldHideMenuBar: Binding<Bool>,
        backAction: (() -> Void)?
    ) {
        self.message = message
        self.icon = icon
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._shouldShowUpgradeButton = shouldShowUpgradeButton
        self._shouldHideMenuBar = shouldHideMenuBar
        self.backAction = backAction
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            DynamicOffsetView(
                coordinate: $coordinate,
                collapsed: $collapsed,
                shouldShowUpgradeButton: $shouldShowUpgradeButton,
                shouldHideMenuBar: $shouldHideMenuBar
            )
            ZStack {
                VStack(spacing: 24) {
                    icon
                        .resizable()
                        .frame(width: 96, height: 96)
                    Text(message)
                        .multilineTextAlignment(.center)
                        .font(Theme.Fonts.bodyLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                }
                VStack {
                    Spacer()
                    StyledButton(CoreLocalization.CourseUpgrade.Button.back) {
                        backAction?()
                    }
                }
            }
            .padding(24)
        }
    }
}

#if DEBUG
#Preview {
    UpgradeCourseViewMessage(
        message: "Some message",
        icon: CoreAssets.upgradeCalendarImage.swiftUIImage,
        coordinate: .constant(0),
        collapsed: .constant(false),
        shouldShowUpgradeButton: .constant(true),
        shouldHideMenuBar: .constant(false),
        backAction: nil
    )
}
#endif
