//
//  AllCoursesViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 24.04.2024.
//

import Foundation
import Core
import SwiftUI
import Combine

@MainActor
public class AllCoursesViewModel: ObservableObject {
    
    var nextPage = 1
    var totalPages = 1
    @Published private(set) var fetchInProgress = false
    @Published private(set) var refresh = false
    @Published var selectedMenu: CategoryOption = .all
    
    @Published var myEnrollments: PrimaryEnrollment?
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    let storage: CoreStorage
    private let interactor: DashboardInteractorProtocol
    private let analytics: DashboardAnalytics
    private var onCourseEnrolledCancellable: AnyCancellable?
    
    public init(
        interactor: DashboardInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DashboardAnalytics,
        storage: CoreStorage
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.storage = storage
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getCourses(page: 1, refresh: true)
                }
            }
    }
    
    @MainActor
    public func getCourses(page: Int, refresh: Bool = false) async {
        self.refresh = refresh
        do {
            if refresh || page == 1 {
                fetchInProgress = true
                myEnrollments?.courses = []
                nextPage = 1
                myEnrollments = try await interactor.getAllCourses(filteredBy: selectedMenu.status, page: page)
                self.totalPages = myEnrollments?.totalPages ?? 1
            } else {
                fetchInProgress = true
                myEnrollments?.courses += try await interactor.getAllCourses(
                    filteredBy: selectedMenu.status, page: page
                ).courses
            }
            self.nextPage += 1
            totalPages = myEnrollments?.totalPages ?? 1
            fetchInProgress = false
            self.refresh = false
        } catch let error {
            fetchInProgress = false
            self.refresh = false
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.noCachedData
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    @MainActor
    public func getMyCoursesPagination(index: Int) async {
        guard let courses = myEnrollments?.courses else { return }
        if !fetchInProgress {
            if totalPages > 1 {
                if index == courses.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            await getCourses(page: self.nextPage)
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
