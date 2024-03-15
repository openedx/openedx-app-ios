//
//  StyledButton.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI
import Theme

public enum IconImagePosition {
    case left
    case right
    case none
}

public struct StyledButton: View {
    private let title: String
    private let action: () -> Void
    private let isTransparent: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private let buttonColor: Color
    private let textColor: Color
    private let isActive: Bool
    private let borderColor: Color
    private let iconImage: Image?
    private let iconPosition: IconImagePosition
    
    public init(_ title: String,
                action: @escaping () -> Void,
                isTransparent: Bool = false,
                color: Color = Theme.Colors.accentButtonColor,
                textColor: Color = Theme.Colors.styledButtonText,
                borderColor: Color = .clear,
                iconImage: Image? = nil,
                iconPosition: IconImagePosition = .none,
                isActive: Bool = true) {
        self.title = title
        self.action = action
        self.isTransparent = isTransparent
        self.textColor = textColor
        self.borderColor = borderColor
        self.buttonColor = color
        self.isActive = isActive
        self.iconImage = iconImage
        self.iconPosition = iconPosition
    }
    
    public var body: some View {
        Button(action: action) {
            HStack {
                Spacer()
                if let icon = iconImage,
                    iconPosition == .left {
                    icon
                        .renderingMode(.template)
                        .foregroundStyle(textColor)
                }
                Text(title)
                    .tracking(isTransparent ? 0 : 1.3)
                    .foregroundColor(textColor)
                    .font(Theme.Fonts.labelLarge)
                    .opacity(isActive ? 1.0 : 0.6)
                if let icon = iconImage,
                    iconPosition == .right {
                    icon
                        .renderingMode(.template)
                        .foregroundStyle(textColor)
                }
                Spacer()
            }
        }
        .disabled(!isActive)
        .frame(maxWidth: idiom == .pad ? 260: .infinity, minHeight: isTransparent ? 36 : 42)
        .background(
            Theme.Shapes.buttonShape
                .fill(isTransparent ? .clear : buttonColor)
                .opacity(isActive ? 1.0 : 0.3)
        )
        .overlay(
            Theme.Shapes.buttonShape
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(isTransparent ? Theme.Colors.white : borderColor)
                .opacity(isActive ? 1.0 : 0.6)
        
        )
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
    }
}

struct StyledButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            StyledButton("Active Button", action: {}, isActive: true)
            StyledButton("Disabled button", action: {}, isActive: false)
            StyledButton(
                "Back Button",
                action: {},
                iconImage: CoreAssets.arrowLeft.swiftUIImage,
                iconPosition: .left,
                isActive: true
            )
        }
        .padding(20)
    }
}
