//
//  ScreenAssembly.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Swinject
import Core
import Authorization
import Discovery
import Dashboard
import Profile
import Course
import Discussion

// swiftlint:disable function_body_length
class ScreenAssembly: Assembly {
    func assemble(container: Container) {
        
        // MARK: CoreDataHandler
        container.register(CoreDataHandlerProtocol.self) { r in
            CoreDataHandler(
                dashboardPersistence: r.resolve(DashboardPersistenceProtocol.self)!,
                discoveryPersistence: r.resolve(DiscoveryPersistenceProtocol.self)!,
                coursePersistence: r.resolve(CoursePersistenceProtocol.self)!
            )
        }
        
        // MARK: Auth
        container.register(AuthRepositoryProtocol.self) { r in
            AuthRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                config: r.resolve(Config.self)!
            )
        }
        container.register(AuthInteractorProtocol.self) { r in
            AuthInteractor(
                repository: r.resolve(AuthRepositoryProtocol.self)!
            )
        }
        
        // MARK: SignIn
        container.register(SignInViewModel.self) { r in
            SignInViewModel(
                interactor: r.resolve(AuthInteractorProtocol.self)!,
                router: r.resolve(AuthorizationRouter.self)!,
                validator: r.resolve(Validator.self)!
            )
        }
        container.register(SignUpViewModel.self) { r in
            SignUpViewModel(
                interactor: r.resolve(AuthInteractorProtocol.self)!,
                router: r.resolve(AuthorizationRouter.self)!,
                config: r.resolve(Config.self)!,
                cssInjector: r.resolve(CSSInjector.self)!,
                validator: r.resolve(Validator.self)!
            )
        }
        container.register(ResetPasswordViewModel.self) { r in
            ResetPasswordViewModel(
                interactor: r.resolve(AuthInteractorProtocol.self)!,
                router: r.resolve(AuthorizationRouter.self)!,
                validator: r.resolve(Validator.self)!
            )
        }
        
        // MARK: Discovery
        container.register(DiscoveryPersistenceProtocol.self) { _ in
            DiscoveryPersistence()
        }
        
