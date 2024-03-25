//
//  PipManager.swift
//  OpenEdX
//
//  Created by Vadim Kuznetsov on 20.03.24.
//

import Combine
import Course
import Discovery
import Foundation

public class PipManager: PipManagerProtocol {
    var controllerHolder: PlayerViewControllerHolder?
    private var appearancePublisher = PassthroughSubject<Void, Never>()
    private var restorationTask: Task<Void, Never>?
    private var cancellations: [AnyCancellable] = []
    let discoveryInteractor: DiscoveryInteractorProtocol
    let courseInteractor: CourseInteractorProtocol
    let router: Router
    public init(
        router: Router,
        discoveryInteractor: DiscoveryInteractorProtocol,
        courseInteractor: CourseInteractorProtocol
    ) {
        self.discoveryInteractor = discoveryInteractor
        self.courseInteractor = courseInteractor
        self.router = router
    }

    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        isVideoTab: Bool
    ) -> PlayerViewControllerHolder? {
        if controllerHolder?.blockID == blockID,
           controllerHolder?.courseID == courseID,
           controllerHolder?.isVideoTab == isVideoTab {
            return controllerHolder
        }

        return nil
    }
    
    public func set(holder: PlayerViewControllerHolder) {
        controllerHolder = holder
        appearancePublisher = PassthroughSubject<Void, Never>()
        cancellations.removeAll()
        restorationTask?.cancel()
        restorationTask = nil
    }
    
    public func remove(holder: PlayerViewControllerHolder) {
        if controllerHolder == holder {
            controllerHolder = nil
            restorationTask?.cancel()
            restorationTask = nil
        }
    }
    
    @MainActor
    public func restore(holder: PlayerViewControllerHolder) async throws {
        let courseID = holder.courseID
        var courseDetails: CourseDetails?
        
        if let value = try? await discoveryInteractor.getLoadedCourseDetails(
            courseID: courseID
        ) {
            courseDetails = value
        } else {
            courseDetails = try await discoveryInteractor.getCourseDetails(
                courseID: courseID
            )
        }
        guard let courseDetails = courseDetails else { throw PipManagerError.cantGetCourseDetails }
        let link = DeepLink(dictionary: [:])
        link.type = holder.isVideoTab ? .courseVideos : .courseDashboard
        await showCourseDetail(link: link, courseDetails: courseDetails)
        
        var courseStructure = try await courseInteractor.getLoadedCourseBlocks(courseID: courseID)
        if holder.isVideoTab {
            courseStructure = courseInteractor.getCourseVideoBlocks(fullStructure: courseStructure)
        }
        router.showCourseComponent(componentID: holder.blockID, courseStructure: courseStructure)
    }
    
    @MainActor
    func showCourseDetail(link: DeepLink, courseDetails: CourseDetails) async {
        await withCheckedContinuation { continuation in
            router.showCourseDetail(
                link: link,
                courseDetails: courseDetails
            ) {
                continuation.resume()
            }
        }
    }
    
    public func appearancePublisher(for holder: Course.PlayerViewControllerHolder) -> AnyPublisher<Void, Never>? {
        if holder == controllerHolder {
            return appearancePublisher
                .eraseToAnyPublisher()
        }
        return nil
    }
}

extension PipManager {
    enum PipManagerError: Error {
        case cantGetCourseDetails
    }
}
