//
//  SecureInputView.swift
//  Core
//
//  Created by Anton Yarmolenka on 25/07/2024.
//

import SwiftUI
import Theme

public struct SecureInputView: View {
    
    @Binding private var text: String
    @State private var isSecured: Bool = true
    private let placeholder: String
    private let accessibilityLabel: String
    
    /// The spoken name for the text field. It is applied to the field, not the whole view,
    /// so the Show password toggle keeps its own name. Defaults to `placeholder`;
    /// pass a value when the placeholder isn't a suitable name.
    public init(_ text: Binding<String>, placeholder: String = "", accessibilityLabel: String? = nil) {
        self._text = text
        self.placeholder = placeholder
        self.accessibilityLabel = accessibilityLabel ?? placeholder
    }
    
    public var body: some View {
        ZStack(alignment: .trailing) {
            Group {
                if isSecured {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .autocapitalization(.none)
                }
            }
            .accessibilityLabel(accessibilityLabel)
            .padding(.trailing, 32)

            Toggle(isOn: Binding(
                get: { !isSecured },
                set: { isSecured = !$0 }
            )) {
                Label {
                    Text(CoreLocalization.Accessibility.showPassword)
                } icon: {
                    Image(systemName: self.isSecured ? "eye.slash" : "eye")
                        .foregroundColor(Theme.Colors.textInputPlaceholderColor)
                }
            }
            .toggleStyle(PasswordVisibilityToggleStyle())
            .accessibilityLabel(CoreLocalization.Accessibility.showPassword)
        }
    }
}

// Shows only the existing eye icon while keeping the Toggle's built-in accessibility,
// so VoiceOver reads "Show password" with an on or off value.
private struct PasswordVisibilityToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .labelStyle(.iconOnly)
            .frame(height: 23)
            .contentShape(Rectangle())
            .onTapGesture { configuration.isOn.toggle() }
    }
}
