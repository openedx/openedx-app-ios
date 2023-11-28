//
//  SocialSignView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI
import Core

struct SocialSignView: View {

    // MARK: - Properties

    @StateObject var viewModel: SocialSignViewModel

    init(
        signType: SignType = .signIn,
        viewModel: SocialSignViewModel
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.signType = signType
    }

    enum SignType {
        case signIn
        case register
    }
    var signType: SignType = .signIn

    private var title: String {
        switch signType {
        case .signIn:
            return AuthLocalization.signInWith
        case .register:
            return AuthLocalization.signInRegister
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
            if viewModel.config.google.enabled {
                LabelButton(
                    image: CoreAssets.iconGoogleWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.google)",
                    textColor: .black,
                    backgroundColor: CoreAssets.googleButtonColor.swiftUIColor,
                    action: viewModel.signInWithGoogle
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.facebook)")
            }
            if viewModel.config.facebook.enabled {
                LabelButton(
                    image: CoreAssets.iconFacebookWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.facebook)",
                    backgroundColor: CoreAssets.facebookButtonColor.swiftUIColor,
                    action: viewModel.signInWithFacebook
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.facebook)")
            }
            if viewModel.config.microsoft.enabled {
                LabelButton(
                    image: CoreAssets.iconMicrosoftWhite.swiftUIImage,
                    title: "\(title) \(AuthLocalization.microsoft)",
                    backgroundColor: CoreAssets.microsoftButtonColor.swiftUIColor,
                    action: viewModel.signInWithMicrosoft
                )
                .accessibilityElement(children: .ignore)
                .accessibilityLabel("\(title) \(AuthLocalization.microsoft)")
            }
            if viewModel.config.appleSignIn.enable {
                LabelButton(
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
        let vm = SocialSignViewModel(config: ConfigMock(), completion: { _ in })
        SocialSignView(viewModel: vm).padding()
    }
}
#endif
