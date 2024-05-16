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
    
    var nextPage = 1
    var totalPages = 1
    @Published public private(set) var fetchInProgress = true
    @Published var enrollments: PrimaryEnrollment?
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
    let config: ConfigProtocol
    private var onCourseEnrolledCancellable: AnyCancellable?
    
    private let ipadPageSize = 7
    private let iphonePageSize = 5
    
    public init(
        interactor: DashboardInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DashboardAnalytics,
        config: ConfigProtocol
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.config = config
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getEnrollments()
                }
            }
    }
    
    @MainActor
    public func getEnrollments(showProgress: Bool = true) async {
        let pageSize = UIDevice.current.userInterfaceIdiom == .pad ? ipadPageSize : iphonePageSize
        fetchInProgress = showProgress
        do {
            if connectivity.isInternetAvaliable {
                enrollments = try await interactor.getPrimaryEnrollment(pageSize: pageSize)
                fetchInProgress = false
            } else {
                enrollments = try await interactor.getPrimaryEnrollmentOffline()
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
