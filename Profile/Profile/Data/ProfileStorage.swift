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
public final class ProfileStorageMock: ProfileStorage, @unchecked Sendable {
  
    public var userProfile: DataLayer.UserProfile?
    public var useRelativeDates: Bool = true
    public var calendarSettings: CalendarSettings?
    public var hideInactiveCourses: Bool?
    public var lastLoginUsername: String?
    public var lastCalendarName: String?
    public var lastCalendarUpdateDate: Date?
    public var firstCalendarUpdate: Bool?
    
    public init() {}
}
#endif
