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
    
    public init(_ text: Binding<String>, placeholder: String = "") {
        self._text = text
        self.placeholder = placeholder
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
            }.padding(.trailing, 32)

            Button(action: {
                isSecured.toggle()
            }) {
                Image(systemName: self.isSecured ? "eye.slash" : "eye")
                    .accentColor(Theme.Colors.textInputPlaceholderColor)
            }
            .frame(height: 23)
        }
    }
}
