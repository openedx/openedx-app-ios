//
//  StartupViewModel.swift
//  Authorization
//
//  Created by SaeedBashir on 10/23/23.
//

import Foundation
import Core

@MainActor
public class StartupViewModel: ObservableObject {
    let router: AuthorizationRouter
    let analytics: CoreAnalytics
    let config: ConfigProtocol
    
    @Published var searchQuery: String?
    
    public init(
        router: AuthorizationRouter,
        analytics: CoreAnalytics,
        config: ConfigProtocol
    ) {
        self.router = router
        self.analytics = analytics
        self.config = config
    }
    
    func logAnalytics(searchQuery: String?) {
        if let searchQuery {
            analytics.trackEvent(
                .logistrationCoursesSearch,
                biValue: .logistrationCoursesSearch,
                parameters: [EventParamKey.searchQuery: searchQuery]
            )
        } else {
            analytics.trackEvent(.logistrationExploreAllCourses, biValue: .logistrationExploreAllCourses)
        }
    }
    
    func trackScreenEvent() {
        analytics.trackScreenEvent(.logistration, biValue: .logistration)
    }
}
