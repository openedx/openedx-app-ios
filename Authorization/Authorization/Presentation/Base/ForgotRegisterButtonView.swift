//
//  ForgotRegisterButtonView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct ForgotRegisterButtonView: View {

    public let onRegister: () -> Void
    public let onForgot: () -> Void

    public var body: some View {
        HStack {
            Button(AuthLocalization.SignIn.registerBtn) {
                onRegister()
            }.foregroundColor(Theme.Colors.accentColor)

            Spacer()

            Button(AuthLocalization.SignIn.forgotPassBtn) {
                onForgot()
            }.foregroundColor(Theme.Colors.accentColor)
        }
    }
}
