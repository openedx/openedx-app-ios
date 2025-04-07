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
                UserDefaults.standard.set(true, forKey: UserDefaultsKeys.updateRequired)
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
}
