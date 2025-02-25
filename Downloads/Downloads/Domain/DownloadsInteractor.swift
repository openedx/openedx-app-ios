//
//  DownloadsInteractor.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DownloadsInteractorProtocol: Sendable {
    func getDownloadCourses() async throws -> [DownloadCoursePreview]
    func getDownloadCoursesOffline() async throws -> [DownloadCoursePreview]
}

public actor DownloadsInteractor: DownloadsInteractorProtocol {
    
    private let repository: DownloadsRepositoryProtocol
    
    public init(repository: DownloadsRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getDownloadCourses() async throws -> [DownloadCoursePreview] {
        return try await repository.getDownloadCourses()
    }
    
    public func getDownloadCoursesOffline() async throws -> [DownloadCoursePreview] {
        return try await repository.getDownloadCoursesOffline()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DownloadsInteractor {
    static let mock = DownloadsInteractor(repository: DownloadsRepositoryMock())
}
#endif
