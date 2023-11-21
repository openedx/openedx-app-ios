//
//  CustomButton.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core

struct WhatsNewNavigationButton: View {
    let type: ButtonType
    let action: () -> Void
    
    enum ButtonType {
        case previous, next, done
    }
    
    var body: some View {
        Group {
            HStack(spacing: 4) {
                if type == .previous {
                    CoreAssets.Assets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(Theme.Colors.accentColor)
                }
                
                Text(type == .previous ? WhatsNewLocalization.buttonPrevious
                     : (type == .next ? WhatsNewLocalization.buttonNext : WhatsNewLocalization.buttonDone ))
                .foregroundColor(type == .previous ? Theme.Colors.accentColor : Theme.Colors.white)
                .font(Theme.Fonts.labelLarge)
                
                if type == .next {
                    CoreAssets.Assets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundColor(Theme.Colors.white)
                }
                
                if type == .done {
                    CoreAssets.Assets.checkmark.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(Theme.Colors.white)
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
            .background(type == .previous
                        ? Theme.Colors.background
                        : Theme.Colors.accentColor)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(type == .previous ? WhatsNewLocalization.buttonPrevious
                                : (type == .next ? WhatsNewLocalization.buttonNext : WhatsNewLocalization.buttonDone ))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(type == .previous
                            ? Theme.Colors.accentColor
                            : Theme.Colors.background, lineWidth: 1)
            )
            .onTapGesture { action() }
    }
}
