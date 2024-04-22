//
//  ProfileRepository.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation
import Core
import Alamofire

public protocol ProfileRepositoryProtocol {
    func getUserProfile(username: String) async throws -> UserProfile
    func getMyProfile() async throws -> UserProfile
    func getMyProfileOffline() -> UserProfile?
    func logOut() async throws
    func uploadProfilePicture(pictureData: Data) async throws
    func deleteProfilePicture() async throws -> Bool
    func updateUserProfile(parameters: [String: Any]) async throws -> UserProfile
    func getSpokenLanguages() -> [PickerFields.Option]
    func getCountries() -> [PickerFields.Option]
    func deleteAccount(password: String) async throws -> Bool
    func getSettings() -> UserSettings
    func saveSettings(_ settings: UserSettings)
}

public class ProfileRepository: ProfileRepositoryProtocol {
    
    private let api: API
    private var storage: CoreStorage & ProfileStorage
    private let downloadManager: DownloadManagerProtocol
    private let coreDataHandler: CoreDataHandlerProtocol
    private let config: ConfigProtocol
    
    public init(
        api: API,
        storage: CoreStorage & ProfileStorage,
        coreDataHandler: CoreDataHandlerProtocol,
        downloadManager: DownloadManagerProtocol,
        config: ConfigProtocol
    ) {
        self.api = api
        self.storage = storage
        self.coreDataHandler = coreDataHandler
        self.downloadManager = downloadManager
        self.config = config
    }
    
    public func getUserProfile(username: String) async throws -> UserProfile {
        let user = try await api.requestData(
            ProfileEndpoint.getUserProfile(username: username)
        ).mapResponse(DataLayer.UserProfile.self)
        return user.domain
    }
    
    public func getMyProfile() async throws -> UserProfile {
        let user = try await api.requestData(
            ProfileEndpoint.getUserProfile(username: storage.user?.username ?? "")
        ).mapResponse(DataLayer.UserProfile.self)
        storage.userProfile = user
        return user.domain
    }
    
    public func getMyProfileOffline() -> UserProfile? {
        return storage.userProfile?.domain
    }
    
    public func logOut() async throws {
        guard let refreshToken = storage.refreshToken else { return }
        _ = try await api.request(
            ProfileEndpoint.logOut(refreshToken: refreshToken, clientID: config.oAuthClientId)
        )
        storage.clear()
    }
    
    public func getSpokenLanguages() -> [PickerFields.Option] {
        guard let url = Bundle.main.url(forResource: "languages", withExtension: "json")
        else {
            print("Json file not found")
            return []
        }
        typealias SpokenLanguages = [[String: String]]
        
        let data = try? Data(contentsOf: url)
        let spokenLanguages = try? JSONDecoder().decode(SpokenLanguages.self, from: data!)
        let elements = spokenLanguages.flatMap {
            $0.flatMap {
                $0.map {
                    PickerFields.Option(value: $0.key, name: $0.value, optionDefault: false)
                }
            }
        } ?? []
        return elements
    }
    
    public func getCountries() -> [PickerFields.Option] {
        guard let url = Bundle.main.url(forResource: "сountries", withExtension: "json")
        else {
            print("Json file not found")
            return []
        }
        
        let data = try? Data(contentsOf: url)
        let users = try? JSONDecoder().decode([DataLayer.Option].self, from: data!)
        let elements = users.flatMap {
            $0.map {
                PickerFields.Option(value: $0.value, name: $0.name, optionDefault: $0.optionDefault)
            }
        } ?? []
        return elements
    }
    
    public func uploadProfilePicture(pictureData: Data) async throws {
        let response = try await api.request(
            ProfileEndpoint.uploadProfilePicture(username: storage.user?.username ?? "",
                                                 pictureData: pictureData))
        if response.statusCode != 204 {
            throw APIError.uploadError
        }
    }
    
