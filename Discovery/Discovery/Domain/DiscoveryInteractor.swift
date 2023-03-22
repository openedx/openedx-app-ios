//
//  DiscoveryInteractor.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DiscoveryInteractorProtocol {
    func discovery(page: Int) async throws -> [CourseItem]
    func discoveryOffline() throws -> [CourseItem]
    func search(page: Int, searchTerm: String) async throws -> [CourseItem]
}

public class DiscoveryInteractor: DiscoveryInteractorProtocol {
    
    private let repository: DiscoveryRepositoryProtocol
    
    public init(repository: DiscoveryRepositoryProtocol) {
        self.repository = repository
    }
    
    public func discovery(page: Int) async throws -> [CourseItem] {
        return try await repository.getDiscovery(page: page)
    }
    
    public func search(page: Int, searchTerm: String) async throws -> [CourseItem] {
        return try await repository.searchCourses(page: page, searchTerm: searchTerm)
    }
    
    public func discoveryOffline() throws -> [CourseItem] {
        return try repository.getDiscoveryOffline()
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DiscoveryInteractor {
    static let mock = DiscoveryInteractor(repository: DiscoveryRepositoryMock())
}
#endif
