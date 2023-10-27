//
//  TitleTextField.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI

public struct TitleTextField: View {

    public let title: String
    public let placeholder: String
    public var keyboardType: UIKeyboardType
    public var textContentType: UITextContentType?
    public var style: UITextAutocapitalizationType
    public var isSecure: Bool = false
    public var allPadding: Double = 14

    @Binding public var text: String

    public init(
        title: String,
        placeholder: String,
        keyboardType: UIKeyboardType = .default,
        textContentType: UITextContentType? = nil,
        style: UITextAutocapitalizationType = .words,
        isSecure: Bool = false,
        allPadding: Double = 14,
        text: Binding<String>
    ) {
        self.title = title
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        self.style = style
        self.isSecure = isSecure
        self.allPadding = allPadding
        self._text = text
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.all, allPadding)
                    .background(
                        Theme.Shapes.textInputShape
                            .fill(Theme.Colors.textInputBackground)
                    )
                    .overlay(
                        Theme.Shapes.textInputShape
                            .stroke(lineWidth: 1)
                            .fill(Theme.Colors.textInputStroke)
                    )
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .textContentType(textContentType)
                    .autocapitalization(style)
                    .autocorrectionDisabled()
                    .padding(.all, allPadding)
                    .background(
                        Theme.Shapes.textInputShape
                            .fill(Theme.Colors.textInputBackground)
                    )
                    .overlay(
                        Theme.Shapes.textInputShape
                            .stroke(lineWidth: 1)
                            .fill(Theme.Colors.textInputStroke)
                    )
            }
        }
    }

}
