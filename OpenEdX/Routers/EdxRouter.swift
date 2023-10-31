//
//  EdxRouter.swift
//  OpenEdX
//
//  Created by Eugene Yatsenko on 26.10.2023.
//

import UIKit
import SwiftUI
import Core
import Authorization
import Swinject
import Kingfisher
import Course
import Discussion
import Discovery
import Dashboard
import Profile
import Combine

public class EdxRouter: OpenEdxRouter {

    public override func showLoginScreen() {
        let view = SignInView(viewModel: Container.shared.resolve(SignInViewModel.self)!)
        let controller = UIHostingController(rootView: view)
        navigationController.setViewControllers([controller], animated: false)
    }

}
