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
    var reviewLastShownVersion: String? {get set}
    var user: DataLayer.User? {get set}
    var userSettings: UserSettings? {get set}
    func clear()
}

#if DEBUG
struct CoreStorageMock: CoreStorage {
    var accessToken: String?
    var refreshToken: String?
    var cookiesDate: String?
    var reviewLastShownVersion: String?
    var user: DataLayer.User?
    var userSettings: UserSettings?
    func clear() {}
}
#endif
