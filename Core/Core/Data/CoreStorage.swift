//
//  CoreStorage.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation

public protocol CoreStorage {
    var accessToken: String? {get set}
    var refreshToken: String? {get set}
    var appleSignFullName: String? {get set}
    var appleSignEmail: String? {get set}
    var cookiesDate: String? {get set}
    var reviewLastShownVersion: String? {get set}
    var lastReviewDate: Date? {get set}
    var user: DataLayer.User? {get set}
    var userSettings: UserSettings? {get set}
    func clear()
}

#if DEBUG
public class CoreStorageMock: CoreStorage {
    public var accessToken: String?
    public var refreshToken: String?
    public var appleSignFullName: String?
    public var appleSignEmail: String?
    public var cookiesDate: String?
    public var reviewLastShownVersion: String?
    public var lastReviewDate: Date?
    public var user: DataLayer.User?
    public var userSettings: UserSettings?
    public func clear() {}
    
    public init() {}
}
#endif
