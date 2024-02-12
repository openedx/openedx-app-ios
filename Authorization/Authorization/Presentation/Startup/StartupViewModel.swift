//
//  StartupViewModel.swift
//  Authorization
//
//  Created by SaeedBashir on 10/23/23.
//

import Foundation
import Core

public class StartupViewModel: ObservableObject {
    let router: AuthorizationRouter
    @Published var searchQuery: String?
    
    public init(
        router: AuthorizationRouter
    ) {
        self.router = router
    }
}
