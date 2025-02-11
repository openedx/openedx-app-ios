//
//  User.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

public struct User: Sendable {
    public let id: Int
    public let username: String
    public let email: String
    public let name: String
    public let userAvatar: String
    
    public init(id: Int, username: String, email: String, name: String, userAvatar: String) {
        self.id = id
        self.username = username
        self.email = email
        self.name = name
        self.userAvatar = userAvatar
    }
}
