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

@MainActor
public class ListDashboardViewModel: ObservableObject {
    
    public var nextPage = 1
    public var totalPages = 1
    @Published public private(set) var fetchInProgress = false
    
    @Published var courses: [CourseItem] = []
    @Published var showError: Bool = false
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
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
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
