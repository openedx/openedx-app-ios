//
//  PipManager.swift
//  OpenEdX
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

import Course
import Discovery
import SwiftUI

public class PipManager: PipManagerProtocol {
    var controllerHolder: PlayerViewControllerHolder?
    let discoveryInteractor: DiscoveryInteractorProtocol
    let courseInteractor: CourseInteractorProtocol
    let router: Router
    let isNestedListEnabled: Bool
    public var isPipActive: Bool {
        controllerHolder != nil
    }
    
    public init(
        router: Router,
        discoveryInteractor: DiscoveryInteractorProtocol,
        courseInteractor: CourseInteractorProtocol,
        isNestedListEnabled: Bool
    ) {
        self.discoveryInteractor = discoveryInteractor
        self.courseInteractor = courseInteractor
        self.router = router
        self.isNestedListEnabled = isNestedListEnabled
    }
    
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolder? {
        if controllerHolder?.blockID == blockID,
           controllerHolder?.courseID == courseID,
           controllerHolder?.selectedCourseTab == selectedCourseTab {
            return controllerHolder
        }
        
        return nil
    }
    
    public func set(holder: PlayerViewControllerHolder) {
        controllerHolder = holder
    }
    
    public func remove(holder: PlayerViewControllerHolder) {
        if controllerHolder == holder {
            controllerHolder = nil
        }
    }
    
    @MainActor
    public func restore(holder: PlayerViewControllerHolder) async throws {
        let courseID = holder.courseID
        
        // if we are on CourseUnitView, and tab is same with holder
        if let controller = topCourseUnitController,
           router.currentCourseTabSelection == holder.selectedCourseTab {
            let viewModel = controller.rootView.viewModel
            
            if viewModel.currentCourseId == courseID {
                viewModel.route(to: holder.blockID)
                return
            }
        }
        // else create navigation stack and push new stack to root navigation controller
        try await navigate(to: holder)
    }
    
    public func pauseCurrentPipVideo() {
        guard let holder = controllerHolder else { return }
        holder.playerController.player?.pause()
    }
    
    @MainActor
    private func navigate(to holder: PlayerViewControllerHolder) async throws {
        let currentControllers = router.getNavigationController().viewControllers
        guard let mainController = currentControllers.first as? UIHostingController<MainScreenView> else {
            return
        }
        
        mainController.rootView.viewModel.select(tab: .dashboard)
        
        var viewControllers: [UIViewController] = [mainController]
        if currentControllers.count > 1,
            let containerController = currentControllers[1] as? UIHostingController<CourseContainerView>,
            containerController.rootView.courseID == holder.courseID {
            containerController.rootView.viewModel.selection = holder.selectedCourseTab
            viewControllers.append(containerController)
        } else {
            viewControllers.append(try await containerController(for: holder))
        }
        
        if !isNestedListEnabled && holder.selectedCourseTab != CourseTab.dates.rawValue {
            viewControllers.append(try await courseVerticalController(for: holder))
        }
        
        viewControllers.append(try await courseUnitController(for: holder))
        
        router.getNavigationController().setViewControllers(viewControllers, animated: true)
    }

    @MainActor
    private func courseVerticalController(
        for holder: PlayerViewControllerHolder
    ) async throws -> UIHostingController<CourseVerticalView> {
        var courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: holder.courseID)
        if holder.selectedCourseTab == CourseTab.videos.rawValue {
            courseStructure = courseInteractor.getCourseVideoBlocks(fullStructure: courseStructure)
        }
        for (chapterIndex, chapter) in courseStructure.childs.enumerated() {
            for (sequentialIndex, sequential) in chapter.childs.enumerated() {
                for (verticalIndex, vertical) in sequential.childs.enumerated() {
                    for block in vertical.childs where block.id == holder.blockID {
                        return router.getVerticalController(
                            courseID: holder.courseID,
                            courseName: courseStructure.displayName,
                            title: courseStructure.childs[chapterIndex].childs[sequentialIndex].displayName,
                            chapters: courseStructure.childs,
                            chapterIndex: chapterIndex,
                            sequentialIndex: sequentialIndex
                        )
                    }
                }
            }
        }
       
        throw PipManagerError.cantCreateCourseVerticalView
    }
    
    @MainActor
    private func courseUnitController(
        for holder: PlayerViewControllerHolder
    ) async throws -> UIHostingController<CourseUnitView> {

        var courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: holder.courseID)
        if holder.selectedCourseTab == CourseTab.videos.rawValue {
            courseStructure = courseInteractor.getCourseVideoBlocks(fullStructure: courseStructure)
        }
        for (chapterIndex, chapter) in courseStructure.childs.enumerated() {
            for (sequentialIndex, sequential) in chapter.childs.enumerated() {
                for (verticalIndex, vertical) in sequential.childs.enumerated() {
                    for block in vertical.childs where block.id == holder.blockID {
                        return router.getUnitController(
                            courseName: courseStructure.displayName,
                            blockId: block.blockId,
                            courseID: courseStructure.id,
                            verticalIndex: verticalIndex,
                            chapters: courseStructure.childs,
                            chapterIndex: chapterIndex,
                            sequentialIndex: sequentialIndex
                        )
                    }
                }
            }
        }
       
        throw PipManagerError.cantCreateCourseUnitView
    }
    
    @MainActor
    private func containerController(
        for holder: PlayerViewControllerHolder
    ) async throws -> UIHostingController<CourseContainerView> {
        let courseDetails = try await getCourseDetails(for: holder)
        let isActive: Bool? = nil
        let controller = router.getCourseScreensController(
            courseID: courseDetails.courseID,
            isActive: isActive,
            courseStart: courseDetails.courseStart,
            courseEnd: courseDetails.courseEnd,
            enrollmentStart: courseDetails.enrollmentStart,
            enrollmentEnd: courseDetails.enrollmentEnd,
            title: courseDetails.courseTitle
        )
        controller.rootView.viewModel.selection = holder.selectedCourseTab
        return controller
    }
    
    private func getCourseDetails(for holder: PlayerViewControllerHolder) async throws -> CourseDetails {
        if let value = try? await discoveryInteractor.getLoadedCourseDetails(
            courseID: holder.courseID
        ) {
            return value
        } else {
            return try await discoveryInteractor.getCourseDetails(
                courseID: holder.courseID
            )
        }
    }

    private var topCourseUnitController: UIHostingController<CourseUnitView>? {
        router.getNavigationController().visibleViewController as? UIHostingController<CourseUnitView>
    }
}

extension PipManager {
    enum PipManagerError: Error {
        case cantCreateCourseUnitView
        case cantCreateCourseVerticalView
    }
}
