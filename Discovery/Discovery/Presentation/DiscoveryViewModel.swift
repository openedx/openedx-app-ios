//
//  DiscoveryViewModel.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import Core
import SwiftUI

public class DiscoveryViewModel: ObservableObject {
    
    public var nextPage = 1
    public var totalPages = 1
    public private(set) var fetchInProgress = false
    
    @Published var courses: [CourseItem] = []
    @Published var showError: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let interactor: DiscoveryInteractorProtocol
    let connectivity: ConnectivityProtocol
    let analytics: DiscoveryAnalytics
    
    public init(interactor: DiscoveryInteractorProtocol,
                connectivity: ConnectivityProtocol,
                analytics: DiscoveryAnalytics) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.analytics = analytics
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
                await courses += try interactor.discovery(page: page)
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
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
}
