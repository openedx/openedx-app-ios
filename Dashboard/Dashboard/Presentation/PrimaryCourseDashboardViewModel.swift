//
//  PrimaryCourseDashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import Foundation
import Core
import Combine
import SwiftUI
import OEXFoundation

@MainActor
@Observable
public class PrimaryCourseDashboardViewModel {

    var nextPage = 1
    var totalPages = 1
    public private(set) var fetchInProgress = true
    var enrollments: PrimaryEnrollment?
    var showError: Bool = false
    var updateNeeded: Bool = false
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
    @ObservationIgnored nonisolated(unsafe) private var observers: [NSObjectProtocol] = []
    @ObservationIgnored private var cancellables = Set<AnyCancellable>()

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

        let enrollmentObserver = NotificationCenter.default.addObserver(
            forName: .onCourseEnrolled,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.getEnrollments()
            }
        }

        let completionObserver = NotificationCenter.default.addObserver(
            forName: .onblockCompletionRequested,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.updateEnrollmentsIfNeeded()
            }
        }

        let refreshObserver = NotificationCenter.default.addObserver(
            forName: .refreshEnrollments,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self = self else { return }
            Task {
                await self.getEnrollments()
            }
        }

        observers.append(contentsOf: [enrollmentObserver, completionObserver, refreshObserver])

        connectivity.internetReachableSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard state == .notReachable else { return }
                Task { @MainActor in
                    await self?.showSavedEnrollmentsIfStillLoading()
                }
            }
            .store(in: &cancellables)
    }
    
    func setupNotifications() {
        let versionObserver = NotificationCenter.default.addObserver(
            forName: .onActualVersionReceived,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            let latestVersion = notification.object as? String
            Task { @MainActor in
                if let latestVersion = latestVersion {
                    // Save the latest version to storage
                    self.storage.latestAvailableAppVersion = latestVersion

                    if let info = Bundle.main.infoDictionary {
                        guard let currentVersion = info["CFBundleShortVersionString"] as? String else { return }
                        if currentVersion.isAppVersionGreater(than: latestVersion) == false
                            && currentVersion != latestVersion {
                            if self.updateShowedOnce == false {
                                self.router.showUpdateRecomendedView()
                                self.updateShowedOnce = true
                            }
                        }
                    }
                }
            }
        }
        observers.append(versionObserver)
    }
    
    func updateEnrollmentsIfNeeded() {
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
                // A failed refresh must not take the learner's courses away: fall back to the
                // ones saved by the last successful load instead of showing "No Courses".
                if enrollments == nil {
                    enrollments = try? await interactor.getPrimaryEnrollmentOffline()
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
    private func showSavedEnrollmentsIfStillLoading() async {
        guard fetchInProgress, enrollments == nil,
              let saved = try? await interactor.getPrimaryEnrollmentOffline() else { return }
        enrollments = saved
        fetchInProgress = false
    }
    
    func trackDashboardCourseClicked(courseID: String, courseName: String) {
        analytics.dashboardCourseClicked(courseID: courseID, courseName: courseName)
    }

    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
