//
//  RouterImpl.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import UIKit
import SwiftUI
import Core
import Authorization
import Swinject
import Kingfisher
import Course
import Discussion
import Discovery
import Dashboard
import Profile
import WhatsNew
import Combine

public class Router: AuthorizationRouter,
                     WhatsNewRouter,
                     DiscoveryRouter,
                     ProfileRouter,
                     DashboardRouter,
                     CourseRouter,
                     DiscussionRouter
{

    public var container: Container

    private let navigationController: UINavigationController

    private var topViewController: UIViewController? {
        UIApplication.topViewController()
    }

    init(navigationController: UINavigationController, container: Container) {
        self.navigationController = navigationController
        self.container = container
    }
    
    public func backToRoot(animated: Bool) {
        navigationController.popToRootViewController(animated: animated)
    }
    
    public func dismiss(animated: Bool) {
        navigationController.dismiss(animated: animated)
    }
    
    public func back(animated: Bool) {
        navigationController.popViewController(animated: animated)
    }
    
    public func backWithFade() {
        navigationController.popFade()
    }
    
    public func removeLastView(controllers: Int) {
        var viewControllers = navigationController.viewControllers
        viewControllers.removeLast(2)
        navigationController.setViewControllers(viewControllers, animated: true)
    }
    
    public func showMainOrWhatsNewScreen(sourceScreen: LogistrationSourceScreen) {
        showToolBar()
        var whatsNewStorage = Container.shared.resolve(WhatsNewStorage.self)!
        let config = Container.shared.resolve(ConfigProtocol.self)!
        let persistence = Container.shared.resolve(CorePersistenceProtocol.self)!
        let coreStorage = Container.shared.resolve(CoreStorage.self)!

        if let userId = coreStorage.user?.id {
            persistence.set(userId: userId)
        }

        let viewModel = WhatsNewViewModel(storage: whatsNewStorage, sourceScreen: sourceScreen)
        let whatsNew = WhatsNewView(router: Container.shared.resolve(WhatsNewRouter.self)!, viewModel: viewModel)
        let shouldShowWhatsNew = viewModel.shouldShowWhatsNew()
               
        if shouldShowWhatsNew && config.features.whatNewEnabled {
            if let jsonVersion = viewModel.getVersion() {
                whatsNewStorage.whatsNewVersion = jsonVersion
            }
            let controller = UIHostingController(rootView: whatsNew)
            navigationController.viewControllers = [controller]
            navigationController.setViewControllers([controller], animated: true)
        } else {
            let viewModel = Container.shared.resolve(
                MainScreenViewModel.self,
                argument: sourceScreen
            )!
            
            let controller = UIHostingController(rootView: MainScreenView(viewModel: viewModel))
            navigationController.viewControllers = [controller]
            navigationController.setViewControllers([controller], animated: true)
        }
    }
    
    public func showLoginScreen(sourceScreen: LogistrationSourceScreen) {
        guard let viewModel = Container.shared.resolve(
            SignInViewModel.self,
            argument: sourceScreen
        ) else { return }
        
        let view = SignInView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showStartupScreen() {
        if let config = Container.shared.resolve(ConfigProtocol.self), config.features.startupScreenEnabled {
            let view = StartupView(viewModel: Container.shared.resolve(StartupViewModel.self)!)
            let controller = UIHostingController(rootView: view)
            navigationController.setViewControllers([controller], animated: true)
        } else {
            let view = SignInView(
                viewModel: Container.shared.resolve(
                    SignInViewModel.self,
                    argument: LogistrationSourceScreen.default
                )!
            )
            let controller = UIHostingController(rootView: view)
            navigationController.setViewControllers([controller], animated: false)
        }
    }
    
    public func presentAppReview() {
        let config = Container.shared.resolve(ConfigProtocol.self)!
        let storage = Container.shared.resolve(CoreStorage.self)!
        let vm = AppReviewViewModel(config: config, storage: storage)
        if vm.shouldShowRatingView() {
            presentView(
                transitionStyle: .crossDissolve,
                view: AppReviewView(viewModel: vm)
            )
        }
    }
    
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        positiveAction: String,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        type: AlertViewType
    ) {
        presentView(
            transitionStyle: .crossDissolve,
            animated: true
        ) {
            AlertView(
                alertTitle: alertTitle,
                alertMessage: alertMessage,
                positiveAction: positiveAction,
                onCloseTapped: onCloseTapped,
                okTapped: okTapped,
                type: type
            )
        }
    }
    
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        nextSectionName: String? = nil,
        action: String,
        image: Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        nextSectionTapped: @escaping () -> Void
    ) {
        presentView(
            transitionStyle: .crossDissolve,
            animated: true
        ) {
            AlertView(
                alertTitle: alertTitle,
                alertMessage: alertMessage,
                nextSectionName: nextSectionName,
                mainAction: action,
                image: image,
                onCloseTapped: onCloseTapped,
                okTapped: okTapped,
                nextSectionTapped: { nextSectionTapped() }
            )
        }
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, view: any View) {
        present(transitionStyle: transitionStyle, view: view)
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {
        let view = prepareToPresent(content(), transitionStyle: transitionStyle)
        navigationController.present(view, animated: true)
    }
    
    public func showRegisterScreen(sourceScreen: LogistrationSourceScreen) {
        guard let viewModel = Container.shared.resolve(
            SignUpViewModel.self,
            argument: sourceScreen
        ), let authAnalytics = Container.shared.resolve(
            AuthorizationAnalytics.self
        ) else { return }
        
        let view = SignUpView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
        
        authAnalytics.signUpClicked()
    }

    public func showForgotPasswordScreen() {
        let view = ResetPasswordView(viewModel: Container.shared.resolve(ResetPasswordViewModel.self)!)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseDetais(courseID: String, title: String) {
        let view = CourseDetailsView(
            viewModel: Container.shared.resolve(CourseDetailsViewModel.self)!,
            courseID: courseID,
            title: title
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showWebDiscoveryDetails(
        pathID: String,
        discoveryType: DiscoveryWebviewType,
        sourceScreen: LogistrationSourceScreen
    ) {
        let view = DiscoveryWebview(
            viewModel: Container.shared.resolve(
                DiscoveryWebviewViewModel.self,
                argument: sourceScreen)!,
            router: Container.shared.resolve(DiscoveryRouter.self)!,
            discoveryType: discoveryType,
            pathID: pathID
        )
        
        DispatchQueue.main.async { [weak self] in
            let controller = UIHostingController(rootView: view)
            self?.navigationController.pushViewController(controller, animated: true)
        }
    }
    
    public func showWebProgramDetails(
        pathID: String,
        viewType: ProgramViewType
    ) {
        let view = ProgramWebviewView(
            viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
            router: Container.shared.resolve(DiscoveryRouter.self)!,
            viewType: viewType,
            pathID: pathID
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showDiscoverySearch(searchQuery: String? = nil) {
        let viewModel = Container.shared.resolve(SearchViewModel<RunLoop>.self)!
        let view = SearchView(viewModel: viewModel, searchQuery: searchQuery)
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushFade(viewController: controller)
    }
    
    public func showDiscoveryScreen(searchQuery: String? = nil, sourceScreen: LogistrationSourceScreen) {
        let config = Container.shared.resolve(ConfigProtocol.self)
        if config?.discovery.type == .native {
            let view = DiscoveryView(
                viewModel: Container.shared.resolve(DiscoveryViewModel.self)!,
                router: Container.shared.resolve(DiscoveryRouter.self)!,
                searchQuery: searchQuery,
                sourceScreen: sourceScreen
            )
            let controller = UIHostingController(rootView: view)
            navigationController.pushViewController(controller, animated: true)
        } else if config?.discovery.type == .webview {
            let view = DiscoveryWebview(
                viewModel: Container.shared.resolve(
                    DiscoveryWebviewViewModel.self,
                    argument: sourceScreen
                )!,
                router: Container.shared.resolve(DiscoveryRouter.self)!,
                searchQuery: searchQuery
            )
            
            let controller = UIHostingController(rootView: view)
            navigationController.pushViewController(controller, animated: true)
        }
    }
    
    public func showDiscussionsSearch(courseID: String) {
        let viewModel = Container.shared.resolve(DiscussionSearchTopicsViewModel<RunLoop>.self, argument: courseID)!
        let view = DiscussionSearchTopicsView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushFade(viewController: controller)
    }
    
    public func showCourseVerticalView(
        courseID: String,
        courseName: String,
        title: String,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) {
        let viewModel = Container.shared.resolve(
            CourseVerticalViewModel.self,
            arguments: chapters,
            chapterIndex,
            sequentialIndex
        )!
        
        let view = CourseVerticalView(
            title: title,
            courseName: courseName,
            courseID: courseID,
            viewModel: viewModel
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseScreens(
        courseID: String,
        isActive: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        title: String
    ) {
        let vm = Container.shared.resolve(
            CourseContainerViewModel.self,
            arguments: isActive,
            courseStart,
            courseEnd,
            enrollmentStart,
            enrollmentEnd
        )!
        let screensView = CourseContainerView(
            viewModel: vm,
            courseID: courseID,
            title: title
        )
        
        let controller = UIHostingController(rootView: screensView)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showHandoutsUpdatesView(
        handouts: String?,
        announcements: [CourseUpdate]?,
        router: Course.CourseRouter,
        cssInjector: CSSInjector
    ) {
        let view = HandoutsUpdatesDetailView(
            handouts: handouts,
            announcements: announcements,
            router: router,
            cssInjector: cssInjector
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }

    public func showCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) {
        let viewModel = Container.shared.resolve(
            CourseUnitViewModel.self,
            arguments: blockId,
            courseID,
            courseName,
            chapters,
            chapterIndex,
            sequentialIndex,
            verticalIndex
        )!
        
        let config = Container.shared.resolve(ConfigProtocol.self)
        let isDropdownActive = config?.uiComponents.courseNestedListEnabled ?? false

        let view = CourseUnitView(viewModel: viewModel, sectionName: sectionName, isDropdownActive: isDropdownActive)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure) {
            courseStructure.childs.enumerated().forEach { chapterIndex, chapter in
                chapter.childs.enumerated().forEach { sequentialIndex, sequential in
                    sequential.childs.enumerated().forEach { verticalIndex, vertical in
                        vertical.childs.forEach { block in
                            if block.id == componentID {
                                DispatchQueue.main.async { [weak self] in
                                    guard let self else { return }
                                    self.showCourseUnit(
                                        courseName: courseStructure.displayName,
                                        blockId: block.blockId,
                                        courseID: courseStructure.id,
                                        sectionName: sequential.displayName,
                                        verticalIndex: verticalIndex,
                                        chapters: courseStructure.childs,
                                        chapterIndex: chapterIndex,
                                        sequentialIndex: sequentialIndex)
                                }
                                return
                            }
                        }
                    }
                }
            }
        }

    public func showDownloads(
        downloads: [DownloadDataTask],
        manager: DownloadManagerProtocol
    ) {
        let downloadsView = DownloadsView(isSheet: false, downloads: downloads, manager: manager)
        let controller = UIHostingController(rootView: downloadsView)
        navigationController.pushViewController(controller, animated: true)
    }

    public func replaceCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        sectionName: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        animated: Bool
    ) {
        
        let vmVertical = Container.shared.resolve(
            CourseVerticalViewModel.self,
            arguments: chapters,
            chapterIndex,
            sequentialIndex
        )!
        
        let viewVertical = CourseVerticalView(
            title: chapters[chapterIndex].childs[sequentialIndex].displayName,
            courseName: courseName,
            courseID: courseID,
            viewModel: vmVertical
        )
        let controllerVertical = UIHostingController(rootView: viewVertical)
        
        let viewModel = Container.shared.resolve(
            CourseUnitViewModel.self,
            arguments: blockId,
            courseID,
            courseName,
            chapters,
            chapterIndex,
            sequentialIndex,
            verticalIndex
        )!

        let config = Container.shared.resolve(ConfigProtocol.self)
        let isDropdownActive = config?.uiComponents.courseNestedListEnabled ?? false

        let view = CourseUnitView(viewModel: viewModel, sectionName: sectionName, isDropdownActive: isDropdownActive)
        let controllerUnit = UIHostingController(rootView: view)
        var controllers = navigationController.viewControllers

        if let config = container.resolve(ConfigProtocol.self),
            config.uiComponents.courseNestedListEnabled {
            controllers.removeLast(1)
            controllers.append(contentsOf: [controllerUnit])
        } else {
            controllers.removeLast(2)
            controllers.append(contentsOf: [controllerVertical, controllerUnit])
        }

        navigationController.setViewControllers(controllers, animated: animated)
    }
    
    public func showThreads(
        courseID: String,
        topics: Topics,
        title: String,
        type: ThreadType,
        animated: Bool
    ) {
        let router = Container.shared.resolve(DiscussionRouter.self)!
        let viewModel = Container.shared.resolve(PostsViewModel.self)!
        let view = PostsView(
            courseID: courseID,
            currentBlockID: "",
            topics: topics,
            title: title,
            type: type,
            viewModel: viewModel,
            router: router
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func showThread(
        thread: UserThread,
        postStateSubject: CurrentValueSubject<PostState?, Never>,
        animated: Bool
    ) {
        let viewModel = Container.shared.resolve(ThreadViewModel.self, argument: postStateSubject)!
        let view = ThreadView(thread: thread, viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        animated: Bool
    ) {
        let router = Container.shared.resolve(DiscussionRouter.self)!
        let viewModel = Container.shared.resolve(ResponsesViewModel.self, argument: threadStateSubject)!
        let view = ResponsesView(
            commentID: commentID,
            viewModel: viewModel,
            router: router,
            parentComment: parentComment
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func createNewThread(
        courseID: String,
        selectedTopic: String,
        onPostCreated: @escaping () -> Void
    ) {
        let viewModel = Container.shared.resolve(CreateNewThreadViewModel.self)!
        let view = CreateNewThreadView(
            viewModel: viewModel,
            selectedTopic: selectedTopic,
            courseID: courseID,
            onPostCreated: onPostCreated
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showUserDetails(username: String) {
        let interactor = container.resolve(ProfileInteractorProtocol.self)!
        
        let vm = UserProfileViewModel(interactor: interactor,
                                      username: username)
        let view = UserProfileView(viewModel: vm)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showEditProfile(
        userModel: Core.UserProfile,
        avatar: UIImage?,
        profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void
    ) {
        let viewModel = Container.shared.resolve(EditProfileViewModel.self, argument: userModel)!
        let view = EditProfileView(
            viewModel: viewModel,
            avatar: avatar,
            profileDidEdit: profileDidEdit
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showSettings() {
        let viewModel = Container.shared.resolve(SettingsViewModel.self)!
        let view = SettingsView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showVideoQualityView(viewModel: SettingsViewModel) {
        let view = VideoQualityView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }

    public func showVideoDownloadQualityView(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?
    ) {
        let view = VideoDownloadQualityView(
            downloadQuality: downloadQuality,
            didSelect: didSelect
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }

    private func present<ToPresent: View>(transitionStyle: UIModalTransitionStyle, view: ToPresent) {
        navigationController.present(
            prepareToPresent(view, transitionStyle: transitionStyle),
            animated: true,
            completion: {}
        )
    }
    
    public func showDeleteProfileView() {
        let viewModel = Container.shared.resolve(DeleteAccountViewModel.self)!
        let view = DeleteAccountView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showUpdateRequiredView(showAccountLink: Bool = true) {
        let view = UpdateRequiredView(
            router: self,
            config: Container.shared.resolve(ConfigProtocol.self)!,
            showAccountLink: showAccountLink
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: false)
    }
    
    public func showUpdateRecomendedView() {
        let view = UpdateRecommendedView(router: self, config: Container.shared.resolve(ConfigProtocol.self)!)
        self.presentView(transitionStyle: .crossDissolve, view: view)
    }
    
    private func prepareToPresent <ToPresent: View> (_ toPresent: ToPresent, transitionStyle: UIModalTransitionStyle)
    -> UIViewController {
        let hosting = UIHostingController(rootView: toPresent)
        hosting.view.backgroundColor = .clear
        hosting.modalTransitionStyle = transitionStyle
        hosting.modalPresentationStyle = .overFullScreen
        return hosting
    }
    
    private func showToolBar() {
        self.navigationController.setNavigationBarHidden(false, animated: false)
    }

    public func showWebBrowser(title: String, url: URL) {
        let webBrowser = WebBrowser(
            url: url.absoluteString,
            pageTitle: title,
            showProgress: true
        )
        let controller = UIHostingController(rootView: webBrowser)
        navigationController.pushViewController(controller, animated: true)
    }
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
        showUserDetails(username: userName)
    }

    private var hostMainScreen: UIHostingController<MainScreenView>? {
        navigationController.viewControllers.firstAs(UIHostingController<MainScreenView>.self)
    }

    private var hostCourseContainerView: UIHostingController<CourseContainerView>? {
        navigationController.topViewController as? UIHostingController<CourseContainerView>
    }

    private var hostDiscoveryWebview: UIHostingController<DiscoveryWebview>? {
        navigationController.topViewController as? UIHostingController<DiscoveryWebview>
    }

    private func dismissPresentedViewController() {
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: true)
        }
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
        if let presentedViewController = navigationController
            .presentedViewController as? UIHostingController<FullScreenProgressView> {
            presentedViewController.dismiss(animated: true)
        }
    }

    private func dismiss() {
        dismissPresentedViewController()
        backToRoot(animated: true)
    }

}
