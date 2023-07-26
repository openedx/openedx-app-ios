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
            return "https://edxdev.yam-edu.com"
        case .debugStage, .releaseStage:
            return "https://edxdev.yam-edu.com"
        case .debugProd, .releaseProd:
            return "https://my.yam-edu.com"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "g7H79XL9yCCKKha70vcLE5dKJCTyYuKthk9OPtwl"
        case .debugStage, .releaseStage:
            return "g7H79XL9yCCKKha70vcLE5dKJCTyYuKthk9OPtwl"
        case .debugProd, .releaseProd:
            return "PROD_CLIENT_ID"
        }
    }
    
    var auth0Options: (clientId: String, domain: String) {
        switch environment {
        case .debugDev, .releaseDev:
            return (clientId: "EkrBs0k1OZ5PtlNSDnGEpKCnYEC5feA5", domain: "auth.yam-edu.com")
        case .debugStage, .releaseStage:
            return (clientId: "EkrBs0k1OZ5PtlNSDnGEpKCnYEC5feA5", domain: "auth.yam-edu.com")
        case .debugProd, .releaseProd:
            return (clientId: "EkrBs0k1OZ5PtlNSDnGEpKCnYEC5feA5", domain: "auth.yam-edu.com")
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
