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
import SwiftUI
import Theme

// swiftlint:disable function_body_length
//sourcery: AutoMockable
public protocol DeepLinkRouter: BaseRouter {
    func showTabScreen(tab: MainTab)
    func showDiscovery()
    func showDiscoveryDetails(
        link: DeepLink,
        pathID: String
    )
    func showCourseDetail(
        link: DeepLink,
        courseDetails: CourseDetails,
        completion: @escaping () -> Void
    )
    func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics
    )
    func showThread(
        userThread: UserThread
    )
    func showComment(
        comment: UserComment,
        parentComment: Post
    )
    func showProgram(
        pathID: String
    )
    func showUserProfile(userName: String)
    func showProgress()
    func dismissProgress()
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DeepLinkRouterMock: BaseRouterMock, DeepLinkRouter {
    public override init() {}
    public func showTabScreen(tab: MainTab) {}
    public func showDiscovery() {}
    public func showDiscoveryDetails(
        link: DeepLink,
        pathID: String
    ) {}
    public func showCourseDetail(
        link: DeepLink,
        courseDetails: CourseDetails,
        completion: @escaping () -> Void
    ) {}
    public func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics
    ) {}
    public func showThread(
        userThread: UserThread
    ) {}
    public func showComment(
        comment: UserComment,
        parentComment: Post
    ) {}
    public func showProgram(
        pathID: String
    ) {}
    public func showUserProfile(userName: String) {}
    public func showProgress() {}
    public func dismissProgress() {}
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

        if UIApplication.shared.applicationState == .active {
            Task {
                await showNotificationAlert(link)
            }
            return
        }

        Task {
            await navigateToScreen(with: link.type, link: link)
        }
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [AnyHashable: Any]?) {
        guard let params = params else { return }
        let deeplink = DeepLink(dictionary: params)
        if anyServiceEnabled && deeplink.type != .none {
            Task {
                await navigateToScreen(with: deeplink.type, link: deeplink)
            }
        }
    }

    @MainActor
    private func showNotificationAlert(_ link: PushLink) {
        router.presentAlert(
            alertTitle: link.title ?? "",
            alertMessage: link.body ?? "",
            positiveAction: CoreLocalization.Alert.accept,
            onCloseTapped: { [weak self] in
                self?.router.dismiss(animated: true)
            },
            okTapped: { [weak self] in
                guard let self else {
                    return
                }
                Task {
                    self.router.dismiss(animated: true)
                    await self.navigateToScreen(with: link.type, link: link)
                }
            },
            type: .viewDeepLink
        )
    }

    private func isDiscovery(type: DeepLinkType) -> Bool {
        type == .discovery ||
        type == .discoveryCourseDetail ||
        type == .discoveryProgramDetail
    }

    private func isDiscussionThreads(type: DeepLinkType) -> Bool {
        type == .discussionPost ||
        type == .discussionTopic ||
        type == .discussionComment
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
            .discussionTopic,
            .discussionPost,
            .discussionComment:
            await showCourseScreen(with: type, link: link)
        case .program, .programDetail:
            guard config.program.enabled else { return }
            if let pathID = link.pathID {
                router.showProgram(pathID: pathID)
                return
            }
            router.showTabScreen(tab: .programs)
        case .profile:
            router.showTabScreen(tab: .profile)
        case .userProfile:
            guard let username = storage.user?.username else {
                return
            }
            router.showUserProfile(userName: username)
        default:
            break
        }
    }

    private func showDiscoveryScreen(with type: DeepLinkType, link: DeepLink) {
        switch type {
        case .discovery:
            if userloggedIn {
                router.showTabScreen(tab: .discovery)
                return
            }
            router.showDiscovery()
        case .discoveryCourseDetail, .discoveryProgramDetail:
            guard let pathID = link.pathID ?? link.courseID else {
                return
            }
            router.showDiscoveryDetails(link: link, pathID: pathID)
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
                if !self.isDiscussionThreads(type: type) {
                    self.router.dismissProgress()
                    return
                }

                Task {
                    do {
                        try await self.showCourseDiscussion(link: link, courseDetails: courseDetails)
                        self.router.dismissProgress()
                    } catch {
                        self.router.dismissProgress()
                    }
                }
            }
        } catch {
            self.router.dismissProgress()
        }
    }

    @MainActor
    private func showCourseDiscussion(
        link: DeepLink,
        courseDetails: CourseDetails
    ) async throws {
        switch link.type {
        case .discussionTopic:
            guard let topicID = link.topicID else {
                throw DeepLinkError.error(text: CoreLocalization.Error.unknownError)
            }

            let topics = try await discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            )
            router.showThreads(
                topicID: topicID,
                courseDetails: courseDetails,
                topics: topics
            )
        case .discussionPost:
            guard let threadID = link.threadID, let topicID = link.topicID else {
                throw DeepLinkError.error(text: CoreLocalization.Error.unknownError)
            }

            let topics = try await discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            )
            let userThread = try await discussionInteractor.getThread(threadID: threadID)

            router.showThreads(
                topicID: topicID,
                courseDetails: courseDetails,
                topics: topics
            )

            router.showThread(
                userThread: userThread
            )
        case .discussionComment:
            guard let threadID = link.threadID,
                  let topicID = link.topicID,
                  let commentID = link.commentID else {
                throw DeepLinkError.error(text: CoreLocalization.Error.unknownError)
            }

            let topics = try await self.discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            )
            let userThread = try await self.discussionInteractor.getThread(
                threadID: threadID
            )

            let comment = try await self.discussionInteractor.getResponse(responseID: commentID)

            guard  let parentID = comment.parentID else {
                throw DeepLinkError.error(text: CoreLocalization.Error.unknownError)
            }

            let parentComment = try await self.discussionInteractor.getResponse(responseID: parentID)

            router.showThreads(
                topicID: topicID,
                courseDetails: courseDetails,
                topics: topics
            )

            router.showThread(
                userThread: userThread
            )

            router.showComment(
                comment: comment,
                parentComment: parentComment.post
            )

        default:
            break
        }
    }
}

public enum DeepLinkError: Error {
    case error(text: String)
}

extension DeepLinkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error(let text):
            return text
        default:
            break
        }
    }
}
// swiftlint:enable function_body_length
