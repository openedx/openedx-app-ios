//
//  SocialAuthView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI
import Core
import Theme

struct SocialAuthView: View {

    // MARK: - Properties

    @StateObject var viewModel: SocialAuthViewModel

    init(
        authType: SocialAuthType = .signIn,
        viewModel: SocialAuthViewModel
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.authType = authType
    }

    enum SocialAuthType {
        case signIn
        case register
    }
    var authType: SocialAuthType = .signIn

    private var title: String {
        switch authType {
        case .signIn:
            AuthLocalization.signInWith
        case .register:
            AuthLocalization.registerWith
        }
    }

    // MARK: - Views

    var body: some View {
        VStack(spacing: 10) {
            headerView
            buttonsView
        }
        .padding(.bottom, 20)
    }

    private var headerView: some View {
        HStack {
            Text("\(AuthLocalization.or) \(title.lowercased()):")
                .padding(.vertical, 20)
                .font(Theme.Fonts.labelLarge)
                .accessibilityIdentifier("social_auth_title_text")
            Spacer()
        }
    }

    private var buttonsView: some View {
        Group {
            if viewModel.googleEnabled {
                SocialAuthButton(
                    image: CoreAssets.iconGoogleWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.google)",
                    textColor: .black,
                    backgroundColor: CoreAssets.googleButtonColor.swiftUIColor,
                    action: { Task { await viewModel.signInWithGoogle() } }
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.google)")
                .accessibilityIdentifier("social_auth_google_button")
            }
            if viewModel.faceboolEnabled {
                SocialAuthButton(
                    image: CoreAssets.iconFacebookWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.facebook)",
                    backgroundColor: CoreAssets.facebookButtonColor.swiftUIColor,
                    action: { Task { await viewModel.signInWithFacebook() } }
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.facebook)")
                .accessibilityIdentifier("social_auth_facebook_button")
            }
            if viewModel.microsoftEnabled {
                SocialAuthButton(
                    image: CoreAssets.iconMicrosoftWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.microsoft)",
                    backgroundColor: CoreAssets.microsoftButtonColor.swiftUIColor,
                    action: { Task { await viewModel.signInWithMicrosoft() } }
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.microsoft)")
                .accessibilityIdentifier("social_auth_microsoft_button")
            }
            if viewModel.appleSignInEnabled {
                SocialAuthButton(
                    image: CoreAssets.iconApple.swiftUIImage,
                    title: "\(title) \(AuthLocalization.apple)",
                    backgroundColor: CoreAssets.appleButtonColor.swiftUIColor,
                    action: viewModel.signInWithApple
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.apple)")
                .accessibilityIdentifier("social_auth_apple_button")
            }
        }
    }
}

#if DEBUG
struct SocialSignView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SocialAuthViewModel(config: ConfigMock(), completion: { _ in })
        SocialAuthView(viewModel: vm).padding()
    }
}
#endif
