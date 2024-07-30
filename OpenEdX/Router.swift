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

// swiftlint:disable type_body_length file_length
public class Router: AuthorizationRouter,
                     WhatsNewRouter,
                     DiscoveryRouter,
                     ProfileRouter,
                     DashboardRouter,
                     CourseRouter,
                     DiscussionRouter,
                     BackNavigationProtocol {

    public var container: Container

    private let navigationController: UINavigationController

    func getNavigationController() -> UINavigationController {
        navigationController
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
        let analytics = Container.shared.resolve(WhatsNewAnalytics.self)!

        if let userId = coreStorage.user?.id {
            persistence.set(userId: userId)
        }

        let viewModel = WhatsNewViewModel(storage: whatsNewStorage, sourceScreen: sourceScreen, analytics: analytics)
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
        ), let authAnalytics = Container.shared.resolve(
            AuthorizationAnalytics.self
        ) else { return }
        
        let view = SignInView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
        
        authAnalytics.signInClicked()
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
        guard let config = Container.shared.resolve(ConfigProtocol.self),
              let storage = Container.shared.resolve(CoreStorage.self),
              let connectivity = Container.shared.resolve(ConnectivityProtocol.self),
              let analytics = Container.shared.resolve(CoreAnalytics.self),
              connectivity.isInternetAvaliable
        else { return }
        let vm = AppReviewViewModel(config: config, storage: storage, analytics: analytics)
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
    
    public func presentView(transitionStyle: UIModalTransitionStyle, view: any View, completion: (() -> Void)? = nil) {
        present(transitionStyle: transitionStyle, view: view, completion: completion)
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
        
        authAnalytics.registerClicked()
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
    
    public func showDiscussionsSearch(courseID: String, isBlackedOut: Bool) {
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
        let controller = getVerticalController(
            courseID: courseID,
            courseName: courseName,
            title: title,
            chapters: chapters,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func getVerticalController(
        courseID: String,
        courseName: String,
        title: String,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) -> UIHostingController<CourseVerticalView> {
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
        return UIHostingController(rootView: view)
    }
    
    public func showCourseScreens(
        courseID: String,
        hasAccess: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        title: String,
        courseRawImage: String?,
        showDates: Bool,
        lastVisitedBlockID: String?
    ) {
        let controller = getCourseScreensController(
            courseID: courseID,
            hasAccess: hasAccess,
            courseStart: courseStart,
            courseEnd: courseEnd,
            enrollmentStart: enrollmentStart,
            enrollmentEnd: enrollmentEnd,
            title: title,
            courseRawImage: courseRawImage,
            showDates: showDates,
            lastVisitedBlockID: lastVisitedBlockID
        )
        navigationController.pushViewController(controller, animated: true)
        
        Task {
            try? await Task.sleep(for: .seconds(1))
            await Container.shared.resolve(PushNotificationsManager.self)?.performRegistration()
        }
        
        if let analytics = Container.shared.resolve(DashboardAnalytics.self) {
            analytics.dashboardCourseClicked(courseID: courseID, courseName: title)
        }
    }
    
    public func getCourseScreensController(
        courseID: String,
        hasAccess: Bool?,
        courseStart: Date?,
        courseEnd: Date?,
        enrollmentStart: Date?,
        enrollmentEnd: Date?,
        title: String,
        courseRawImage: String?,
        showDates: Bool,
        lastVisitedBlockID: String?
    ) -> UIHostingController<CourseContainerView> {
        let vm = Container.shared.resolve(
            CourseContainerViewModel.self,
            arguments: hasAccess,
            courseStart,
            courseEnd,
            enrollmentStart,
            enrollmentEnd,
            showDates ? CourseTab.dates : CourseTab.course,
            lastVisitedBlockID
        )!
        
        let datesVm = Container.shared.resolve(
            CourseDatesViewModel.self,
            arguments: courseID,
            title
        )!
        
        let screensView = CourseContainerView(
            viewModel: vm,
            courseDatesViewModel: datesVm,
            courseID: courseID,
            title: title,
            courseRawImage: courseRawImage
        )
        
        return UIHostingController(rootView: screensView)
    }
    
    public func showAllCourses(courses: [CourseItem]) {
        let vm = Container.shared.resolve(AllCoursesViewModel.self)!
        let view = AllCoursesView(viewModel: vm, router: self)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showHandoutsUpdatesView(
        handouts: String?,
        announcements: [CourseUpdate]?,
        router: Course.CourseRouter,
        cssInjector: CSSInjector,
        type: HandoutsItemType
    ) {
        let view = HandoutsUpdatesDetailView(
            handouts: handouts,
            announcements: announcements,
            router: router,
            cssInjector: cssInjector,
            type: type
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }

    public func showCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) {
        let controller = getUnitController(
            courseName: courseName,
            blockId: blockId,
            courseID: courseID,
            verticalIndex: verticalIndex,
            chapters: chapters,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func getUnitController(
        courseName: String,
        blockId: String,
        courseID: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int
    ) -> UIHostingController<CourseUnitView> {
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
        let isDropdownActive = config?.uiComponents.courseDropDownNavigationEnabled ?? false

        let view = CourseUnitView(viewModel: viewModel, isDropdownActive: isDropdownActive)
        return UIHostingController(rootView: view)
    }
    
    public func showCourseComponent(
        componentID: String,
        courseStructure: CourseStructure,
        blockLink: String) {
            var courseBlock: CourseBlock?
            var chapterPosition: Int?
            var sequentialPosition: Int?
            var verticalPosition: Int?
            
            courseStructure.childs.enumerated().forEach { chapterIndex, chapter in
                chapter.childs.enumerated().forEach { sequentialIndex, sequential in
                    sequential.childs.enumerated().forEach { verticalIndex, vertical in
                        vertical.childs.forEach { block in
                            if block.id == componentID {
                                courseBlock = block
                                chapterPosition = chapterIndex
                                sequentialPosition = sequentialIndex
                                verticalPosition = verticalIndex
                                return
                            }
                        }
                    }
                }
            }
            
            if let block = courseBlock {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.showCourseUnit(
                        courseName: courseStructure.displayName,
                        blockId: block.blockId,
                        courseID: courseStructure.id,
                        verticalIndex: verticalPosition ?? 0,
                        chapters: courseStructure.childs,
                        chapterIndex: chapterPosition ?? 0,
                        sequentialIndex: sequentialPosition ?? 0
                    )
                }
            } else if !blockLink.isEmpty, let blockURL = URL(string: blockLink) {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.openBlockInBrowser(blockURL: blockURL)
                }
            }
        }
    
    public func showGatedContentError(url: String) {
        let view = NotAvailableOnMobileView(url: url)
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func openBlockInBrowser(blockURL: URL) {
        presentAlert(
            alertTitle: "",
            alertMessage: CoreLocalization.Courseware.courseContentNotAvailable,
            positiveAction: CoreLocalization.openInBrowser,
            onCloseTapped: {
                self.dismiss(animated: true)
            },
            okTapped: {
                self.dismiss(animated: true)
                if UIApplication.shared.canOpenURL(blockURL) {
                    UIApplication.shared.open(blockURL, options: [:], completionHandler: nil)
                }
            },
            type: .default(positiveAction: CoreLocalization.openInBrowser, image: nil)
        )
    }

    public func showDownloads(
        downloads: [DownloadDataTask],
        manager: DownloadManagerProtocol
    ) {
        let downloadsView = DownloadsView(
            isSheet: false,
            router: Container.shared.resolve(CourseRouter.self)!,
            downloads: downloads,
            manager: manager
        )
        let controller = UIHostingController(rootView: downloadsView)
        navigationController.pushViewController(controller, animated: true)
    }

    public func replaceCourseUnit(
        courseName: String,
        blockId: String,
        courseID: String,
        verticalIndex: Int,
        chapters: [CourseChapter],
        chapterIndex: Int,
        sequentialIndex: Int,
        animated: Bool
    ) {

        let controllerUnit = getUnitController(
            courseName: courseName,
            blockId: blockId,
            courseID: courseID,
            verticalIndex: verticalIndex,
            chapters: chapters,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )
        
        var controllers = navigationController.viewControllers
        let config = Container.shared.resolve(ConfigProtocol.self)!
        let courseDropDownNavigationEnabled = config.uiComponents.courseDropDownNavigationEnabled

        if courseDropDownNavigationEnabled || currentCourseTabSelection == CourseTab.dates.rawValue {
            controllers.removeLast(1)
            controllers.append(contentsOf: [controllerUnit])
        } else {
            let controllerVertical = getVerticalController(
                courseID: courseID,
                courseName: courseName,
                title: chapters[chapterIndex].childs[sequentialIndex].displayName,
                chapters: chapters,
                chapterIndex: chapterIndex,
                sequentialIndex: sequentialIndex
            )

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
        isBlackedOut: Bool,
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
            router: router,
            isBlackedOut: isBlackedOut
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func showThread(
        thread: UserThread,
        postStateSubject: CurrentValueSubject<PostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    ) {
        let viewModel = Container.shared.resolve(ThreadViewModel.self, argument: postStateSubject)!
        viewModel.isBlackedOut = isBlackedOut
        let view = ThreadView(thread: thread, viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: animated)
    }
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    ) {
        let router = Container.shared.resolve(DiscussionRouter.self)!
        let viewModel = Container.shared.resolve(ResponsesViewModel.self, argument: threadStateSubject)!
        viewModel.isBlackedOut = isBlackedOut
        let view = ResponsesView(
            commentID: commentID,
            viewModel: viewModel,
            router: router,
            parentComment: parentComment,
            isBlackedOut: isBlackedOut
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
    
    public func  showEditProfile(
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
    
    public func showVideoSettings() {
        let viewModel = Container.shared.resolve(SettingsViewModel.self)!
        let view = VideoSettingsView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showDatesAndCalendar() {
        let viewModel = Container.shared.resolve(DatesAndCalendarViewModel.self)!
        let storage = Container.shared.resolve(ProfileStorage.self)
        
        let view: AnyView
        if storage?.calendarSettings == nil {
            view = AnyView(DatesAndCalendarView(viewModel: viewModel))
        } else {
            view = AnyView(SyncCalendarOptionsView(viewModel: viewModel))
        }
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showSyncCalendarOptions() {
        let viewModel = Container.shared.resolve(DatesAndCalendarViewModel.self)!
        let view = SyncCalendarOptionsView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCoursesToSync() {
        let viewModel = Container.shared.resolve(DatesAndCalendarViewModel.self)!
        let view = CoursesToSyncView(viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showManageAccount() {
        let viewModel = Container.shared.resolve(ManageAccountViewModel.self)!
        let view = ManageAccountView(viewModel: viewModel)
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
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics
    ) {
        let view = VideoDownloadQualityView(
            downloadQuality: downloadQuality,
            didSelect: didSelect,
            analytics: analytics,
            router: self
        )
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }

    private func present<ToPresent: View>(
        transitionStyle: UIModalTransitionStyle,
        view: ToPresent,
        completion: (() -> Void)? = nil) {
        navigationController.present(
            prepareToPresent(view, transitionStyle: transitionStyle),
            animated: true,
            completion: completion
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
            showProgress: true,
            connectivity: Container.shared.resolve(ConnectivityProtocol.self)!
        )
        let controller = UIHostingController(rootView: webBrowser)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showSSOWebBrowser(title: String) {
        let config = Container.shared.resolve(ConfigProtocol.self)!
        let webBrowser = ContainerWebView(
            config.baseSSOURL.absoluteString,
            title: title
        )
        let controller = UIHostingController(rootView: webBrowser)
        navigationController.pushViewController(controller, animated: true)
    }
}

// MARK: BackNavigationProtocol
extension Router {
    public func getBackMenuItems() -> [BackNavigationMenuItem] {
        var viewControllers = navigationController.viewControllers
        viewControllers.removeLast()
        var items: [BackNavigationMenuItem] = []
        for (index, controller) in viewControllers.enumerated() {
            let title = controller.navigationItem.title ?? controller.title ?? ""
            let item = BackNavigationMenuItem(id: index, title: title)
            items.append(item)
        }
        return items
    }
    
    public func navigateTo(item: BackNavigationMenuItem) {
        let viewControllers = Array(navigationController.viewControllers[0 ... item.id])
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}
// swiftlint:enable type_body_length file_length
