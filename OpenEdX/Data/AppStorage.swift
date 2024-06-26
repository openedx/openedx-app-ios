//
//  AppStorage.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 31.08.2023.
//

import Foundation
import KeychainSwift
import Core
import Profile
import WhatsNew
import Course

public class AppStorage: CoreStorage, ProfileStorage, WhatsNewStorage, CourseStorage {

    private let keychain: KeychainSwift
    private let userDefaults: UserDefaults

    public init(keychain: KeychainSwift, userDefaults: UserDefaults) {
        self.keychain = keychain
        self.userDefaults = userDefaults
    }

    public var accessToken: String? {
        get {
            return keychain.get(KEY_ACCESS_TOKEN)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: KEY_ACCESS_TOKEN)
            } else {
                keychain.delete(KEY_ACCESS_TOKEN)
            }
        }
    }

    public var refreshToken: String? {
        get {
            return keychain.get(KEY_REFRESH_TOKEN)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: KEY_REFRESH_TOKEN)
            } else {
                keychain.delete(KEY_REFRESH_TOKEN)
            }
        }
    }
    
    public var pushToken: String? {
        get {
            return keychain.get(KEY_PUSH_TOKEN)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: KEY_PUSH_TOKEN)
            } else {
                keychain.delete(KEY_PUSH_TOKEN)
            }
        }
    }

    public var appleSignFullName: String? {
        get {
            return keychain.get(KEY_APPLE_SIGN_FULLNAME)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: KEY_APPLE_SIGN_FULLNAME)
            } else {
                keychain.delete(KEY_APPLE_SIGN_FULLNAME)
            }
        }
    }

    public var appleSignEmail: String? {
        get {
            return keychain.get(KEY_APPLE_SIGN_EMAIL)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: KEY_APPLE_SIGN_EMAIL)
            } else {
                keychain.delete(KEY_APPLE_SIGN_EMAIL)
            }
        }
    }

    public var cookiesDate: String? {
        get {
            return userDefaults.string(forKey: KEY_COOKIES_DATE)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue, forKey: KEY_COOKIES_DATE)
            } else {
                userDefaults.removeObject(forKey: KEY_COOKIES_DATE)
            }
        }
    }
    
    public var reviewLastShownVersion: String? {
        get {
            return userDefaults.string(forKey: KEY_REVIEW_LAST_SHOWN_VERSION)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue, forKey: KEY_REVIEW_LAST_SHOWN_VERSION)
            } else {
                userDefaults.removeObject(forKey: KEY_REVIEW_LAST_SHOWN_VERSION)
            }
        }
    }
    
    public var lastReviewDate: Date? {
        get {
            guard let dateString = userDefaults.string(forKey: KEY_REVIEW_LAST_REVIEW_DATE) else {
                return nil
            }
            return Date(iso8601: dateString)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue.dateToString(style: .iso8601), forKey: KEY_REVIEW_LAST_REVIEW_DATE)
            } else {
                userDefaults.removeObject(forKey: KEY_REVIEW_LAST_REVIEW_DATE)
            }
        }
    }
    
    public var whatsNewVersion: String? {
        get {
            return userDefaults.string(forKey: KEY_WHATSNEW_VERSION)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue, forKey: KEY_WHATSNEW_VERSION)
            } else {
                userDefaults.removeObject(forKey: KEY_WHATSNEW_VERSION)
            }
        }
    }

    public var userProfile: DataLayer.UserProfile? {
        get {
            guard let userJson = userDefaults.data(forKey: KEY_USER_PROFILE) else {
                return nil
            }
            return try? JSONDecoder().decode(DataLayer.UserProfile.self, from: userJson)
        }
        set(newValue) {
            if let user = newValue {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    userDefaults.set(encoded, forKey: KEY_USER_PROFILE)
                }
            } else {
                userDefaults.set(nil, forKey: KEY_USER_PROFILE)
            }
        }
    }

    public var userSettings: UserSettings? {
        get {
            guard let userSettings = userDefaults.data(forKey: KEY_SETTINGS) else {
                let defaultSettings = UserSettings(wifiOnly: true, streamingQuality: .auto, downloadQuality: .auto)
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(defaultSettings) {
                    userDefaults.set(encoded, forKey: KEY_SETTINGS)
                }
                return defaultSettings
            }
            return try? JSONDecoder().decode(UserSettings.self, from: userSettings)
        }
        set(newValue) {
            if let settings = newValue {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(settings) {
                    userDefaults.set(encoded, forKey: KEY_SETTINGS)
                }
            } else {
                userDefaults.set(nil, forKey: KEY_SETTINGS)
            }
        }
    }

    public var user: DataLayer.User? {
        get {
            guard let userJson = userDefaults.data(forKey: KEY_USER) else {
                return nil
            }
            return try? JSONDecoder().decode(DataLayer.User.self, from: userJson)
        }
        set(newValue) {
            if let user = newValue {
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(user) {
                    userDefaults.set(encoded, forKey: KEY_USER)
                }
            } else {
                userDefaults.set(nil, forKey: KEY_USER)
            }
        }
    }

    public var allowedDownloadLargeFile: Bool? {
        get {
            return userDefaults.bool(forKey: KEY_ALLOWED_DOWNLOAD_LARGE_FILE)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue, forKey: KEY_ALLOWED_DOWNLOAD_LARGE_FILE)
            } else {
                userDefaults.removeObject(forKey: KEY_ALLOWED_DOWNLOAD_LARGE_FILE)
            }
        }
    }
    
    public var resetAppSupportDirectoryUserData: Bool? {
        get {
            return userDefaults.bool(forKey: KEY_RESET_APP_SUPPORT_DIRECTORY_USER_DATA)
        }
        set(newValue) {
            if let newValue {
                userDefaults.set(newValue, forKey: KEY_RESET_APP_SUPPORT_DIRECTORY_USER_DATA)
            } else {
                userDefaults.removeObject(forKey: KEY_RESET_APP_SUPPORT_DIRECTORY_USER_DATA)
            }
        }
    }
    
    public func clear() {
        accessToken = nil
        refreshToken = nil
        cookiesDate = nil
        user = nil
        userProfile = nil
    }

    private let KEY_ACCESS_TOKEN = "accessToken"
    private let KEY_REFRESH_TOKEN = "refreshToken"
    private let KEY_PUSH_TOKEN = "pushToken"
    private let KEY_COOKIES_DATE = "cookiesDate"
    private let KEY_USER_PROFILE = "userProfile"
    private let KEY_USER = "refreshToken"
    private let KEY_SETTINGS = "userSettings"
    private let KEY_REVIEW_LAST_SHOWN_VERSION = "reviewLastShownVersion"
    private let KEY_REVIEW_LAST_REVIEW_DATE = "lastReviewDate"
    private let KEY_WHATSNEW_VERSION = "whatsNewVersion"
    private let KEY_APPLE_SIGN_FULLNAME = "appleSignFullName"
    private let KEY_APPLE_SIGN_EMAIL = "appleSignEmail"
    private let KEY_ALLOWED_DOWNLOAD_LARGE_FILE = "allowedDownloadLargeFile"
    private let KEY_RESET_APP_SUPPORT_DIRECTORY_USER_DATA = "resetAppSupportDirectoryUserData"
}
