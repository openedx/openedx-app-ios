//
//  LMSDirectoryRouter.swift
//  OpenEdX
//
//  Routes the app onward after the learner picks a platform in the LMS Directory
//  landing. Registered as `LMSSelectionRouting` so the feature's coordinator (in
//  Authorization) can hand control back to the app's navigation without the feature
//  depending on the app target.
//

import UIKit
import SwiftUI
import Core
import Authorization
import Swinject

final class LMSDirectoryRouter: LMSSelectionRouting {

    func presentDiscovery() { showSignIn() }

    func showLogin() { showSignIn() }

    func showLanding() {
        guard let navigation = Container.shared.resolve(UINavigationController.self) else { return }
        let landing = LMSDirectoryFeature.makeLandingController()
        navigation.setViewControllers([landing], animated: true)
    }

    private func showSignIn() {
        guard let navigation = Container.shared.resolve(UINavigationController.self),
              let viewModel = Container.shared.resolve(
                  SignInViewModel.self,
                  argument: LogistrationSourceScreen.default
              )
        else { return }
        let controller = UIHostingController(rootView: SignInView(viewModel: viewModel))
        navigation.setViewControllers([controller], animated: true)
    }
}
