//
//  Environment.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core
import FirebaseCore

final class BuildConfiguration: BuildConfiguratable {

    var environment: Environment

    var baseURL: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "https://example-dev.com"
        case .debugStage, .releaseStage:
            return "https://example-stage.com"
        case .debugProd, .releaseProd:
            return "https://example.com"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "DEV_CLIENT_ID"
        case .debugStage, .releaseStage:
            return "STAGE_CLIENT_ID"
        case .debugProd, .releaseProd:
            return "PROD_CLIENT_ID"
        }
    }

    var firebaseOptions: FirebaseOptions? {
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

    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}
