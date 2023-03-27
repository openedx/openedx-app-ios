//
//  RouterImpl.swift
//  NewEdX
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
import Combine

public class Router: AuthorizationRouter, DiscoveryRouter, ProfileRouter, DashboardRouter, CourseRouter, DiscussionRouter {
    
    public var container: Container
    
    private let navigationController: UINavigationController
    
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
    
    public func showMainScreen() {
        let controller = SwiftUIHostController(view: MainScreenView())
        navigationController.setViewControllers([controller], animated: true)
    }
    
    public func showLoginScreen() {
        let view = SignInView(viewModel: Container.shared.resolve(SignInViewModel.self)!)
        let controller = SwiftUIHostController(view: view)
        navigationController.setViewControllers([controller], animated: false)
    }
    
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        positiveAction: String,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        type: AlertViewType
    ) {
        presentView(transitionStyle: .crossDissolve, content: {
            AlertView(
                alertTitle: alertTitle,
                alertMessage: alertMessage,
                positiveAction: positiveAction,
                onCloseTapped: onCloseTapped,
                okTapped: okTapped,
                type: type
            )
        })
    }
    
    public func presentAlert(
        alertTitle: String,
        alertMessage: String,
        action: String,
        image: Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void
    ) {
        presentView(transitionStyle: .crossDissolve, content: {
            AlertView(
                alertTitle: alertTitle,
                alertMessage: alertMessage,
                mainAction: action,
                image: image,
                onCloseTapped: onCloseTapped,
                okTapped: okTapped
            )
        })
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, view: any View) {
        present(transitionStyle: transitionStyle, view: view)
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, content: () -> any View) {
        navigationController.present(prepareToPresent(content(),
                                                      transitionStyle: transitionStyle), animated: true)
    }
    
    public func showRegisterScreen() {
        let view = SignUpView(viewModel: Container.shared.resolve(SignUpViewModel.self)!)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showForgotPasswordScreen() {
        let view = ResetPasswordView(viewModel: Container.shared.resolve(SignInViewModel.self)!)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseDetais(courseID: String,
                                 title: String) {
        let view = CourseDetailsView(viewModel: Container.shared.resolve(CourseDetailsViewModel.self)!,
                                     courseID: courseID, title: title)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showDiscoverySearch() {
        let viewModel = Container.shared.resolve(SearchViewModel<RunLoop>.self)!
        let view = SearchView(viewModel: viewModel)
        
        let controller = SwiftUIHostController(view: view)
        navigationController.pushFade(viewController: controller)
    }
    
    public func showDiscussionsSearch(courseID: String) {
        let viewModel = Container.shared.resolve(DiscussionSearchTopicsViewModel<RunLoop>.self, argument: courseID)!
        let view = DiscussionSearchTopicsView(viewModel: viewModel)
        
        let controller = SwiftUIHostController(view: view)
        navigationController.pushFade(viewController: controller)
    }
    
    public func showCourseVerticalView(title: String,
                                       verticals: [CourseVertical]) {
        
        let viewModel = Container.shared.resolve(CourseVerticalViewModel.self, argument: verticals)!
        
        let view = CourseVerticalView(title: title, viewModel: viewModel)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseBlocksView(title: String,
                                     blocks: [CourseBlock]) {
        let viewModel = Container.shared.resolve(CourseBlocksViewModel.self, argument: blocks)!
        
        let view = CourseBlocksView(title: title, viewModel: viewModel)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showCourseScreens(courseID: String,
                                  isActive: Bool?,
                                  courseStart: Date?,
                                  courseEnd: Date?,
                                  enrollmentStart: Date?,
                                  enrollmentEnd: Date?,
                                  title: String,
                                  courseBanner: String,
                                  certificate: Certificate?) {
        let screensView = CourseContainerView(
            viewModel: Container.shared.resolve(CourseContainerViewModel.self,
                                                arguments: isActive, courseStart, courseEnd,
                                                enrollmentStart, enrollmentEnd)!,
            courseID: courseID,
            title: title,
            courseBanner: courseBanner,
            certificate: certificate
        )

        let controller = SwiftUIHostController(view: screensView)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showHandoutsUpdatesView(handouts: String?,
                                        announcements: [CourseUpdate]?,
                                        router: Course.CourseRouter,
                                        cssInjector: CSSInjector) {
        let view = HandoutsUpdatesDetailView(handouts: handouts,
                                             announcements: announcements,
                                             router: router,
                                             cssInjector: cssInjector)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }

    public func showCourseUnit(blockId: String, courseID: String, sectionName: String, blocks: [CourseBlock]) {
        let viewModel = Container.shared.resolve(CourseUnitViewModel.self, arguments: blockId, courseID, blocks)!
        let view = CourseUnitView(viewModel: viewModel, sectionName: sectionName)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType) {
        let router = Container.shared.resolve(DiscussionRouter.self)!
        let viewModel = Container.shared.resolve(PostsViewModel.self)!
        let view = PostsView(courseID: courseID, topics: topics, title: title,
                             type: type, viewModel: viewModel, router: router)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>) {
        let viewModel = Container.shared.resolve(ThreadViewModel.self, argument: postStateSubject)!
        let view = ThreadView(thread: thread, viewModel: viewModel)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
    ) {
        let router = Container.shared.resolve(DiscussionRouter.self)!
        let viewModel = Container.shared.resolve(ResponsesViewModel.self, argument: threadStateSubject)!
        let view = ResponsesView(commentID: commentID, viewModel: viewModel, router: router, parentComment: parentComment)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func createNewThread(
        courseID: String,
        selectedTopic: String,
        onPostCreated: @escaping () -> Void
    ) {
        let viewModel = Container.shared.resolve(CreateNewThreadViewModel.self)!
        let view = CreateNewThreadView(viewModel: viewModel, selectedTopic: selectedTopic,
                                       courseID: courseID, onPostCreated: onPostCreated)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showEditProfile(userModel: Core.UserProfile,
                                avatar: UIImage?,
                                profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void) {
        let viewModel = Container.shared.resolve(EditProfileViewModel.self, argument: userModel)!
        let view = EditProfileView(viewModel: viewModel,
                                   avatar: avatar,
                                   profileDidEdit: profileDidEdit)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showSettings() {
        let viewModel = Container.shared.resolve(SettingsViewModel.self)!
        let view = SettingsView(viewModel: viewModel)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showVideoQualityView(viewModel: SettingsViewModel) {
        let view = VideoQualityView(viewModel: viewModel)
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func present<ToPresent: View>(transitionStyle: UIModalTransitionStyle, view: ToPresent) {
        navigationController.present(prepareToPresent(view, transitionStyle: transitionStyle),
                                     animated: true,
                                     completion: {})
    }
    
    public func showDeleteProfileView() {
        let viewModel = Container.shared.resolve(DeleteAccountViewModel.self)!
        let view = DeleteAccountView(viewModel: viewModel)
        
        let controller = SwiftUIHostController(view: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    private func prepareToPresent <ToPresent: View> (_ toPresent: ToPresent, transitionStyle: UIModalTransitionStyle)
    -> UIViewController {
        let hosting = UIHostingController(rootView: toPresent)
        hosting.view.backgroundColor = .clear
        hosting.modalTransitionStyle = transitionStyle
        hosting.modalPresentationStyle = .overFullScreen
        return hosting
    }
}
