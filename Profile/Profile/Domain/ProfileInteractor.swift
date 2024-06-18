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
public protocol ProfileInteractorProtocol {
    func getUserProfile(username: String) async throws -> UserProfile
    func getMyProfile() async throws -> UserProfile
    func getMyProfileOffline() -> UserProfile?
    func logOut() async throws
    func getSpokenLanguages() -> [PickerFields.Option]
    func getCountries() -> [PickerFields.Option]
    func uploadProfilePicture(pictureData: Data) async throws
    func deleteProfilePicture() async throws -> Bool
    func updateUserProfile(parameters: [String: Any]) async throws -> UserProfile
    func deleteAccount(password: String) async throws -> Bool
    func getSettings() -> UserSettings
    func saveSettings(_ settings: UserSettings)
    func enrollmentsStatus() async throws -> [CourseForSync]
    func getCourseDates(courseID: String) async throws -> CourseDates
}

public class ProfileInteractor: ProfileInteractorProtocol {
    
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
    
    public func getMyProfileOffline() -> UserProfile? {
        return repository.getMyProfileOffline()
    }
    
    public func logOut() async throws {
        try await repository.logOut()
    }
    
    public func getSpokenLanguages() -> [PickerFields.Option] {
       return repository.getSpokenLanguages()
    }
    
    public func getCountries() -> [PickerFields.Option] {
        return repository.getCountries()
    }
    
    public func uploadProfilePicture(pictureData: Data) async throws {
        try await repository.uploadProfilePicture(pictureData: pictureData)
    }
    
    public func deleteProfilePicture() async throws -> Bool {
        try await repository.deleteProfilePicture()
    }
    
    public func updateUserProfile(parameters: [String: Any]) async throws -> UserProfile {
       return try await repository.updateUserProfile(parameters: parameters)
    }
    
    public func deleteAccount(password: String) async throws -> Bool {
        return try await repository.deleteAccount(password: password)
    }
    
    public func getSettings() -> UserSettings {
       return repository.getSettings()
    }
    
    public func saveSettings(_ settings: UserSettings) {
        return repository.saveSettings(settings)
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
    static let mock = ProfileInteractor(repository: ProfileRepositoryMock())
}
#endif
