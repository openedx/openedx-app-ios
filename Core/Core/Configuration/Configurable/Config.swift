//
//  Config.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation

public class Config: Configurable {
    public var app: Apps { .openEdx }
    public let baseURL: URL
    public let oAuthClientId: String
    public let tokenType: TokenType = .jwt
    
    public var termsOfService: URL? {
        URL(string: "\(baseURL.description)/tos")
    }
    
    public var privacyPolicy: URL? {
        URL(string: "\(baseURL.description)/privacy")
    }
    
    public let feedbackEmail = "support@example.com"
    
    public init(baseURL: String, oAuthClientId: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Ivalid baseURL")
        }
        self.baseURL = url
        self.oAuthClientId = oAuthClientId
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class ConfigMock: Config {
    public convenience init() {
        self.init(baseURL: "https://google.com/", oAuthClientId: "client_id")
    }
}
#endif
