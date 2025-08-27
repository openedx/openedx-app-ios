//
//  CustomButton.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core
import Theme

struct WhatsNewNavigationButton: View {
    let type: ButtonType
    let action: () -> Void
    @EnvironmentObject var themeManager: ThemeManager
    
    enum ButtonType {
        case previous, next, done
    }
    
    var body: some View {
        Group {
            HStack(spacing: 4) {
                if type == .previous {
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(themeManager.theme.colors.secondaryButtonTextColor)
                }
                
                Text(type == .previous ? WhatsNewLocalization.buttonPrevious
                     : (type == .next ? WhatsNewLocalization.buttonNext : WhatsNewLocalization.buttonDone ))
                .foregroundColor(type == .previous ? themeManager.theme.colors.secondaryButtonTextColor : themeManager.theme.colors.white)
                .font(Theme.Fonts.labelLarge)
                
                if type == .next {
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundColor(themeManager.theme.colors.white)
                }
                
                if type == .done {
                    CoreAssets.checkmark.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(themeManager.theme.colors.white)
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
            .background(
                Theme.Shapes.buttonShape
                    .fill(
                        type == .previous
                        ? themeManager.theme.colors.secondaryButtonBGColor
                        : themeManager.theme.colors.accentButtonColor
                    )
            )
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(type == .previous ? WhatsNewLocalization.buttonPrevious
                                : (type == .next ? WhatsNewLocalization.buttonNext : WhatsNewLocalization.buttonDone ))
            .overlay(
                Theme.Shapes.buttonShape
                    .stroke(type == .previous
                            ? themeManager.theme.colors.secondaryButtonBorderColor
                            : themeManager.theme.colors.background, lineWidth: 1)
            )
            .onTapGesture { action() }
    }
}
