//
//  PipManager.swift
//  OpenEdX
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

import Course
import Core
@preconcurrency import Combine
import Discovery
import SwiftUI

@MainActor
public final class PipManager: PipManagerProtocol {
    var controllerHolder: PlayerViewControllerHolderProtocol?
    let discoveryInteractor: DiscoveryInteractorProtocol
    let courseInteractor: CourseInteractorProtocol
    let router: Router
    let courseDropDownNavigationEnabled: Bool
    public var isPipActive: Bool {
        controllerHolder != nil
    }
    
    public var isPipPlaying: Bool {
        controllerHolder?.isPlaying ?? false
    }

    public init(
        router: Router,
        discoveryInteractor: DiscoveryInteractorProtocol,
        courseInteractor: CourseInteractorProtocol,
        courseDropDownNavigationEnabled: Bool
    ) {
        self.discoveryInteractor = discoveryInteractor
        self.courseInteractor = courseInteractor
        self.router = router
        self.courseDropDownNavigationEnabled = courseDropDownNavigationEnabled
    }
    
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolderProtocol? {
        if controllerHolder?.blockID == blockID,
           controllerHolder?.courseID == courseID,
           controllerHolder?.selectedCourseTab == selectedCourseTab {
            return controllerHolder
        }
        
        return nil
    }
    
    public func set(holder: PlayerViewControllerHolderProtocol) {
        controllerHolder = holder
    }
    
    public func remove(holder: PlayerViewControllerHolderProtocol) {
        if isCurrentHolderEqualTo(holder) {
            controllerHolder = nil
        }
    }

    private func isCurrentHolderEqualTo(_ holder: PlayerViewControllerHolderProtocol) -> Bool {
        controllerHolder?.blockID == holder.blockID &&
        controllerHolder?.courseID == holder.courseID &&
        controllerHolder?.url == holder.url &&
        controllerHolder?.selectedCourseTab == holder.selectedCourseTab
    }
    
    public func pipRatePublisher() -> AnyPublisher<Float, Never>? {
        controllerHolder?.getRatePublisher()
    }
    
    public func restore(holder: PlayerViewControllerHolderProtocol) async throws {
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
        holder.playerController?.pause()
    }
    
    private func navigate(to holder: PlayerViewControllerHolderProtocol) async throws {
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
        
        if !courseDropDownNavigationEnabled && holder.selectedCourseTab != CourseTab.dates.rawValue {
            viewControllers.append(try await courseVerticalController(for: holder))
        }
        
        viewControllers.append(try await courseUnitController(for: holder))
        
        router.getNavigationController().setViewControllers(viewControllers, animated: true)
    }

    private func courseVerticalController(
        for holder: PlayerViewControllerHolderProtocol
    ) async throws -> UIHostingController<CourseVerticalView> {
        var courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: holder.courseID)
        if holder.selectedCourseTab == CourseTab.videos.rawValue {
            courseStructure = await courseInteractor.getCourseVideoBlocks(fullStructure: courseStructure)
        }
        
        if let data = VerticalData.dataFor(blockId: holder.blockID, in: courseStructure.childs) {
            return router.getVerticalController(
                courseID: holder.courseID,
                courseName: courseStructure.displayName,
                title: courseStructure.childs[data.chapterIndex].childs[data.sequentialIndex].displayName,
                chapters: courseStructure.childs,
                chapterIndex: data.chapterIndex,
                sequentialIndex: data.sequentialIndex
            )
        }
       
        throw PipManagerError.cantCreateCourseVerticalView
    }
    
    private func courseUnitController(
        for holder: PlayerViewControllerHolderProtocol
    ) async throws -> UIHostingController<CourseUnitView> {

        var courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: holder.courseID)
        if holder.selectedCourseTab == CourseTab.videos.rawValue {
            courseStructure = await courseInteractor.getCourseVideoBlocks(fullStructure: courseStructure)
        }
        if let data = VerticalData.dataFor(blockId: holder.blockID, in: courseStructure.childs) {
            let chapter = courseStructure.childs[data.chapterIndex]
            let sequential = chapter.childs[data.sequentialIndex]
            let vertical = sequential.childs[data.verticalIndex]
            let block = vertical.childs[data.blockIndex]
            return router.getUnitController(
                courseName: courseStructure.displayName,
                blockId: block.id,
                courseID: courseStructure.id,
                verticalIndex: data.verticalIndex,
                chapters: courseStructure.childs,
                chapterIndex: data.chapterIndex,
                sequentialIndex: data.sequentialIndex
            )
        }
       
        throw PipManagerError.cantCreateCourseUnitView
    }
    
    private func containerController(
        for holder: PlayerViewControllerHolderProtocol
    ) async throws -> UIHostingController<CourseContainerView> {
        let courseDetails = try await getCourseDetails(for: holder)
        let hasAccess: Bool? = nil
        let controller = router.getCourseScreensController(
            courseID: courseDetails.courseID,
            hasAccess: hasAccess,
            courseStart: courseDetails.courseStart,
            courseEnd: courseDetails.courseEnd,
            enrollmentStart: courseDetails.enrollmentStart,
            enrollmentEnd: courseDetails.enrollmentEnd,
            title: courseDetails.courseTitle,
            courseRawImage: courseDetails.courseRawImage,
            showDates: false,
            lastVisitedBlockID: nil
        )
        controller.rootView.viewModel.selection = holder.selectedCourseTab
        return controller
    }
    
    private func getCourseDetails(for holder: PlayerViewControllerHolderProtocol) async throws -> CourseDetails {
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
