//
//  AuthorizationRouter.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

/// @mockable
@MainActor
public protocol AuthorizationRouter: BaseRouter {
    func showUpdateRequiredView(showAccountLink: Bool)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class AuthorizationRouterMock: BaseRouterMock, AuthorizationRouter {
    public override init() {}
    public func showUpdateRequiredView(showAccountLink: Bool) {}
}
#endif
