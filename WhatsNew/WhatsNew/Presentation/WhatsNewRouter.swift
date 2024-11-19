//
//  WhatsNewRouter.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import Foundation
import Core

@MainActor
public protocol WhatsNewRouter: BaseRouter {
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class WhatsNewRouterMock: BaseRouterMock, WhatsNewRouter {
    public override init() {}
}
#endif
