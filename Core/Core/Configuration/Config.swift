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
    public let auth0Domain: String
    public let auth0ClientId: String
    
    public lazy var termsOfUse: URL? = {
        URL(string: "\(baseURL.description)/tos")
    }()
    
    public lazy var privacyPolicy: URL? = {
        URL(string: "\(baseURL.description)/privacy")
    }()
    
    public let feedbackEmail = "support@example.com"
    
    public init(baseURL: String, oAuthClientId: String, auth0ClientId: String, auth0Domain: String) {
        guard let url = URL(string: baseURL) else {
            fatalError("Ivalid baseURL")
        }
        self.baseURL = url
        self.oAuthClientId = oAuthClientId
        self.auth0ClientId = auth0ClientId
        self.auth0Domain = auth0Domain
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class ConfigMock: Config {
    public convenience init() {
        self.init(
            baseURL: "https://google.com/",
            oAuthClientId: "client_id",
            auth0ClientId: "auth0_client_id",
            auth0Domain: "auth0_domain"
        )
    }
}
#endif
