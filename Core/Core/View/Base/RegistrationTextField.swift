//
//  RegistrationTextField.swift
//  Core
//
//  Created by  Stepanok Ivan on 03.11.2022.
//

import SwiftUI

public struct RegistrationTextField: View {
    
    @State public var shakeIt: Bool = false
    @State public var placeholder: String = ""
    public var keyboardType: UIKeyboardType
    public var textContentType: UITextContentType
    private var isTextArea: Bool
    private var scrollTo: (() -> Void) = {}
    
    @ObservedObject
    private var config: FieldConfiguration
    
    public init(config: FieldConfiguration,
                isTextArea: Bool = false,
                keyboardType: UIKeyboardType = .default,
                textContentType: UITextContentType = .name) {
        self.config = config
        self.isTextArea = isTextArea
        self.keyboardType = keyboardType
        self.textContentType = textContentType
        //UITextView.appearance().backgroundColor = CoreAssets.textInputColor.color
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if config.field.label != "" {
                Text(config.field.label)
                    .font(Theme.Fonts.labelLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .padding(.top, 18)
            }
            if isTextArea {
                TextEditor(text: $config.text)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .frame(height: 100)
                    .hideScrollContentBackground()
                    .background(
                        Theme.Shapes.textInputShape
                            .fill(Theme.Colors.textInputBackground)
                    )
                
                    .overlay(
                        Theme.Shapes.textInputShape
                            .stroke(lineWidth: 1)
                            .fill(
                                config.error == "" ?
                                Theme.Colors.textInputStroke
                                : Color.red
                            )
                    )
                    .shake($config.shake)
            } else {
                if textContentType == .password {
                    SecureField(placeholder, text: $config.text)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.all, 14)
                        .background(
                            Theme.Shapes.textInputShape
                                .fill(Theme.Colors.textInputBackground)
                        )
                        .overlay(
                            Theme.Shapes.textInputShape
                                .stroke(lineWidth: 1)
                                .fill(
                                    config.error == "" ?
                                    Theme.Colors.textInputStroke
                                    : Color.red
                                )
                        )
                        .shake($config.shake)
                } else {
                    TextField(placeholder, text: $config.text)
                        .keyboardType(keyboardType)
                        .textContentType(textContentType)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.all, 14)
                        .background(
                            Theme.Shapes.textInputShape
                                .fill(Theme.Colors.textInputBackground)
                        )
                        .overlay(
                            Theme.Shapes.textInputShape
                                .stroke(lineWidth: 1)
                                .fill(
                                    config.error == "" ?
                                    Theme.Colors.textInputStroke
                                    : Color.red
                                )
                        )
                        .shake($config.shake)
                }
            }
            
            Text(config.error == "" ? config.field.instructions : config.error)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(config.error == ""
                                 ? Theme.Colors.textSecondary
                                 : Color.red)
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationTextField(config:
                                FieldConfiguration(field:
                                                    PickerFields(
                                                        type: .email,
                                                        label: "Email",
                                                        required: true,
                                                        name: "email",
                                                        instructions: "This is what you will use to login.",
                                                        options: [])),
                              isTextArea: false,
                              keyboardType: .default,
                              textContentType: .name)
        .padding()
    }
}
