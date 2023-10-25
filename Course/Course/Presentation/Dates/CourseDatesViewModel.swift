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
    }
        
    public var sortedDates: [Date] {
        courseDates?.sortedDateToCourseDateBlockDict.keys.sorted() ?? []
    }
    
    public func blocks(for date: Date) -> [CourseDateBlock] {
        courseDates?.sortedDateToCourseDateBlockDict[date] ?? []
    }
    
    @MainActor
    func getCourseDates(courseID: String) async {
        isShowProgress = true
        do {
            courseDates = try await interactor.getCourseDates(courseID: courseID)
            guard let _ = courseDates?.courseDateBlocks else {
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
}
