//
//  OfflineSyncRepository.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation
import OEXFoundation

public protocol OfflineSyncRepositoryProtocol: Sendable {
    func submitOfflineProgress(courseID: String, blockID: String, data: String) async throws -> Bool
}

public actor OfflineSyncRepository: OfflineSyncRepositoryProtocol {
    
    private let api: API
    
    public init(api: API) {
        self.api = api
    }
    
    public func submitOfflineProgress(courseID: String, blockID: String, data: String) async throws -> Bool {
        let request = try await api.request(
            OfflineSyncEndpoint.submitOfflineProgress(
                courseID: courseID,
                blockID: blockID,
                data: data
            )
        )
        
        return request.statusCode == 200
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
@MainActor
class OfflineSyncRepositoryMock: OfflineSyncRepositoryProtocol {
    public func submitOfflineProgress(courseID: String, blockID: String, data: String) async throws -> Bool {
        true
    }
}
#endif
