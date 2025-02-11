//
//  ProfileInteractor.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation
import Core
import UIKit

//sourcery: AutoMockable
public protocol ProfileInteractorProtocol: Sendable {
    func getUserProfile(username: String) async throws -> UserProfile
    func getMyProfile() async throws -> UserProfile
    func getMyProfileOffline() async -> UserProfile?
    func logOut() async throws
    func getSpokenLanguages() -> [PickerFields.Option]
    func getCountries() -> [PickerFields.Option]
    func uploadProfilePicture(pictureData: Data) async throws
    func deleteProfilePicture() async throws -> Bool
    func updateUserProfile(parameters: [String: any Any & Sendable]) async throws -> UserProfile
    func deleteAccount(password: String) async throws -> Bool
    func getSettings() -> UserSettings
    func saveSettings(_ settings: UserSettings) async
    func enrollmentsStatus() async throws -> [CourseForSync]
    func getCourseDates(courseID: String) async throws -> CourseDates
}

public actor ProfileInteractor: ProfileInteractorProtocol {
    
    private let repository: ProfileRepositoryProtocol
    
    public init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getUserProfile(username: String) async throws -> UserProfile {
        return try await repository.getUserProfile(username: username)
    }
    
    public func getMyProfile() async throws -> UserProfile {
        return try await repository.getMyProfile()
    }
    
    public func getMyProfileOffline() async -> UserProfile? {
        return await repository.getMyProfileOffline()
    }
    
    public func logOut() async throws {
        try await repository.logOut()
    }
    
    public nonisolated func getSpokenLanguages() -> [PickerFields.Option] {
       return repository.getSpokenLanguages()
    }
    
    public nonisolated func getCountries() -> [PickerFields.Option] {
        return repository.getCountries()
    }
    
    public func uploadProfilePicture(pictureData: Data) async throws {
        try await repository.uploadProfilePicture(pictureData: pictureData)
    }
    
    public func deleteProfilePicture() async throws -> Bool {
        try await repository.deleteProfilePicture()
    }
    
    public func updateUserProfile(parameters: [String: any Any & Sendable]) async throws -> UserProfile {
       return try await repository.updateUserProfile(parameters: parameters)
    }
    
    public func deleteAccount(password: String) async throws -> Bool {
        return try await repository.deleteAccount(password: password)
    }
    
    nonisolated public func getSettings() -> UserSettings {
       return repository.getSettings()
    }
    
    public func saveSettings(_ settings: UserSettings) async {
        return await repository.saveSettings(settings)
    }
    
    public func enrollmentsStatus() async throws -> [CourseForSync] {
        return try await repository.enrollmentsStatus()
    }
    
    public func getCourseDates(courseID: String) async throws -> CourseDates {
        return try await repository.getCourseDates(courseID: courseID)
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension ProfileInteractor {
    @MainActor static let mock = ProfileInteractor(repository: ProfileRepositoryMock())
}
#endif
