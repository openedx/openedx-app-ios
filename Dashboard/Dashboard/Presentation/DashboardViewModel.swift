//
//  DashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core
import SwiftUI
import Combine

public class DashboardViewModel: ObservableObject {
    
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
    private var cancellations: [AnyCancellable] = []
    private let upgradehandler: CourseUpgradeHandlerProtocol
    private let coreAnalytics: CoreAnalytics
    
    public init(interactor: DashboardInteractorProtocol,
                connectivity: ConnectivityProtocol,
                analytics: DashboardAnalytics,
                upgradehandler: CourseUpgradeHandlerProtocol,
                coreAnalytics: CoreAnalytics) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
        self.upgradehandler = upgradehandler
        self.coreAnalytics = coreAnalytics
        
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.getMyCourses(page: 1, refresh: true)
                }
            }
            .store(in: &cancellations)

        NotificationCenter.default
            .publisher(for: .courseUpgradeCompletionNotification)
            .sink { [weak self] _ in
                guard let self else { return }
                Task {
                    await self.getMyCourses(page: 1, refresh: true)
                }
            }
            .store(in: &cancellations)
    }
    
    @MainActor
    public func getMyCourses(page: Int, refresh: Bool = false) async {
        do {
            fetchInProgress = true
            if connectivity.isInternetAvaliable {
                if refresh {
                    courses = try await interactor.getMyCourses(page: page)
                    self.totalPages = 1
                    self.nextPage = 2
                } else {
                    courses += try await interactor.getMyCourses(page: page)
                    self.nextPage += 1
                }
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

// Course upgrade
extension DashboardViewModel {
    
    @MainActor
    func resolveUnfinishedPayment() async {
        guard let inprogressIAP = CourseUpgradeHelper.getInProgressIAP() else { return }
        
        do {
            let product = try await upgradehandler.fetchProduct(sku: inprogressIAP.sku)
            await fulfillPurchase(inprogressIAP: inprogressIAP, product: product)
        } catch _ {
            
        }
    }
    
    public func fulfillPurchase(inprogressIAP: InProgressIAP, product: StoreProductInfo) async {
        
        coreAnalytics.trackCourseUnfulfilledPurchaseInitiated(
            courseID: inprogressIAP.courseID,
            pacing: inprogressIAP.pacing,
            screen: .dashboard,
            flowType: .silent)
        
        await upgradehandler.upgradeCourse(
            sku: inprogressIAP.sku,
            mode: .silent,
            productInfo: product,
            pacing: inprogressIAP.pacing,
            courseID: inprogressIAP.courseID,
            componentID: nil,
            screen: .dashboard,
            completion: nil
        )
    }
}
