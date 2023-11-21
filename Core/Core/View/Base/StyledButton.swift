//
//  StyledButton.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI

public struct StyledButton: View {
    
    private let title: String
    private let action: () -> Void
    private let isTransparent: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private let buttonColor: Color
    private let textColor: Color
    private let isActive: Bool
    
    public init(_ title: String,
                action: @escaping () -> Void,
                isTransparent: Bool = false,
                color: Color = Theme.Colors.accentColor,
                isActive: Bool = true) {
        self.title = title
        self.action = action
        self.isTransparent = isTransparent
        if isActive {
            self.buttonColor = color
            self.textColor = Theme.Colors.styledButtonText
        } else {
            self.buttonColor = Theme.Colors.cardViewStroke
            self.textColor = Theme.Colors.textPrimary
        }
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
        )
        .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                    .foregroundColor(isTransparent ? Theme.Colors.white : .clear)
        )
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
