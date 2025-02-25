//
//  AppDownloadsViewModel.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Combine
import Core
import SwiftUI

@MainActor
public final class AppDownloadsViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    
    @Published var courses: [DownloadCoursePreview] = []
    @Published var downloadedSizes: [String: Int64] = [:]
    @Published var showError: Bool = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let interactor: DownloadsInteractorProtocol
    
    public init(
        interactor: DownloadsInteractorProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
    }
    
    @MainActor
    func getDownloadCourses() async {
        do {
            if connectivity.isInternetAvaliable {
                courses = try await interactor.getDownloadCourses()
            } else {
                courses = try await interactor.getDownloadCoursesOffline()
            }
        } catch let error {
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func downloadCourse(courseID: String) {
        // This would be implemented to start the actual download process
        // For now, we'll just simulate progress
        let totalSize = courses.first(where: { $0.id == courseID })?.totalSize ?? 0
        downloadedSizes[courseID] = totalSize
    }
    
    func cancelDownload(courseID: String) {
        // This would cancel an in-progress download
        downloadedSizes[courseID] = 0
    }
    
    func removeDownload(courseID: String) {
        // This would remove a downloaded course
        downloadedSizes[courseID] = 0
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension AppDownloadsViewModel {
    static let mock = AppDownloadsViewModel(
        interactor: DownloadsInteractor.mock,
        connectivity: Connectivity()
    )
}
#endif
