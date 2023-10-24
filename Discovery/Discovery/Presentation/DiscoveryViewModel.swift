//
//  DiscoveryViewModel.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Combine
import Core
import SwiftUI

public class DiscoveryViewModel: ObservableObject {
    
    public var nextPage = 1
    public var totalPages = 1
    public private(set) var fetchInProgress = false
    var cancellables = Set<AnyCancellable>()
    
    @Published var courses: [CourseItem] = []
    @Published var showError: Bool = false
    @Published var updateNeeded: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscoveryRouter
    let connectivity: ConnectivityProtocol
    private let interactor: DiscoveryInteractorProtocol
    private let analytics: DiscoveryAnalytics
    
    public init(
        router: DiscoveryRouter,
        interactor: DiscoveryInteractorProtocol,
        connectivity: ConnectivityProtocol,
        analytics: DiscoveryAnalytics
    ) {
        self.router = router
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        
        NotificationCenter.default.publisher(for: .appLatestVersion)
            .sink { [weak self] notification in
                if let latestVersion = notification.object as? String {
                    if let info = Bundle.main.infoDictionary {
                        guard let currentVersion: AnyObject = info["CFBundleShortVersionString"] as AnyObject?
                        else { return }
                        print(">>>> 🤡", latestVersion, currentVersion)
                        guard let currentVersion = currentVersion as? String else { return }
                        switch self?.compareVersions(currentVersion, latestVersion) {
                        case .orderedAscending:
                            print("Show alert to update app")
                            router.showUpdateRecomendedView()
                            self?.updateNeeded = true
                            print("\(currentVersion) меньше, чем \(latestVersion)")
                        case .orderedSame, .none, .orderedDescending:
                            print("All okay")
                            print("\(currentVersion) и \(latestVersion) равны")
                        }
                    }
                }
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: .appVersionLastSupportedDate)
            .sink { [weak self] notification in
                if let lastSupportedDate = notification.object as? String {
                    print(">>>> 🤡", lastSupportedDate)
                    self?.checkDate(supportDate: lastSupportedDate)
                }
            }
            .store(in: &cancellables)
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
                courses = try interactor.discoveryOffline()
                self.nextPage += 1
                fetchInProgress = false
            }
        } catch let error {
            fetchInProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.asAFError?.responseCode == 426 {
                print(">>>> Попап, призывающий срочно обновится")
                router.showUpdateRequiredView()
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
            // Обработка ошибок, если компоненты не могут быть преобразованы в числа
            return .orderedSame
        }
        
        if major1 < major2 {
            return .orderedAscending
        } else if major1 > major2 {
            return .orderedDescending
        } else {
            // Основные версии равны, сравниваем второстепенные версии
            if minor1 < minor2 {
                return .orderedAscending
            } else if minor1 > minor2 {
                return .orderedDescending
            } else {
                return .orderedSame
            }
        }
    }
    
    private func checkDate(supportDate: String) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = dateFormatter.date(from: supportDate) else { return }
        if date < Date() {
            router.showUpdateRequiredView()
            print("Хардкод на пора обновится")
        }
    }
}
