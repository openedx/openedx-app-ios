//
//  CourseUpgradeUnlockView.swift
//  Core
//
//  Created by Saeed Bashir on 5/8/24.
//

import SwiftUI
import Theme

public struct CourseUpgradeUnlockView: View {
    
    public init() {
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            Theme.Colors.background
            VStack(spacing: 20) {
                ProgressBar(size: 40, lineWidth: 8)
                    .padding(20)
                    .accessibilityIdentifier("progressbar")
                
                VStack(spacing: 10) {
                    Text(CoreLocalization.CourseUpgrade.unlockingText)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .font(Theme.Fonts.titleLarge)
                    Text(CoreLocalization.CourseUpgrade.unlockingFullAccess)
                        .foregroundColor(Theme.Colors.accentColor)
                        .font(Theme.Fonts.titleLarge)
                    Text(CoreLocalization.CourseUpgrade.unlockingToCourse)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .font(Theme.Fonts.titleLarge)
                }
                .accessibilityIdentifier("unlock_text")
                
                ThemeAssets.campaignLaunch.swiftUIImage
                    .resizable()
                    .frame(maxWidth: 200, maxHeight: 200)
            }
        }
        .ignoresSafeArea()
    }
}
