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
        showTabScreen(tab: .discovery)
        switch link.type {
        case .discoveryCourseDetail:
            showWebDiscoveryDetails(
                pathID: pathID,
                discoveryType: .courseDetail(pathID),
                sourceScreen: .discovery
            )
        case .discoveryProgramDetail:
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
                    isActive: nil,
                    courseStart: courseDetails.courseStart,
                    courseEnd: courseDetails.courseEnd,
                    enrollmentStart: courseDetails.enrollmentStart,
                    enrollmentEnd: courseDetails.enrollmentEnd,
                    title: courseDetails.courseTitle
                )
            } else {
                showCourseDetais(
                    courseID: courseDetails.courseID,
                    title: courseDetails.courseTitle
                )
            }

        }

        DispatchQueue.main.asyncAfter(deadline: .now() + (isCourseOpened ? 0 : 1)) {
            switch link.type {
            case .courseVideos:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.videos.rawValue
            case .courseDates:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.dates.rawValue
            case .discussions, .discussionTopic, .discussionPost, .discussionComment:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.discussion.rawValue
            case .courseHandout:
                self.hostCourseContainerView?.rootView.viewModel.selection = CourseTab.handounds.rawValue
            default:
                break
            }
            completion()
        }
    }

    public func showProgram(
        pathID: String
    ) {
        showTabScreen(tab: .programs)
        showWebProgramDetails(
            pathID: pathID,
            viewType: .programDetail
        )
    }

    public func showThreads(
        topicID: String,
        courseDetails: CourseDetails,
        topics: Topics
    ) {
        let title = (topics.coursewareTopics.map {$0} + topics.nonCoursewareTopics.map {$0}).first?.name ?? ""
        showThreads(
            courseID: courseDetails.courseID,
            topics: topics,
            title: title,
            type: .courseTopics(topicID: topicID),
            animated: false
        )
    }

    public func showThread(
        userThread: UserThread
    ) {
        showThread(
            thread: userThread,
            postStateSubject: .init(.none),
            animated: false
        )
    }

    public func showComment(
        comment: UserComment,
        parentComment: Post
    ) {
        showComments(
            commentID: comment.commentID,
            parentComment: parentComment,
            threadStateSubject: .init(.none),
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

    public func showUserProfile(userName: String) {
        dismissPresentedViewController()
        
        let interactor = container.resolve(ProfileInteractorProtocol.self)!
        let vm = UserProfileViewModel(
            interactor: interactor,
            username: userName
        )
        let view = UserProfileView(viewModel: vm, isSheet: true)
        let controller = UIHostingController(rootView: view)
        getNavigationController().present(controller, animated: true)
    }

    public func dismissPresentedViewController() {
        if let presentedViewController = getNavigationController().presentedViewController {
            presentedViewController.dismiss(animated: true)
        }
    }

    private var hostMainScreen: UIHostingController<MainScreenView>? {
        getNavigationController().viewControllers.firstAs(UIHostingController<MainScreenView>.self)
    }

    private var hostCourseContainerView: UIHostingController<CourseContainerView>? {
        getNavigationController().topViewController as? UIHostingController<CourseContainerView>
    }

    private var hostDiscoveryWebview: UIHostingController<DiscoveryWebview>? {
        getNavigationController().topViewController as? UIHostingController<DiscoveryWebview>
    }

    public func showProgress() {
        presentView(
            transitionStyle: .crossDissolve,
            animated: false
        ) {
            FullScreenProgressView(title: "Waiting...")
        }
    }

    public func dismissProgress() {
        if let presentedViewController = getNavigationController()
            .presentedViewController as? UIHostingController<FullScreenProgressView> {
            presentedViewController.dismiss(animated: true)
        }
    }

    private func dismiss() {
        dismissPresentedViewController()
        backToRoot(animated: false)
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
    public func dismissPresentedViewController() {}
    public func showProgress() {}
    public func dismissProgress() {}
}
#endif
