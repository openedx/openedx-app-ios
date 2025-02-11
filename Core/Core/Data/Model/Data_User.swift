//
//  Data_User.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

// MARK: "/api/mobile/v0.5/my_user_info"

public extension DataLayer {
    struct User: Codable, Sendable {
        public let id: Int
        public let username: String?
        public let email: String?
        public let name: String?
        public var userAvatar: String?
        
        enum CodingKeys: String, CodingKey {
            case id, username, email, name, userAvatar
        }
    }
}

public extension DataLayer.User {
    var domain: User {
        User(id: id, username: username ?? "", email: email ?? "", name: name ?? "", userAvatar: userAvatar ?? "")
    }
}
