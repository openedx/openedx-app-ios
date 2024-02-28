//
//  DeepLinkManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import UIKit
import Discovery
import Discussion

//sourcery: AutoMockable
public protocol DeepLinkRouter: BaseRouter {
    func showTabScreen(tab: MainTab)
    func showCourseDetail(link: DeepLink, courseDetails: CourseDetails, completion: @escaping () -> Void)
    func showThreads(link: DeepLink, courseDetails: CourseDetails, topics: Topics)
    func dismiss()
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DeepLinkRouterMock: BaseRouterMock, DeepLinkRouter {
    public override init() {}
    public func showTabScreen(tab: MainTab) {}
    public func showCourseDetail(link: DeepLink, courseDetails: CourseDetails, completion: @escaping () -> Void) {}
    public func showThreads(link: DeepLink, courseDetails: CourseDetails, topics: Topics) {}
    public func dismiss() {}
}
#endif

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
    private let storage: CoreStorage
    private let router: DeepLinkRouter
    private let discoveryInteractor: DiscoveryInteractorProtocol
    private let discussionInteractor: DiscussionInteractorProtocol

    var userloggedIn: Bool {
       return !(storage.user?.username?.isEmpty ?? true)
   }

    public init(
        config: ConfigProtocol,
        router: DeepLinkRouter,
        storage: CoreStorage,
        discoveryInteractor: DiscoveryInteractorProtocol,
        discussionInteractor: DiscussionInteractorProtocol
    ) {
        self.config = config
        self.router = router
        self.storage = storage
        self.discoveryInteractor = discoveryInteractor
        self.discussionInteractor = discussionInteractor

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
        guard link.type != .none else {
            return
        }
        Task {
            await navigateToScreen(with: link.type, link: link)
        }
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [AnyHashable: Any]?) {
        guard let params = params else { return }
        debugLog(params, "processDeepLink")
        let deeplink = DeepLink(dictionary: params)
        if anyServiceEnabled && deeplink.type != .none {
            Task {
                await navigateToScreen(with: deeplink.type, link: deeplink)
            }
        }
    }

    private func isDiscovery(type: DeepLinkType) -> Bool {
        type == .discovery ||
        type == .discoveryCourseDetail ||
        type == .discoveryProgramDetail
    }

    @MainActor
    private func navigateToScreen(
        with type: DeepLinkType,
        link: DeepLink
    ) async {

        if isDiscovery(type: type) {
            showDiscoveryScreen(with: type, link: link)
            return
        }

        if !userloggedIn {
            router.backToRoot(animated: true)
            router.showLoginScreen(sourceScreen: .default)
            return
        }

        switch type {
        case .courseDashboard,
            .courseVideos,
            .discussions,
            .courseDates,
            .courseHandout,
            .discussionTopic:
            await showCourseScreen(with: type, link: link)
        case .program:
            guard config.program.enabled else { return }
        case .programDetail:
            guard config.program.enabled else { return }
        case .profile:
            router.showTabScreen(tab: .profile)
        case .userProfile:
            break
        case .discussionPost:
            break
        case .discussionComment:
            break
        default:
            break
        }
    }

    private func showDiscoveryScreen(with type: DeepLinkType, link: DeepLink) {
        switch type {
        case .discovery:
            router.showTabScreen(tab: .discovery)
        case .discoveryCourseDetail:
            break
        case .discoveryProgramDetail:
            break
        default:
            break
        }
    }

    @MainActor
    private func showCourseScreen(with type: DeepLinkType, link: DeepLink) async {
        guard let courseID = link.courseID else {
            return
        }

        do {
            let courseDetails =  try await discoveryInteractor.getCourseDetails(
                courseID: courseID
            )

            router.showCourseDetail(link: link, courseDetails: courseDetails) { [weak self] in
                guard let self else {
                    return
                }

                switch link.type {
                case .discussionTopic:
                    Task {
                        let topics = try await self.discussionInteractor.getTopic(
                            courseID: courseDetails.courseID,
                            topicID: link.topicID!
                        )
                        self.router.showThreads(link: link, courseDetails: courseDetails, topics: topics)
                    }
                default:
                    break
                }
            }
        } catch {
            debugLog(error)
        }
    }

}
