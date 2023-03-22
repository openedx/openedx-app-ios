//
//  CourseProgressViewModel.swift
//  Course
//
//  Created by Vladimir Chekyrta on 22.03.2023.
//

import Foundation
import SwiftUI
import Core

public class CourseProgressViewModel: ObservableObject {
    
    @Published private(set) var progress: CourseProgress?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let courseID: String
    private let interactor: CourseInteractorProtocol
    let router: CourseRouter
    
    public init(
        courseID: String,
        interactor: CourseInteractorProtocol,
        router: CourseRouter
    ) {
        self.courseID = courseID
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor
    func getProgress(withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            progress = try await interactor.getCourseProgress(courseID: courseID)
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
        isShowProgress = false
    }
    
}
