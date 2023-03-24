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
    
    private let interactor: DashboardInteractorProtocol
    public let connectivity: ConnectivityProtocol
    
    private var onCourseEnrolledCancellable: AnyCancellable?
    
    public init(interactor: DashboardInteractorProtocol, connectivity: ConnectivityProtocol) {
        self.interactor = interactor
        self.connectivity = connectivity
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getMyCourses(page: self.nextPage)
                }
            }
    }
    
    @MainActor
    public func getMyCoursesPagination(index: Int, withProgress: Bool = true) async {
        if !fetchInProgress {
            if totalPages > 1 {
                if index == courses.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            await getMyCourses(page: self.nextPage, withProgress: withProgress)
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    public func getMyCourses(page: Int, withProgress: Bool = true) async {
        do {
            if connectivity.isInternetAvaliable {
                courses += try await interactor.getMyCourses(page: page)
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
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.noCachedData
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}
