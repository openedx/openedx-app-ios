//
//  AuthResponse.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.10.2022.
//

import Foundation

extension DataLayer {
    struct AuthResponse: Codable {
        let accessToken: String?
        let tokenType: String?
        let expiresIn: Int?
        let scope: String?
        let error: String?
        let refreshToken: String?
        
        static let invalidGrant = "invalid_grant"
        
        enum CodingKeys: String, CodingKey {
            case accessToken = "access_token"
            case tokenType = "token_type"
            case expiresIn = "expires_in"
            case scope
            case error
            case refreshToken = "refresh_token"
        }
    }
}