        container.register(DiscoveryRepositoryProtocol.self) { r in
            DiscoveryRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                config: r.resolve(Config.self)!,
                persistence: r.resolve(DiscoveryPersistenceProtocol.self)!
            )
        }
        container.register(DiscoveryInteractorProtocol.self) { r in
            DiscoveryInteractor(
                repository: r.resolve(DiscoveryRepositoryProtocol.self)!
            )
        }
        container.register(DiscoveryViewModel.self) { r in
            DiscoveryViewModel(
                interactor: r.resolve(DiscoveryInteractorProtocol.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }
        
        container.register(SearchViewModel.self) { r in
            SearchViewModel(
                interactor: r.resolve(DiscoveryInteractorProtocol.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!,
                router: r.resolve(DiscoveryRouter.self)!,
                debounce: .searchDebounce
            )
        }
        
        // MARK: Dashboard
        container.register(DashboardPersistenceProtocol.self) { _ in
            DashboardPersistence()
        }
        
        container.register(DashboardRepositoryProtocol.self) { r in
            DashboardRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                config: r.resolve(Config.self)!,
                persistence: r.resolve(DashboardPersistenceProtocol.self)!
            )
        }
        container.register(DashboardInteractorProtocol.self) { r in
            DashboardInteractor(
                repository: r.resolve(DashboardRepositoryProtocol.self)!
            )
        }
        container.register(DashboardViewModel.self) { r in
            DashboardViewModel(
                interactor: r.resolve(DashboardInteractorProtocol.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }
        
        // MARK: Profile
        
        container.register(ProfileRepositoryProtocol.self) { r in
            ProfileRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                coreDataHandler: r.resolve(CoreDataHandlerProtocol.self)!,
                config: r.resolve(Config.self)!
            )
        }
        container.register(ProfileInteractor.self) { r in
            ProfileInteractor(
                repository: r.resolve(ProfileRepositoryProtocol.self)!
            )
        }
        container.register(ProfileViewModel.self) { r in
            ProfileViewModel(
                interactor: r.resolve(ProfileInteractor.self)!,
                router: r.resolve(ProfileRouter.self)!,
                config: r.resolve(Config.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }
        container.register(EditProfileViewModel.self) { r, userModel in
            EditProfileViewModel(
                userModel: userModel,
                interactor: r.resolve(ProfileInteractor.self)!,
                router: r.resolve(ProfileRouter.self)!
            )
        }
        
        container.register(SettingsViewModel.self) { r in
            SettingsViewModel(
                interactor: r.resolve(ProfileInteractor.self)!,
                router: r.resolve(ProfileRouter.self)!
            )
        }
        
        container.register(DeleteAccountViewModel.self) { r in
            DeleteAccountViewModel(
                interactor: r.resolve(ProfileInteractor.self)!,
                router: r.resolve(ProfileRouter.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }
        
        // MARK: Course
        container.register(CoursePersistenceProtocol.self) { _ in
            CoursePersistence()
        }
        
        container.register(CourseRepositoryProtocol.self) { r in
            CourseRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                config: r.resolve(Config.self)!,
                persistence: r.resolve(CoursePersistenceProtocol.self)!
            )
        }
        container.register(CourseInteractorProtocol.self) { r in
            CourseInteractor(
                repository: r.resolve(CourseRepositoryProtocol.self)!
            )
        }
        container.register(CourseDetailsViewModel.self) { r in
            CourseDetailsViewModel(
                interactor: r.resolve(CourseInteractorProtocol.self)!,
                router: r.resolve(CourseRouter.self)!,
                config: r.resolve(Config.self)!,
                cssInjector: r.resolve(CSSInjector.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!
            )
        }
        
        // MARK: CourseScreensView
        container
            .register(CourseContainerViewModel.self) { r, isActive, courseStart, courseEnd, enrollmentStart, enrollmentEnd in
            CourseContainerViewModel(
                interactor: r.resolve(CourseInteractorProtocol.self)!,
                router: r.resolve(CourseRouter.self)!,
                config: r.resolve(Config.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!,
                manager: r.resolve(DownloadManagerProtocol.self)!,
                isActive: isActive,
                courseStart: courseStart,
                courseEnd: courseEnd,
                enrollmentStart: enrollmentStart,
                enrollmentEnd: enrollmentEnd
            )
        }
        
        container.register(CourseBlocksViewModel.self) { r, blocks in
            CourseBlocksViewModel(blocks: blocks,
                                  manager: r.resolve(DownloadManagerProtocol.self)!,
                                  router: r.resolve(CourseRouter.self)!,
                                  connectivity: r.resolve(ConnectivityProtocol.self)!)
        }
        
        container.register(CourseVerticalViewModel.self) { r, verticals in
            CourseVerticalViewModel(verticals: verticals,
                                    manager: r.resolve(DownloadManagerProtocol.self)!,
                                    router: r.resolve(CourseRouter.self)!,
                                    connectivity: r.resolve(ConnectivityProtocol.self)!)
        }
        
        container.register(CourseUnitViewModel.self) { r, blockId, courseId, blocks in
            CourseUnitViewModel(
                lessonID: blockId,
                courseID: courseId,
                blocks: blocks,
                interactor: r.resolve(CourseInteractorProtocol.self)!,
                router: r.resolve(CourseRouter.self)!,
                connectivity: r.resolve(ConnectivityProtocol.self)!,
                manager: r.resolve(DownloadManagerProtocol.self)!
            )
        }
        
        container.register(WebUnitViewModel.self) { r in
            WebUnitViewModel(authInteractor: r.resolve(AuthInteractorProtocol.self)!)
        }
        
        container.register(VideoPlayerViewModel.self) { r in
            VideoPlayerViewModel(interactor: r.resolve(CourseInteractorProtocol.self)!,
                                 router: r.resolve(CourseRouter.self)!,
                                 connectivity: r.resolve(ConnectivityProtocol.self)!)
        }
        
        container.register(HandoutsViewModel.self) { r, courseID in
            HandoutsViewModel(interactor: r.resolve(CourseInteractorProtocol.self)!,
                              router: r.resolve(CourseRouter.self)!,
                              cssInjector: r.resolve(CSSInjector.self)!,
                              connectivity: r.resolve(ConnectivityProtocol.self)!,
                              courseID: courseID
            )
        }
        
        // MARK: Discussion
        container.register(DiscussionRepositoryProtocol.self) { r in
            DiscussionRepository(
                api: r.resolve(API.self)!,
                appStorage: r.resolve(AppStorage.self)!,
                config: r.resolve(Config.self)!,
                router: r.resolve(DiscussionRouter.self)!
            )
        }
        container.register(DiscussionInteractorProtocol.self) { r in
            DiscussionInteractor(
                repository: r.resolve(DiscussionRepositoryProtocol.self)!
            )
        }
        container.register(DiscussionTopicsViewModel.self) { r in
            DiscussionTopicsViewModel(
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                config: r.resolve(Config.self)!
            )
        }
        container.register(DiscussionSearchTopicsViewModel.self) { r, courseID in
            DiscussionSearchTopicsViewModel(
                courseID: courseID,
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                debounce: .searchDebounce
            )
        }
        container.register(PostsViewModel.self) { r in
            PostsViewModel(
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                config: r.resolve(Config.self)!
            )
        }
        container.register(ThreadViewModel.self) { r, subject in
            ThreadViewModel(
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                config: r.resolve(Config.self)!,
                storage: r.resolve(AppStorage.self)!,
                postStateSubject: subject
            )
        }
        container.register(ResponsesViewModel.self) { r, subject in
            ResponsesViewModel(
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                config: r.resolve(Config.self)!,
                storage: r.resolve(AppStorage.self)!,
                threadStateSubject: subject
            )
        }
        container.register(CreateNewThreadViewModel.self) { r in
            CreateNewThreadViewModel(
                interactor: r.resolve(DiscussionInteractorProtocol.self)!,
                router: r.resolve(DiscussionRouter.self)!,
                config: r.resolve(Config.self)!
            )
        }
    }
}
