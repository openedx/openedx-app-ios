//
//  PrimaryCourseDashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation
import Core
import SwiftUI
import Combine

@MainActor
public class PrimaryCourseDashboardViewModel: ObservableObject {
    
    var nextPage = 1
    var totalPages = 1
    @Published public private(set) var fetchInProgress = true
    @Published var enrollments: PrimaryEnrollment?
    @Published var showError: Bool = false
    @Published var updateNeeded: Bool = false
    private var updateShowedOnce: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let interactor: DashboardInteractorProtocol
    let analytics: DashboardAnalytics
    let config: ConfigProtocol
    var storage: CoreStorage
    let router: DashboardRouter
    private var cancellables = Set<AnyCancellable>()

    private let ipadPageSize = 7
    private let iphonePageSize = 5
    
    public init(
        interactor: DashboardInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DashboardAnalytics,
        config: ConfigProtocol,
        storage: CoreStorage,
        router: DashboardRouter
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.config = config
        self.storage = storage
        self.router = router
        
        let enrollmentPublisher = NotificationCenter.default.publisher(for: .onCourseEnrolled)
        let completionPublisher = NotificationCenter.default.publisher(for: .onblockCompletionRequested)
        let refreshEnrollmentsPublisher = NotificationCenter.default.publisher(for: .refreshEnrollments)
        
        enrollmentPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getEnrollments()
                }
            }
            .store(in: &cancellables)
        
        completionPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.updateEnrollmentsIfNeeded()
                }
            }
            .store(in: &cancellables)
        
        refreshEnrollmentsPublisher
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getEnrollments()
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNotifications() {
        NotificationCenter.default.publisher(for: .onActualVersionReceived)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] notification in
                if let latestVersion = notification.object as? String {
                    // Save the latest version to storage
                    self?.storage.latestAvailableAppVersion = latestVersion
                    
                    if let info = Bundle.main.infoDictionary {
                        guard let currentVersion = info["CFBundleShortVersionString"] as? String,
                                let self else { return }
                        if currentVersion.isAppVersionGreater(than: latestVersion) == false
                            && currentVersion != latestVersion {
                            if self.updateShowedOnce == false {
                                DispatchQueue.main.async {
                                    self.router.showUpdateRecomendedView()
                                }
                                self.updateShowedOnce = true
                            }
                        }
                    }
                }
            }.store(in: &cancellables)
    }
    
    private func updateEnrollmentsIfNeeded() {
        guard updateNeeded else { return }
        Task {
            await getEnrollments()
            updateNeeded = false
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
            } else if error.isUpdateRequeiredError {
                storage.updateAppRequired = true
                self.router.showUpdateRequiredView(showAccountLink: true)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func trackDashboardCourseClicked(courseID: String, courseName: String) {
        analytics.dashboardCourseClicked(courseID: courseID, courseName: courseName)
    }
}
