//
//  SocialAuthView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI
import Core

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
                .font(.system(size: 17, weight: .medium))
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
                .accessibilityLabel("\(title) \(AuthLocalization.facebook)")
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
