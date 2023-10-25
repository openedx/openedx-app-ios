//
//  Environment.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core
import FirebaseCore

enum `Environment`: String {
    case debugDev = "DebugDev"
    case releaseDev = "ReleaseDev"
    
    case debugStage = "DebugStage"
    case releaseStage = "ReleaseStage"
    
    case debugProd = "DebugProd"
    case releaseProd = "ReleaseProd"
}

class BuildConfiguration {
    static let shared = BuildConfiguration()
    
    var environment: Environment
    
    var baseURL: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "https://raccoonapis.sandbox.edx.org"
        case .debugStage, .releaseStage:
            return "https://raccoonapis.sandbox.edx.org"
        case .debugProd, .releaseProd:
            return "https://raccoonapis.sandbox.edx.org"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "rg-edx-oauth-client-id"
        case .debugStage, .releaseStage:
            return "rg-edx-oauth-client-id"
        case .debugProd, .releaseProd:
            return "rg-edx-oauth-client-id"
        }
    }
    
    var firebaseOptions: FirebaseOptions {
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
