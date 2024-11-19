//
//  DiscoveryViewModel.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Combine
import Core
import SwiftUI

@MainActor
public final class DiscoveryViewModel: ObservableObject {
    
    var nextPage = 1
    var totalPages = 1
    private(set) var fetchInProgress = false
    private var cancellables = Set<AnyCancellable>()
    private var updateShowedOnce: Bool = false
    
    @Published var courses: [CourseItem] = []
    @Published var showError: Bool = false
    
    var userloggedIn: Bool {
        return !(storage.user?.username?.isEmpty ?? true)
    }
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscoveryRouter
    let config: ConfigProtocol
    let connectivity: ConnectivityProtocol
    private let interactor: DiscoveryInteractorProtocol
    private let analytics: DiscoveryAnalytics
    let storage: CoreStorage
    
    public init(
        router: DiscoveryRouter,
        config: ConfigProtocol,
        interactor: DiscoveryInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DiscoveryAnalytics,
        storage: CoreStorage
    ) {
        self.router = router
        self.config = config
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.storage = storage
    }
    
    @MainActor
    public func getDiscoveryCourses(index: Int) async {
        if !fetchInProgress {
            if totalPages > 1 {
                if index == courses.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            await discovery(page: self.nextPage)
                        }
                    }
                }
            }
        }
    }
    
    func setupNotifications() {
        NotificationCenter.default.publisher(for: .onActualVersionReceived)
            .sink { [weak self] notification in
                if let latestVersion = notification.object as? String {
                    if let info = Bundle.main.infoDictionary {
                        guard let currentVersion = info["CFBundleShortVersionString"] as? String,
                                let self else { return }
                        switch self.compareVersions(currentVersion, latestVersion) {
                        case .orderedAscending:
                            if self.updateShowedOnce == false {
                                DispatchQueue.main.async {
                                    self.router.showUpdateRecomendedView()
                                }
                                self.updateShowedOnce = true
                            }
                        default:
                            return
                        }
                    }
                }
            }.store(in: &cancellables)
    }
    
    @MainActor
    func discovery(page: Int, withProgress: Bool = true) async {
        fetchInProgress = withProgress
        do {
            if connectivity.isInternetAvaliable {
                if page == 1 {
                    await courses = try interactor.discovery(page: page)
                    self.totalPages = 1
                    self.nextPage = 1
                } else {
                    await courses += try interactor.discovery(page: page)
                }
                self.nextPage += 1
                if !courses.isEmpty {
                    totalPages = courses[0].numPages
                }
                
                fetchInProgress = false
            } else {
                courses = try await interactor.discoveryOffline()
                self.nextPage += 1
                fetchInProgress = false
            }
        } catch let error {
            fetchInProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.isUpdateRequeiredError {
                self.router.showUpdateRequiredView(showAccountLink: true)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func discoveryCourseClicked(courseID: String, courseName: String) {
        analytics.discoveryCourseClicked(courseID: courseID, courseName: courseName)
    }
    
    func discoverySearchBarClicked() {
        analytics.discoverySearchBarClicked()
    }
    
    private func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let components1 = version1.components(separatedBy: ".").prefix(2)
        let components2 = version2.components(separatedBy: ".").prefix(2)
        
        guard let major1 = Int(components1.first ?? ""),
              let minor1 = Int(components1.last ?? ""),
              let major2 = Int(components2.first ?? ""),
              let minor2 = Int(components2.last ?? "") else {
            return .orderedSame
        }
        
        if major1 < major2 {
            return .orderedAscending
        } else if major1 > major2 {
            return .orderedDescending
        } else {
            if minor1 < minor2 {
                return .orderedAscending
            } else if minor1 > minor2 {
                return .orderedDescending
            } else {
                return .orderedSame
            }
        }
    }
}
