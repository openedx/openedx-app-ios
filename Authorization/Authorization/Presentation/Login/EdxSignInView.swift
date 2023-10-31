//
//  EdxSignInView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct EdxSignInView: View {

    @ObservedObject
    private var viewModel: SignInViewModel

    public init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack(alignment: .top) {
            AuthBackgroundView(image: CoreAssets.authBackground.swiftUIImage)
            SignInContentView(viewModel: viewModel)
            if case .error(let type, let message) = viewModel.state {
                AlertView(message: message, type: type)
            }
        }
        .hideNavigationBar()
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
    }
}
