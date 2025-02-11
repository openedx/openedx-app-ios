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
        AuthLocalization.continueWith
    }
    
    private var bottomViewText: String {
        switch authType {
        case .signIn:
            AuthLocalization.orSignInWith
        case .register:
            AuthLocalization.orRegisterWith
        }
    }
    
    // MARK: - Views
    
    var body: some View {
        VStack(spacing: 16) {
            headerView
            buttonsView
            bottomView
        }
        .frame(maxWidth: .infinity)
    }
    
    private var headerView: some View {
        HStack {
            Text(title)
                .font(Theme.Fonts.bodyMedium)
                .accessibilityIdentifier("social_auth_title_text")
            Spacer()
        }
    }
    
    private var buttonsView: some View {
        HStack {
            if let lastOption = viewModel.lastUsedOption,
               authType == .signIn {
                Text(AuthLocalization.lastSignIn)
                    .font(Theme.Fonts.bodySmall)
                    .foregroundStyle(Theme.Colors.textPrimary)
                
                socialAuthButton(lastOption)
                    .padding(.leading, 10)
                
                Divider()
                    .frame(width: 1)
                    .overlay(Theme.Colors.socialAuthColor)
                    .padding(.horizontal, 16)
                    .opacity(viewModel.enabledOptions.count == 1 ? 0 : 1)
                
                Spacer()
            }
            
            HStack {
                ForEach(viewModel.enabledOptions, id: \.self) { option in
                    if option != viewModel.lastUsedOption || authType != .signIn {
                        socialAuthButton(option)
                            .padding(.trailing, option == viewModel.enabledOptions.last ? 0 : 12)
                    }
                }
                Spacer()
            }
        }
        .frame(height: 42)
    }
    
    private func socialAuthButton(
        _ option: SocialAuthMethod
    ) -> SocialAuthButton {
        switch option {
        case .google:
            return SocialAuthButton(
                image: CoreAssets.iconGoogleWhite.swiftUIImage,
                accessibilityLabel: "\(title) \(AuthLocalization.google)",
                accessibilityIdentifier: "social_auth_google_button",
                action: { Task { await viewModel.signInWithGoogle() }}
            )
        case .apple:
            return SocialAuthButton(
                image: CoreAssets.iconApple.swiftUIImage,
                accessibilityLabel: "\(title) \(AuthLocalization.apple)",
                accessibilityIdentifier: "social_auth_apple_button",
                action: { Task { viewModel.signInWithApple() }}
            )
        case .facebook:
            return SocialAuthButton(
                image: CoreAssets.iconFacebook.swiftUIImage,
                accessibilityLabel: "\(title) \(AuthLocalization.facebook)",
                accessibilityIdentifier: "social_auth_facebook_button",
                action: { Task { await viewModel.signInWithFacebook() }}
            )
        case .microsoft:
            return SocialAuthButton(
                image: CoreAssets.iconMicrosoftWhite.swiftUIImage,
                accessibilityLabel: "\(title) \(AuthLocalization.microsoft)",
                accessibilityIdentifier: "social_auth_microsoft_button",
                action: { Task { await viewModel.signInWithMicrosoft() }}
            )
        }
    }
    
    private var bottomView: some View {
        HStack {
            Text(bottomViewText)
                .font(Theme.Fonts.bodyMedium)
                .accessibilityIdentifier("social_auth_or_signin_with_text")
            Spacer()
        }
        .padding(.top, 16)
    }
}

#if DEBUG
struct SocialSignView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = SocialAuthViewModel(
            config: ConfigMock(),
            lastUsedOption: nil,
            completion: { _ in }
        )
        SocialAuthView(viewModel: vm).padding()
    }
}
#endif
