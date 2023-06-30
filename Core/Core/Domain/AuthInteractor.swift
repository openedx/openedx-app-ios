//
//  AuthInteractor.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.10.2022.
//

import Foundation

//sourcery: AutoMockable
public protocol AuthInteractorProtocol {
    @discardableResult
    func login(username: String, password: String) async throws -> User
    func resetPassword(email: String) async throws -> ResetPassword
    func getCookies(force: Bool) async throws
    func getRegistrationFields() async throws -> [PickerFields]
    func registerUser(fields: [String: String]) async throws -> User
    func validateRegistrationFields(fields: [String: String]) async throws -> [String: String]
}

public class AuthInteractor: AuthInteractorProtocol {
    
    private let repository: AuthRepositoryProtocol
    
    public init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }
    
    @discardableResult
    public func login(username: String, password: String) async throws -> User {
        return try await repository.login(username: username, password: password)
    }

    public func resetPassword(email: String) async throws -> ResetPassword {
        try await repository.resetPassword(email: email)
    }

    public func getCookies(force: Bool) async throws {
        try await repository.getCookies(force: force)
    }

    public func getRegistrationFields() async throws -> [PickerFields] {
        return try await repository.getRegistrationFields()
    }

    public func registerUser(fields: [String: String]) async throws -> User {
        return try await repository.registerUser(fields: fields)
    }

    public func validateRegistrationFields(fields: [String: String]) async throws -> [String: String] {
        return try await repository.validateRegistrationFields(fields: fields)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension AuthInteractor {
    static let mock: AuthInteractor = .init(repository: AuthRepositoryMock())
}
#endif
