//
//  StyledButton.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI
import Theme

public struct StyledButton: View {
    private let title: String
    private let action: () -> Void
    private let isTransparent: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private let buttonColor: Color
    private let textColor: Color
    private let isActive: Bool
    private let borderColor: Color
    
    public init(_ title: String,
                action: @escaping () -> Void,
                isTransparent: Bool = false,
                color: Color = Theme.Colors.accentButtonColor,
                textColor: Color = Theme.Colors.styledButtonText,
                borderColor: Color = .clear,
                isActive: Bool = true) {
        self.title = title
        self.action = action
        self.isTransparent = isTransparent
        self.textColor = textColor
        self.borderColor = borderColor
        self.buttonColor = color
        self.isActive = isActive
    }
    
    public var body: some View {
        Button(action: action) {
            Text(title)
                .tracking(isTransparent ? 0 : 1.3)
                .foregroundColor(textColor)
                .font(Theme.Fonts.labelLarge)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
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
        }
        .padding(20)
    }
}
