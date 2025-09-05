//
//  DownloadsRepository.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Core
import Alamofire
import OEXFoundation

public protocol DownloadsRepositoryProtocol: Sendable {
    func getDownloadCourses() async throws -> [DownloadCoursePreview]
    func getDownloadCoursesOffline() async throws -> [DownloadCoursePreview]
}

public actor DownloadsRepository: DownloadsRepositoryProtocol {
    
    private let api: API
    private let coreStorage: CoreStorage
    private let config: ConfigProtocol
    private let persistence: DownloadsPersistenceProtocol
    private let tenantProvider: @Sendable () -> any TenantProvider
    
    public init(
        api: API,
        coreStorage: CoreStorage,
        config: ConfigProtocol,
        persistence: DownloadsPersistenceProtocol,
        tenantProvider: @escaping @Sendable () -> any TenantProvider
    ) {
        self.api = api
        self.coreStorage = coreStorage
        self.config = config
        self.persistence = persistence
        self.tenantProvider = tenantProvider
    }
    
    public func getDownloadCourses() async throws -> [DownloadCoursePreview] {
        guard let username = coreStorage.user?.username else {
            throw APIError.unknown
        }
        
        let response = try await api.requestData(DownloadsEndpoint.getDownloadCourses(username: username))
            .mapResponse([DataLayer.DownloadCoursePreviewResponse].self)
            .map { $0.domain(baseURL: tenantProvider().baseURL.absoluteString) }
        
        await persistence.saveDownloadCourses(courses: response)
        return response
    }
    
    public func getDownloadCoursesOffline() async throws -> [DownloadCoursePreview] {
        try await persistence.loadDownloadCourses()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
final class DownloadsRepositoryMock: DownloadsRepositoryProtocol {
    
    public func getDownloadCourses() async throws -> [DownloadCoursePreview] {
        var models: [DownloadCoursePreview] = []
        for i in 0...5 {
            models.append(
                DownloadCoursePreview(
                    id: "course\(i)",
                    name: "Course name \(i)",
                    image: "https://example.com/image\(i).jpg",
                    totalSize: Int64(1024 * 1024 * (i + 1))
                )
            )
        }
        return models
    }
    
    public func getDownloadCoursesOffline() async throws -> [DownloadCoursePreview] {
        var models: [DownloadCoursePreview] = []
        for i in 0...3 {
            models.append(
                DownloadCoursePreview(
                    id: "course\(i)",
                    name: "Offline Course \(i)",
                    image: "https://example.com/offline_image\(i).jpg",
                    totalSize: Int64(1024 * 1024 * (i + 1))
                )
            )
        }
        return models
    }
}
#endif
