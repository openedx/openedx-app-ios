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
    var cookiesDate: String? {get set}
    var user: DataLayer.User? {get set}
    var userSettings: UserSettings? {get set}
    func clear()
}

public struct CoreStorageMock: CoreStorage {
    public var accessToken: String? = nil
    public var refreshToken: String? = nil
    public var cookiesDate: String? = nil
    public var user: DataLayer.User? = nil
    public var userSettings: UserSettings?  = nil
    public func clear() {}
    
    public init() {}
}
