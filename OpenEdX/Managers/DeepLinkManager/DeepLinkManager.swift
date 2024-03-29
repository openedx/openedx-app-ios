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
import Course
import Profile

// swiftlint:disable function_body_length type_body_length
//sourcery: AutoMockable
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
    private let courseInteractor: CourseInteractorProtocol
    private let profileInteractor: ProfileInteractorProtocol

    var userloggedIn: Bool {
       return !(storage.user?.username?.isEmpty ?? true)
   }

    public init(
        config: ConfigProtocol,
        router: DeepLinkRouter,
        storage: CoreStorage,
        discoveryInteractor: DiscoveryInteractorProtocol,
        discussionInteractor: DiscussionInteractorProtocol,
        courseInteractor: CourseInteractorProtocol,
        profileInteractor: ProfileInteractorProtocol
    ) {
        self.config = config
        self.router = router
        self.storage = storage
        self.discoveryInteractor = discoveryInteractor
        self.discussionInteractor = discussionInteractor
        self.courseInteractor = courseInteractor
        self.profileInteractor = profileInteractor

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

        let isAppActive = UIApplication.shared.applicationState == .active

        Task {
            if isAppActive {
                await showNotificationAlert(link)
            } else {
                await navigateToScreen(with: link.type, link: link)
            }
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
        router.dismissPresentedViewController()

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
            type: .deepLink
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

    private func isHandout(type: DeepLinkType) -> Bool {
        type == .courseHandout ||
        type == .courseAnnouncement
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
            .courseAnnouncement,
            .discussionTopic,
            .discussionPost,
            .discussionComment:
            await showCourseScreen(with: type, link: link)
        case .program, .programDetail:
            guard config.program.enabled else { return }
            if let pathID = link.pathID, !pathID.isEmpty {
                router.showProgram(pathID: pathID)
                return
            }
            router.showTabScreen(tab: .programs)
        case .profile:
            router.showTabScreen(tab: .profile)
        case .userProfile:
            await showEditProfile()
        case .courseComponent:
            guard let courseID = link.courseID else { return }
            do {
                let courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: courseID)
                router.showCourseComponent(
                    componentID: link.componentID ?? "",
                    courseStructure: courseStructure,
                    blockLink: ""
                )
                router.showTabScreen(tab: .dashboard)
            } catch {
                router.dismissProgress()
            }
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
            guard let pathID = link.pathID ?? link.courseID, !pathID.isEmpty else {
                router.showTabScreen(tab: .discovery)
                return
            }
            router.showDiscoveryDetails(link: link, pathID: pathID)
        default:
            break
        }
    }

    @MainActor
    private func showCourseScreen(with type: DeepLinkType, link: DeepLink) async {
        guard let courseID = link.courseID, !courseID.isEmpty else {
            return
        }

        do {
            let courseDetails =  try await discoveryInteractor.getCourseDetails(
                courseID: courseID
            )

            router.showCourseDetail(
                link: link,
                courseDetails: courseDetails
            ) { [weak self] in
                guard let self else {
                    return
                }

                if self.isHandout(type: type) {
                    self.router.showProgress()
                    Task {
                        do {
                            try await self.showHandout(link: link, courseDetails: courseDetails)
                            self.router.dismissProgress()
                        } catch {
                            self.router.dismissProgress()
                        }
                    }
                    return
                }

                if self.isDiscussionThreads(type: type) {
                    self.router.showProgress()
                    Task {
                        await self.showCourseDiscussion(link: link, courseDetails: courseDetails)
                        self.router.dismissProgress()
                    }
                    return
                }
            }
        } catch {
            router.dismissProgress()
        }
    }

    @MainActor
    private func showHandout(
        link: DeepLink,
        courseDetails: CourseDetails
    ) async throws {
        switch link.type {
        case .courseAnnouncement:
            let updates = try await courseInteractor.getUpdates(courseID: courseDetails.courseID)
            if updates.isEmpty {
                throw DeepLinkError.error(text: CoreLocalization.Error.unknownError)
            }
            router.showAnnouncement(courseDetails: courseDetails, updates: updates)
        case .courseHandout:
            let handouts = try await courseInteractor.getHandouts(courseID: courseDetails.courseID)
            router.showHandout(courseDetails: courseDetails, handouts: handouts)
        default:
            break
        }
    }

    @MainActor
    private func showCourseDiscussion(
        link: DeepLink,
        courseDetails: CourseDetails
    ) async {
        switch link.type {
        case .discussionTopic:
            guard let topicID = link.topicID,
                  !topicID.isEmpty else {
                return
            }

            guard let topics = try? await discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            ) else {
                return
            }

            router.showThreads(
                topicID: topicID,
                courseDetails: courseDetails,
                topics: topics
            )
        case .discussionPost:

            if let topicID = link.topicID,
               !topicID.isEmpty,
                let topics = try? await discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            ) {
                router.showThreads(
                    topicID: topicID,
                    courseDetails: courseDetails,
                    topics: topics
                )
            }

            if let threadID = link.threadID,
                !threadID.isEmpty,
                let userThread = try? await discussionInteractor.getThread(threadID: threadID) {
                router.showThread(
                    userThread: userThread
                )
            }

        case .discussionComment:
            if let topicID = link.topicID,
               !topicID.isEmpty,
                let topics = try? await discussionInteractor.getTopic(
                courseID: courseDetails.courseID,
                topicID: topicID
            ) {
                router.showThreads(
                    topicID: topicID,
                    courseDetails: courseDetails,
                    topics: topics
                )
            }

            if let threadID = link.threadID,
                !threadID.isEmpty,
                let userThread = try? await discussionInteractor.getThread(threadID: threadID) {
                router.showThread(
                    userThread: userThread
                )
            }

            if let commentID = link.commentID,
               !commentID.isEmpty,
               let comment = try? await self.discussionInteractor.getResponse(responseID: commentID),
               let parentID = comment.parentID,
               !parentID.isEmpty,
               let parentComment = try? await self.discussionInteractor.getResponse(responseID: parentID) {
                router.showComment(
                    comment: comment,
                    parentComment: parentComment.post
                )
            }
        default:
            break
        }
    }

    @MainActor
    private func showEditProfile() async {
        guard let userProfile = try? await profileInteractor.getMyProfile() else {
            return
        }
        router.showUserProfile(userProfile: userProfile)
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
        }
    }
}
// swiftlint:enable function_body_length type_body_length
