//
//  PrimaryCourseDashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation
import Core
import SwiftUI
import Combine

public class PrimaryCourseDashboardViewModel: ObservableObject {
    
    public var nextPage = 1
    public var totalPages = 1
    @Published public private(set) var fetchInProgress = false
    
    @Published var myEnrollments: MyEnrollments?
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
    private var onCourseEnrolledCancellable: AnyCancellable?
    
    public init(interactor: DashboardInteractorProtocol,
                connectivity: ConnectivityProtocol,
                analytics: DashboardAnalytics) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getMyLearnings()
                }
            }
    }
    
    @MainActor
    public func getMyLearnings(showProgress: Bool = true) async {
        let pageSize = UIDevice.current.userInterfaceIdiom == .pad ? 7 : 5
        fetchInProgress = showProgress
        do {
            if connectivity.isInternetAvaliable {
                myEnrollments = try await interactor.getMyLearnCourses(pageSize: pageSize)
                fetchInProgress = false
            } else {
                myEnrollments = try await interactor.getMyLearnCoursesOffline()
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
    
    func trackDashboardCourseClicked(courseID: String, courseName: String) {
        analytics.dashboardCourseClicked(courseID: courseID, courseName: courseName)
    }
}
