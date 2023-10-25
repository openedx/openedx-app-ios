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
    private let interactor: AuthInteractorProtocol
    private let analytics: AuthorizationAnalytics
    @Published var searchQuery: String?
    
    public init(
        interactor: AuthInteractorProtocol,
        router: AuthorizationRouter,
        analytics: AuthorizationAnalytics
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
    }
    
    func trackSigninClicked() {
        
    }
    
    func tracksignUpClicked() {
        analytics.signUpClicked()
    }
}
