//
//  ProfileViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation
import Core
import SwiftUI

public enum CourseState {
    case enrollOpen
    case enrollClose
    case alreadyEnrolled
}

public class CourseDetailsViewModel: ObservableObject {
    
    @Published var courseDetails: CourseDetails?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var isHorisontal: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let interactor: CourseInteractorProtocol
    private let analytics: CourseAnalytics
    let router: CourseRouter
    let config: ConfigProtocol
    let cssInjector: CSSInjector
    let connectivity: ConnectivityProtocol
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        analytics: CourseAnalytics,
        config: ConfigProtocol,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
        self.cssInjector = cssInjector
        self.connectivity = connectivity
    }
    
    @MainActor
    func getCourseDetail(courseID: String, withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            if connectivity.isInternetAvaliable {
                courseDetails = try await interactor.getCourseDetails(courseID: courseID)
                if let isEnrolled = courseDetails?.isEnrolled {
                    self.courseDetails?.isEnrolled = isEnrolled
                }
                
                isShowProgress = false
            } else {
                courseDetails = try await interactor.getCourseDetailsOffline(courseID: courseID)
                if let isEnrolled = courseDetails?.isEnrolled {
                    self.courseDetails?.isEnrolled = isEnrolled
                }
                isShowProgress = false
            }
        } catch let error {
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func courseState() -> CourseState {
        if courseDetails?.isEnrolled == false {
            if let enrollmentStart = courseDetails?.enrollmentStart, let enrollmentEnd = courseDetails?.enrollmentEnd {
                let enrollmentsRange = DateInterval(start: enrollmentStart, end: enrollmentEnd)
                if enrollmentsRange.contains(Date()) {
                    return .enrollOpen
                } else {
                    return .enrollClose
                }
            } else {
                return .enrollOpen
            }
        } else {
            return .alreadyEnrolled
        }
    }
    
    func showCourseVideo() {
        guard let youtubeURL = URL(string: courseDetails?.courseVideoURL ?? "") else { return }
        let httpsURL = youtubeURL.absoluteString.replacingOccurrences(of: "http://", with: "https://")
        guard let url = URL(string: httpsURL) else { return }
        UIApplication.shared.open(url)
    }
    
    func viewCourseClicked(courseId: String, courseName: String) {
        analytics.viewCourseClicked(courseId: courseId, courseName: courseName)
    }
    
    @MainActor
    func enrollToCourse(id: String) async {
        do {
            analytics.courseEnrollClicked(courseId: id, courseName: courseDetails?.courseTitle ?? "")
            _ = try await interactor.enrollToCourse(courseID: id)
            analytics.courseEnrollSuccess(courseId: id, courseName: courseDetails?.courseTitle ?? "")
            courseDetails?.isEnrolled = true
            NotificationCenter.default.post(name: .onCourseEnrolled, object: id)
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}
