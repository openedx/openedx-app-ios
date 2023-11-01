//
//  ConfigMock.swift
//  Core
//
//  Created by Eugene Yatsenko on 01.11.2023.
//

import Foundation
import FirebaseCore

#if DEBUG
public class ConfigMock: Configurable {

    // MARK: - App Configuratable -

    public var app: Apps { .openEdx }

    public var environment: BuildConfiguration

    public var baseURL: URL {
        switch environment {
        case .debugDev, .releaseDev:
            return URL(string: "https://example-dev.com")!
        case .debugStage, .releaseStage:
            return URL(string: "https://example-stage.com")!
        case .debugProd, .releaseProd:
            return URL(string: "https://example.com")!
        }
    }

    public var oAuthClientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "DEV_CLIENT_ID"
        case .debugStage, .releaseStage:
            return "STAGE_CLIENT_ID"
        case .debugProd, .releaseProd:
            return "PROD_CLIENT_ID"
        }
    }

    public let tokenType: TokenType = .jwt

    public var firebaseOptions: FirebaseOptions? {
        switch environment {
        case .debugDev, .releaseDev:
            let firebaseOptions = FirebaseOptions(googleAppID: "",
                                                  gcmSenderID: "")
            firebaseOptions.apiKey = ""
            firebaseOptions.projectID = ""
            firebaseOptions.bundleID = ""
            firebaseOptions.clientID = ""
            firebaseOptions.storageBucket = ""

            return firebaseOptions
        case .debugStage, .releaseStage:
            let firebaseOptions = FirebaseOptions(googleAppID: "",
                                                  gcmSenderID: "")
            firebaseOptions.apiKey = ""
            firebaseOptions.projectID = ""
            firebaseOptions.bundleID = ""
            firebaseOptions.clientID = ""
            firebaseOptions.storageBucket = ""

            return firebaseOptions
        case .debugProd, .releaseProd:
            let firebaseOptions = FirebaseOptions(googleAppID: "",
                                                  gcmSenderID: "")
            firebaseOptions.apiKey = ""
            firebaseOptions.projectID = ""
            firebaseOptions.bundleID = ""
            firebaseOptions.clientID = ""
            firebaseOptions.storageBucket = ""

            return firebaseOptions
        }
    }

    // MARK: - Configuratable -

    public var socialLoginEnable: Bool {
        false
    }

    public var termsOfService: URL? {
        nil
    }

    public var privacyPolicy: URL? {
        nil
    }

    public let feedbackEmail = "support@example.com"

    public init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = BuildConfiguration(rawValue: currentConfiguration)!
    }
}
#endif
