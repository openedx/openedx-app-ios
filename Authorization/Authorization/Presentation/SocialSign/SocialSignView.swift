//
//  SocialSignView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import SwiftUI
import Core

struct SocialSignView: View {

    // MARK: - Properties -

    @StateObject var viewModel: SocialSignViewModel

    init(
        signType: SignType = .signIn,
        onSigned: @escaping (Result<Socials, Error>) -> Void
    ) {
        let viewModel: SocialSignViewModel = .init(onSigned: onSigned)
        self._viewModel = .init(wrappedValue: viewModel)
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

    // MARK: - Views -

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
            LabelButton(
                image: CoreAssets.iconApple.swiftUIImage,
                title: "\(title) \(AuthLocalization.apple)",
                backgroundColor: .black,
                action: viewModel.signInWithApple
            )
            LabelButton(
                image: CoreAssets.iconGoogleWhite.swiftUIImage,
                title: "\(title) \(AuthLocalization.google)",
                backgroundColor: .blue,
                action: viewModel.signInWithGoogle
            )
            LabelButton(
                image: CoreAssets.iconFacebookWhite.swiftUIImage,
                title: "\(title) \(AuthLocalization.facebook)",
                backgroundColor: .blue,
                action: viewModel.signInWithFacebook
            )
            LabelButton(
                image: CoreAssets.iconMicrosoftWhite.swiftUIImage,
                title: "\(title) \(AuthLocalization.microsoft)",
                backgroundColor: .black,
                action: viewModel.signInWithMicrosoft
            )
        }
    }
}
