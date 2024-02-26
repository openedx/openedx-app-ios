//
//  DeepLinkManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import UIKit

public protocol DeepLinkService {
    func configureWith(
        manager: DeepLinkManager,
        config: ConfigProtocol,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    )
    
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool
}

public class DeepLinkManager {
    private var services: [DeepLinkService] = []
    private let config: ConfigProtocol
    private let router: Router

    public init(config: ConfigProtocol, router: Router) {
        self.config = config
        self.router = router
        services = servicesFor(config: config)
    }
    
    private func servicesFor(config: ConfigProtocol) -> [DeepLinkService] {
        var deepServices: [DeepLinkService] = []
        // init deep link services
        if config.branch.enabled {
            deepServices.append(BranchService())
        }
        return deepServices
    }
    
    // check if any service is added (means enabled)
    var anyServiceEnabled: Bool {
        services.count > 0
    }
    
    // Configure services
    func configureDeepLinkService(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        for service in services {
            service.configureWith(manager: self, config: config, launchOptions: launchOptions)
        }
    }
    
    // Handle open url
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        for service in services where service.handledURLWith(app: app, open: url, options: options) {
            return true
        }
        return false
    }
    
    // This method do redirect with link from push notification
    func processLinkFromNotification(_ link: PushLink) {
        // redirect if possible
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [AnyHashable: Any]?) {
        guard let params = params else { return }
        debugLog(params, "processDeepLink")
        let deeplink = DeepLink(dictionary: params)
        if anyServiceEnabled && deeplink.type != .none {
            // redirect if possible
        }
    }

    private func isDiscovery(type: DeepLinkType) -> Bool {
        type == .discovery ||
        type == .discoveryCourseDetail ||
        type == .discoveryProgramDetail
    }

    private func navigateToScreen(with type: DeepLinkType, link: DeepLink) {

        if isDiscovery(type: type) {
            //showDiscovery(with: link)
        }

//        else if !isUserLoggedin() {
//            //showLoginScreen(with: link)
//            return
//        }

        switch type {
        case .courseDashboard, .courseVideos, .discussions, .courseDates, .courseComponent:
            //showCourseDashboardViewController(with: link)
            break
        case .program:
            guard config.program.enabled else { return }
            //showPrograms(with: link)
            break
        case .programDetail:
            guard config.program.enabled else { return }
            //showProgramDetail(with: link)
            break
        case .profile:
            //showUserProfile(with: link)
            break
        case .userProfile:
            //showUserProfile(with: link)
            break
        case .discussionTopic:
            //showDiscussionTopic(with: link)
            break
        case .discussionPost:
            //showDiscussionResponses(with: link)
            break
        case .discussionComment:
            //showdiscussionComments(with: link)
            break
        case .courseHandout:
            //showCourseHandout(with: link)
            break
        case .courseAnnouncement:
            //showCourseAnnouncement(with: link)
            break
        default:
            break
        }
    }

}
