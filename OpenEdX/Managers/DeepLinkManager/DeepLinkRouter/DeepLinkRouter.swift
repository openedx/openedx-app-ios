//
//  DeepLinkRouter.swift
//  OpenEdX
//
//  Created by Eugene Yatsenko on 04.03.2024.
//

import Core
import SwiftUI
import Theme
import Discovery
import Discussion
import Course
import Profile

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
    func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure,
        blockLink: String
    )
    func showAnnouncement(
        courseDetails: CourseDetails,
        updates: [CourseUpdate]
    )
    func showHandout(
        courseDetails: CourseDetails,
        handouts: String?
    )
    func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics,
        isBlackedOut: Bool
    )
    func showThread(
        userThread: UserThread,
        isBlackedOut: Bool
    )
    func showComment(
        comment: UserComment,
        parentComment: Post,
        isBlackedOut: Bool
    )
    func showProgram(
        pathID: String
    )
    func showUserProfile(userProfile: UserProfile)
    func dismissPresentedViewController()
    func showProgress()
    func dismissProgress()
}

extension Router: DeepLinkRouter {

    // MARK: - DeepLinkRouter
    public func showDiscoveryDetails(
        link: DeepLink,
        pathID: String
    ) {
        switch link.type {
        case .discoveryCourseDetail:
            if hostDiscoveryWebview?.rootView.pathID == pathID {
                return
            }
            showTabScreen(tab: .discovery)
            showWebDiscoveryDetails(
                pathID: pathID,
                discoveryType: .courseDetail(pathID),
                sourceScreen: .discovery
            )
        case .discoveryProgramDetail:
            if hostProgramWebviewView?.rootView.pathID == pathID {
                return
            }
            showTabScreen(tab: .discovery)
            showWebProgramDetails(
                pathID: pathID,
                viewType: .programDetail
            )
        default:
            break
        }
    }

    public func showCourseDetail(
        link: DeepLink,
        courseDetails: CourseDetails,
        completion: @escaping () -> Void
    ) {
        let isCourseOpened = hostCourseContainerView?.rootView.courseID == courseDetails.courseID

        if !isCourseOpened {
            showTabScreen(tab: .dashboard)

            if courseDetails.isEnrolled {
                showCourseScreens(
                    courseID: courseDetails.courseID,
                    hasAccess: nil,
                    courseStart: courseDetails.courseStart,
                    courseEnd: courseDetails.courseEnd,
                    enrollmentStart: courseDetails.enrollmentStart,
                    enrollmentEnd: courseDetails.enrollmentEnd,
                    title: courseDetails.courseTitle,
                    courseRawImage: courseDetails.courseRawImage,
                    showDates: false,
                    lastVisitedBlockID: nil
                )
            } else {
                showCourseDetais(courseID: courseDetails.courseID, title: courseDetails.courseTitle)
            }
        }

        switch link.type {
        case .courseVideos,
            .courseDates,
            .discussions,
            .courseHandout,
            .courseAnnouncement,
            .courseDashboard,
            .courseComponent,
            .enroll,
            .addBetaTester:
            popToCourseContainerView(animated: false)
        default:
            break
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (isCourseOpened ? 0 : 1)) {
            switch link.type {
            case .courseDashboard:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.course.rawValue
            case .courseVideos:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.videos.rawValue
            case .courseDates, .courseComponent:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.dates.rawValue
            case .discussions, .discussionTopic, .discussionPost, .discussionComment:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.discussion.rawValue
            case .courseHandout, .courseAnnouncement:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.handounds.rawValue
            default:
                break
            }
            completion()
        }
    }

    public func showAnnouncement(
        courseDetails: CourseDetails,
        updates: [CourseUpdate]
    ) {
        guard let cssInjector = container.resolve(CSSInjector.self) else {
            return
        }

        showHandoutsUpdatesView(
            handouts: nil,
            announcements: updates,
            router: self,
            cssInjector: cssInjector,
            type: .announcements
        )
    }

    public func showHandout(
        courseDetails: CourseDetails,
        handouts: String?
    ) {
        guard let cssInjector = container.resolve(CSSInjector.self) else {
            return
        }

        showHandoutsUpdatesView(
            handouts: handouts,
            announcements: nil,
            router: self,
            cssInjector: cssInjector,
            type: .handouts
        )
    }

