//
//  AuthorizationRouter.swift
//  Authorization
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol AuthorizationRouter: BaseRouter {}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class AuthorizationRouterMock: BaseRouterMock, AuthorizationRouter {

    public override init() {}

}
#endif
