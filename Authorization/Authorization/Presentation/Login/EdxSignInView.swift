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
            AuthAlertView(
                showAlert: viewModel.showAlert,
                alertMessage: viewModel.alertMessage
            ) {
                viewModel.alertMessage = nil
            }
            SnackBarErrorView(
                showError: viewModel.showError,
                errorMessage: viewModel.errorMessage
            ) {
                viewModel.errorMessage = nil
            }
        }
        .hideNavigationBar()
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.all, edges: .horizontal)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
    }
}