    public func deleteProfilePicture() async throws -> Bool {
        let response = try await api.request(
            ProfileEndpoint.deleteProfilePicture(username: storage.user?.username ?? ""))
        return response.statusCode == 204
    }
    
    public func updateUserProfile(parameters: [String: Any]) async throws -> UserProfile {
        let response = try await api.requestData(
            ProfileEndpoint.updateUserProfile(username: storage.user?.username ?? "",
                                              parameters: parameters))
            .mapResponse(DataLayer.UserProfile.self).domain
        return response
    }
    
    public func deleteAccount(password: String) async throws -> Bool {
        let response = try await api.request(ProfileEndpoint.deleteAccount(password: password))
        return response.statusCode == 204
    }
    
    public func getSettings() -> UserSettings {
        if let userSettings = storage.userSettings {
            return userSettings
        } else {
            return UserSettings(wifiOnly: true, streamingQuality: .auto, downloadQuality: .auto)
        }
    }
    
    public func saveSettings(_ settings: UserSettings) {
        storage.userSettings = settings
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
// swiftlint:disable all
class ProfileRepositoryMock: ProfileRepositoryProtocol {
    
    public func getUserProfile(username: String) async throws -> Core.UserProfile {
        return Core.UserProfile(avatarUrl: "",
                                name: "",
                                username: "",
                                dateJoined: Date(),
                                yearOfBirth: 0,
                                country: "",
                                shortBiography: "",
                                isFullProfile: false)
    }
    
    func getMyProfileOffline() -> Core.UserProfile? {
        return UserProfile(
            avatarUrl: "",
            name: "John Lennon",
            username: "John",
            dateJoined: Date(),
            yearOfBirth: 1940,
            country: "USA",
            shortBiography: """
            John Winston Ono Lennon (born John Winston Lennon; 9 October 1940 – 8 December 1980) was an English singer,
            songwriter, musician and peace activist who achieved worldwide fame as founder, co-songwriter, co-lead vocalist
            and rhythm guitarist of the Beatles. Lennon's work was characterised by the rebellious nature and acerbic wit
            of his music, writing and drawings, on film, and in interviews. His songwriting partnership with Paul McCartney
            remains the most successful in history
            """,
            isFullProfile: true
        )
    }
    
    func getMyProfile() async throws -> UserProfile {
        return UserProfile(
            avatarUrl: "",
            name: "John Lennon",
            username: "John",
            dateJoined: Date(),
            yearOfBirth: 1940,
            country: "USA",
            shortBiography: """
            John Winston Ono Lennon (born John Winston Lennon; 9 October 1940 – 8 December 1980) was an English singer,
            songwriter, musician and peace activist who achieved worldwide fame as founder, co-songwriter, co-lead vocalist
            and rhythm guitarist of the Beatles. Lennon's work was characterised by the rebellious nature and acerbic wit
            of his music, writing and drawings, on film, and in interviews. His songwriting partnership with Paul McCartney
            remains the most successful in history
            """,
            isFullProfile: true
        )
    }
    
    func logOut() async throws {}
    
    func getSpokenLanguages() -> [PickerFields.Option] { return [] }
    
    func getCountries() -> [PickerFields.Option] { return [] }
    
    func uploadProfilePicture(pictureData: Data) async throws {}
    
    public func deleteProfilePicture() async throws -> Bool { return true }
    
    func updateUserProfile(parameters: [String: Any]) async throws -> UserProfile {
        return UserProfile(
            avatarUrl: "",
            name: "John Smith",
            username: "John",
            dateJoined: Date(),
            yearOfBirth: 1970,
            country: "USA",
            shortBiography: "Bio",
            isFullProfile: true
        )
    }
    
    public func deleteAccount(password: String) async throws -> Bool { return false }
    
    public func getSettings() -> UserSettings {
        return UserSettings(wifiOnly: true, streamingQuality: .auto, downloadQuality: .auto)
    }
    public func saveSettings(_ settings: UserSettings) {}
}
// swiftlint:enable all
#endif
