//
//  CourseDatesViewModel.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation
import Core
import SwiftUI

public class CourseDatesViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var courseDates: CourseDates?
    @Published var dueDatesShifted: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let interactor: CourseInteractorProtocol
    let cssInjector: CSSInjector
    let router: CourseRouter
    let connectivity: ConnectivityProtocol
    let courseID: String
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol,
        courseID: String
    ) {
        self.interactor = interactor
        self.router = router
        self.cssInjector = cssInjector
        self.connectivity = connectivity
        self.courseID = courseID
        addObservers()
    }
        
    var sortedStatuses: [CompletionStatus] {
        let desiredSequence = [
            CompletionStatus.completed,
            CompletionStatus.pastDue,
            CompletionStatus.today,
            CompletionStatus.thisWeek,
            CompletionStatus.nextWeek,
            CompletionStatus.upcoming
        ]
        
        // Filter out keys that don't exist in the dictionary
        let filteredKeys = desiredSequence.filter {
            courseDates?.statusDatesBlocks.keys.contains($0) ?? false }
        return filteredKeys
    }
    
    @MainActor
    func getCourseDates(courseID: String) async {
        isShowProgress = true
        do {
            courseDates = try await interactor.getCourseDates(courseID: courseID)
            if courseDates?.courseDateBlocks == nil {
                isShowProgress = false
                errorMessage = CoreLocalization.Error.unknownError
                return
            }
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func showCourseDetails(componentID: String) async {
        do {
            let courseStructure = try await interactor.getLoadedCourseBlocks(courseID: courseID)
            router.showCourseComponent(
                componentID: componentID,
                courseStructure: courseStructure
            )
        } catch _ {
            errorMessage = CourseLocalization.Error.componentNotFount
        }
    }
    
    @MainActor
    func shiftDueDates(courseID: String, withProgress: Bool = true) async {
        isShowProgress = withProgress
        dueDatesShifted = false
        do {
            try await interactor.shiftDueDates(courseID: courseID)
            NotificationCenter.default.post(name: .shiftCourseDates, object: courseID)
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension CourseDatesViewModel {
    private func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleShiftDueDates(_:)),
            name: .shiftCourseDates, object: nil
        )
    }
    
    @objc private func handleShiftDueDates(_ notification: Notification) {
        if let courseID = notification.object as? String {
            Task {
                await self.getCourseDates(courseID: courseID)
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.dueDatesShifted = true
                }
            }
        }
    }
}
