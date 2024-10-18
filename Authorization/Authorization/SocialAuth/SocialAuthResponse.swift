//
//  SocialAuthResponse.swift
//  Core
//
//  Created by Eugene Yatsenko on 07.12.2023.
//

import Foundation

public struct SocialAuthResponse {
    public var name: String
    public var email: String
    public var token: String

    public init(name: String, email: String, token: String) {
        self.name = name
        self.email = email
        self.token = token
    }
}
