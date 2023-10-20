//
//  CustomButton.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core

struct CustomButton: View {
    let type: ButtonType
    let action: () -> Void
    
    enum ButtonType {
        case previous, next, done
    }
    
    var body: some View {
        Group {
            HStack(spacing: 4) {
                if type == .previous {
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(Theme.Colors.accentColor)
                }
                
                Text(type == .previous ? WhatsNewLocalization.buttonPrevious
                     : (type == .next ? WhatsNewLocalization.buttonNext : WhatsNewLocalization.buttonDone ))
                .foregroundColor(type == .previous ? Theme.Colors.accentColor : Color.white)
                    .font(Theme.Fonts.labelLarge)
                
                if type == .next {
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .rotationEffect(Angle(degrees: 180))
                        .foregroundColor(Color.white)

                }
                
                if type == .done {
                    CoreAssets.check.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(Color.white)
                }
            }.padding(.horizontal, 20)
                .padding(.vertical, 9)
        }.fixedSize()
        .background(type == .previous
                    ? Theme.Colors.background
                    : Theme.Colors.accentColor)
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
