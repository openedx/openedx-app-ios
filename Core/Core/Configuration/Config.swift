//
//  Config.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation

public enum TokenType: String {
    case jwt = "JWT"
    case bearer = "BEARER"
}

public protocol Configurable {
    var baseURL: URL { get }
    var oAuthClientId: String { get }
    var tokenType: TokenType { get }
    var termsOfService: URL? { get }
    var privacyPolicy: URL? { get }
    var feedbackEmail: String { get }
}

public class OpenEdxConfig: Configurable {

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

public class EdxConfig: Configurable {

    public let baseURL: URL
    public let oAuthClientId: String
    public let tokenType: TokenType = .jwt

    public var termsOfService: URL? {
        nil
    }

    public var privacyPolicy: URL? {
        nil
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
public class ConfigMock: OpenEdxConfig {
    public convenience init() {
        self.init(baseURL: "https://google.com/", oAuthClientId: "client_id")
    }
}
#endif
