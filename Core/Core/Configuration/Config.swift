//
//  Config.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation

public class Config {
    
    public let baseURL: URL
    public let oAuthClientId: String
    public let tokenType: TokenType = .jwt
    
    public lazy var termsOfUse: URL? = {
        URL(string: "\(baseURL.description)/tos")
    }()
    
    public lazy var privacyPolicy: URL? = {
        URL(string: "\(baseURL.description)/privacy")
    }()
    
    public let feedbackEmail = "support@example.com"
    
    private let appStoreId = "0000000000"
    public var appStoreLink: String {
        "itms-apps://itunes.apple.com/app/id\(appStoreId)?mt=8"
    }
    public let whatsNewEnabled: Bool = false
    
    public init(baseURL: String, oAuthClientId: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Ivalid baseURL")
        }
        self.baseURL = url
        self.oAuthClientId = oAuthClientId
    }
}

public extension Config {
    enum TokenType: String {
        case jwt = "JWT"
        case bearer = "BEARER"
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
