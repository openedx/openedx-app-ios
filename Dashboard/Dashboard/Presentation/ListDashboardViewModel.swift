//
//  ListDashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core
import SwiftUI
import Combine
import OEXFoundation

@MainActor
@Observable
public class ListDashboardViewModel {
    
    public var nextPage = 1
    public var totalPages = 1
    public private(set) var fetchInProgress = false
    
    var courses: [CourseItem] = []
    var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let interactor: DashboardInteractorProtocol
    private let analytics: DashboardAnalytics
    let storage: CoreStorage
    private var onCourseEnrolledCancellable: AnyCancellable?
    private var refreshEnrollmentsCancellable: AnyCancellable?
    private var offlineCancellable: AnyCancellable?
    
    public init(interactor: DashboardInteractorProtocol,
                connectivity: ConnectivityProtocol,
                analytics: DashboardAnalytics,
                storage: CoreStorage) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.storage = storage
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getMyCourses(page: 1, refresh: true)
                }
            }
        refreshEnrollmentsCancellable = NotificationCenter.default
            .publisher(for: .refreshEnrollments)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getMyCourses(page: 1, refresh: true)
                }
            }
        offlineCancellable = connectivity.internetReachableSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard state == .notReachable else { return }
                Task { @MainActor in
                    await self?.showSavedCoursesIfStillLoading()
                }
            }
    }
    
    @MainActor
    public func getMyCourses(page: Int, refresh: Bool = false) async {
        do {
            fetchInProgress = true
            if connectivity.isInternetAvaliable {
                if refresh {
                    courses = try await interactor.getEnrollments(page: page)
                    self.totalPages = 1
                    self.nextPage = 2
                } else {
                    courses += try await interactor.getEnrollments(page: page)
                    self.nextPage += 1
                }
                if !courses.isEmpty {
                    totalPages = courses[0].numPages
                }
                fetchInProgress = false
            } else {
                courses = try await interactor.getEnrollmentsOffline()
                self.nextPage += 1
                fetchInProgress = false
            }
        } catch let error {
            fetchInProgress = false
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.noCachedData
            } else {
                // A failed refresh must not take the learner's courses away: fall back to the
                // ones saved by the last successful load instead of an empty list.
                if courses.isEmpty, let saved = try? await interactor.getEnrollmentsOffline() {
                    courses = saved
                }
                errorMessage = error.isInternetError
                ? CoreLocalization.Error.slowOrNoInternetConnection
                : CoreLocalization.Error.unknownError
            }
        }
    }

    /// On a network that is up but doesn't work (captive portal, in-flight Wi-Fi) the request
    /// hangs until it times out. As soon as the app knows it is offline, show the saved
    /// courses instead of the spinner; a late response still replaces them.
    private func showSavedCoursesIfStillLoading() async {
        guard fetchInProgress, courses.isEmpty,
              let saved = try? await interactor.getEnrollmentsOffline(), !saved.isEmpty else { return }
        courses = saved
        fetchInProgress = false
    }
    
    @MainActor
    public func getMyCoursesPagination(index: Int) async {
        if !fetchInProgress {
            if totalPages > 1 {
                if index == courses.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            await getMyCourses(page: self.nextPage)
                        }
                    }
                }
            }
        }
    }
    
    func trackDashboardCourseClicked(courseID: String, courseName: String) {
        analytics.dashboardCourseClicked(courseID: courseID, courseName: courseName)
    }
}
