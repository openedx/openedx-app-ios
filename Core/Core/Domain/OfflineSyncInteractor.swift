//
//  OfflineSyncInteractor.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation

//sourcery: AutoMockable
public protocol OfflineSyncInteractorProtocol: Sendable {
    func submitOfflineProgress(courseID: String, blockID: String, data: String) async throws -> Bool
}

public actor OfflineSyncInteractor: OfflineSyncInteractorProtocol {
    private let repository: OfflineSyncRepositoryProtocol
    
    public init(repository: OfflineSyncRepositoryProtocol) {
        self.repository = repository
    }
    
    public func submitOfflineProgress(courseID: String, blockID: String, data: String) async throws -> Bool {
        return try await repository.submitOfflineProgress(
            courseID: courseID,
            blockID: blockID,
            data: data
        )
    }
}
