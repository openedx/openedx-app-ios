//
//  ProfileStorage.swift
//  Profile
//
//  Created by  Stepanok Ivan on 30.08.2023.
//

import Foundation
import Core
import UIKit

//sourcery: AutoMockable
public protocol ProfileStorage: Sendable {
    var userProfile: DataLayer.UserProfile? {get set}
    var useRelativeDates: Bool {get set}
    var calendarSettings: CalendarSettings? {get set}
    var hideInactiveCourses: Bool? {get set}
    var lastLoginUsername: String? {get set}
    var lastCalendarName: String? {get set}
    var lastCalendarUpdateDate: Date? {get set}
    var firstCalendarUpdate: Bool? {get set}
}

#if DEBUG
public final class ProfileStorageMock: ProfileStorage, CoreStorage, @unchecked Sendable {
    public var accessToken: String?
    public var refreshToken: String?
    public var pushToken: String?
    public var appleSignFullName: String?
    public var appleSignEmail: String?
    public var cookiesDate: Date?
    public var reviewLastShownVersion: String?
    public var lastReviewDate: Date?
    public var user: DataLayer.User?
    public var userSettings: UserSettings?
    public var resetAppSupportDirectoryUserData: Bool?
    public var useRelativeDates: Bool = true
    public var lastUsedSocialAuth: String?
    public var latestAvailableAppVersion: String?
    public var updateAppRequired: Bool = false
    public func clear() {}
    
    public var userProfile: DataLayer.UserProfile?
    public var calendarSettings: CalendarSettings?
    public var hideInactiveCourses: Bool?
    public var lastLoginUsername: String?
    public var lastCalendarName: String?
    public var lastCalendarUpdateDate: Date?
    public var firstCalendarUpdate: Bool?
    
    public init() {}
}

#endif