    public func showProgram(
        pathID: String
    ) {
        if hostProgramWebviewView?.rootView.pathID == pathID {
            return
        }
        showTabScreen(tab: .programs)
        showWebProgramDetails(
            pathID: pathID,
            viewType: .programDetail
        )
    }

    public func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics,
        isBlackedOut: Bool
    ) {
        popToCourseContainerView()

        let title = (topics.coursewareTopics.map {$0} + topics.nonCoursewareTopics.map {$0}).first?.name ?? ""
        showThreads(
            courseID: courseDetails.courseID,
            topics: topics,
            title: title,
            type: .courseTopics(topicID: topicID),
            isBlackedOut: isBlackedOut,
            animated: false
        )
    }

    public func showThread(
        userThread: UserThread,
        isBlackedOut: Bool
    ) {
        showThread(
            thread: userThread,
            postStateSubject: .init(.none),
            isBlackedOut: isBlackedOut,
            animated: false
        )
    }

    public func showComment(
        comment: UserComment,
        parentComment: Post,
        isBlackedOut: Bool
    ) {
        showComments(
            commentID: comment.commentID,
            parentComment: parentComment,
            threadStateSubject: .init(.none),
            isBlackedOut: isBlackedOut,
            animated: false
        )
    }

    public func showTabScreen(tab: MainTab) {
        dismiss()
        hostMainScreen?.rootView.viewModel.select(tab: tab)
    }

    public func showDiscovery() {
        dismiss()
        showDiscoveryScreen(sourceScreen: .startup)
    }

    public func showUserProfile(userProfile: UserProfile) {
        showTabScreen(tab: .profile)
        showEditProfile(userModel: userProfile, avatar: nil) { _, _ in
            NotificationCenter.default.post(
                name: .profileUpdated,
                object: nil
            )
        }

    }

    public func showProgress() {
        presentView(
            transitionStyle: .crossDissolve,
            animated: false
        ) {
            FullScreenProgressView()
        }
    }

    public func dismissProgress() {
        if let presentedViewController = getNavigationController()
            .presentedViewController as? UIHostingController<FullScreenProgressView> {
            presentedViewController.dismiss(animated: true)
        }
    }

    public func dismissPresentedViewController() {
        if let presentedViewController = getNavigationController().presentedViewController {
            presentedViewController.dismiss(animated: true)
        }
    }

    private func popToCourseContainerView(animated: Bool = false) {
        guard let hostCourseContainerView = hostCourseContainerView else {
            return
        }
        getNavigationController().popToViewController(
            hostCourseContainerView,
            animated: animated
        )
    }

    private var hostMainScreen: UIHostingController<MainScreenView>? {
        getNavigationController().viewControllers.firstAs(UIHostingController<MainScreenView>.self)
    }

    private var hostCourseContainerView: UIHostingController<CourseContainerView>? {
        getNavigationController().viewControllers.firstAs(UIHostingController<CourseContainerView>.self)
    }

    private var hostHandoutsUpdatesDetailView: UIHostingController<HandoutsUpdatesDetailView>? {
        getNavigationController().topViewController as? UIHostingController<HandoutsUpdatesDetailView>
    }

    private var hostDiscoveryWebview: UIHostingController<DiscoveryWebview>? {
        getNavigationController().topViewController as? UIHostingController<DiscoveryWebview>
    }

    private var hostProgramWebviewView: UIHostingController<ProgramWebviewView>? {
        getNavigationController().topViewController as? UIHostingController<ProgramWebviewView>
    }

    private func dismiss() {
        dismissPresentedViewController()
        backToRoot(animated: false)
    }

    public var currentCourseTabSelection: Int {
        self.hostCourseContainerView?.rootView.viewModel.selection ?? 0
    }
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
    public func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure,
        blockLink: String
    ) {}
    public func showAnnouncement(
        courseDetails: CourseDetails,
        updates: [CourseUpdate]
    ) {}
    public func showHandout(
        courseDetails: CourseDetails,
        handouts: String?
    ) {}
    public func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics,
        isBlackedOut: Bool
    ) {}
    public func showThread(
        userThread: UserThread,
        isBlackedOut: Bool
    ) {}
    public func showComment(
        comment: UserComment,
        parentComment: Post,
        isBlackedOut: Bool
    ) {}
    public func showProgram(
        pathID: String
    ) {}
    public func showUserProfile(userProfile: UserProfile) {}
    public func dismissPresentedViewController() {}
    public func showProgress() {}
    public func dismissProgress() {}
}
#endif
