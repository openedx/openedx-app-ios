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
import Combine
 
public class Router: AuthorizationRouter,
                     DiscoveryRouter,
                     ProfileRouter,
                     DashboardRouter,
                     CourseRouter,
                     DiscussionRouter {
    
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
        showToolBar()
        let controller = UIHostingController(rootView: MainScreenView())
        navigationController.setViewControllers([controller], animated: true)
    }
    
    public func showLoginScreen() {
        let view = SignInView(viewModel: Container.shared.resolve(SignInViewModel.self)!)
        let controller = UIHostingController(rootView: view)
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
        nextSectionName: String? = nil,
        action: String,
        image: Image,
        onCloseTapped: @escaping () -> Void,
        okTapped: @escaping () -> Void,
        nextSectionTapped: @escaping () -> Void
    ) {
        presentView(transitionStyle: .crossDissolve, content: {
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
        })
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, view: any View) {
        present(transitionStyle: transitionStyle, view: view)
    }
    
    public func presentView(transitionStyle: UIModalTransitionStyle, content: () -> any View) {
        let view = prepareToPresent(content(), transitionStyle: transitionStyle)
        navigationController.present(view, animated: true)
    }
    
    public func showRegisterScreen() {
        let view = SignUpView(viewModel: Container.shared.resolve(SignUpViewModel.self)!)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
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
    
    public func showDiscoverySearch() {
        let viewModel = Container.shared.resolve(SearchViewModel<RunLoop>.self)!
        let view = SearchView(viewModel: viewModel)
        
        let controller = UIHostingController(rootView: view)
        navigationController.pushFade(viewController: controller)
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
        let view = CourseUnitView(viewModel: viewModel, sectionName: sectionName)
        let controller = UIHostingController(rootView: view)
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
        sequentialIndex: Int
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
        let view = CourseUnitView(viewModel: viewModel, sectionName: sectionName)
        let controllerUnit = UIHostingController(rootView: view)
        var controllers = navigationController.viewControllers
        controllers.removeLast(2)
        controllers.append(contentsOf: [controllerVertical, controllerUnit])
        navigationController.setViewControllers(controllers, animated: true)
    }
    
    public func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType) {
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
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>) {
        let viewModel = Container.shared.resolve(ThreadViewModel.self, argument: postStateSubject)!
        let view = ThreadView(thread: thread, viewModel: viewModel)
        let controller = UIHostingController(rootView: view)
        navigationController.pushViewController(controller, animated: true)
    }
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
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
        navigationController.pushViewController(controller, animated: true)
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
}
