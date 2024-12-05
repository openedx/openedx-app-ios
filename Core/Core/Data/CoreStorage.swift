//
//  CoreStorage.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation

//sourcery: AutoMockable
public protocol CoreStorage: Sendable {
    var accessToken: String? {get set}
    var refreshToken: String? {get set}
    var pushToken: String? {get set}
    var appleSignFullName: String? {get set}
    var appleSignEmail: String? {get set}
    var cookiesDate: Date? {get set}
    var reviewLastShownVersion: String? {get set}
    var lastReviewDate: Date? {get set}
    var user: DataLayer.User? {get set}
    var userSettings: UserSettings? {get set}
    var resetAppSupportDirectoryUserData: Bool? {get set}
    var useRelativeDates: Bool {get set}
    func clear()
}

#if DEBUG
public final class CoreStorageMock: CoreStorage, @unchecked Sendable {
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
    public func clear() {}
    
    public init() {}
}
#endif
