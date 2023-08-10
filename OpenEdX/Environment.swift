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
            return "https://lms-rg-app-ios-dev.raccoongang.com"
        case .debugStage, .releaseStage:
            return "https://lms-rg-app-ios-stage.raccoongang.com"
        case .debugProd, .releaseProd:
            return "https://example.com"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "T7od4OFlYni7hTMnepfQuF1XUoqsESjEClltL40T"
        case .debugStage, .releaseStage:
            return "kHDbLaYlc1lpY1obmyAAEp9dX9qPqeDrBiVGQFIy"
        case .debugProd, .releaseProd:
            return "PROD_CLIENT_ID"
        }
    }
    
    var firebaseOptions: FirebaseOptions {
        switch environment {
        case .debugDev, .releaseDev:
            let firebaseOptions = FirebaseOptions(googleAppID: "1:60657986297:ios:bf0254060e5c3779581028",
                                                  gcmSenderID: "60657986297")
            firebaseOptions.apiKey = "AIzaSyCKj--Dfkq08r4P1d2q7Tz36gu9SQ9Apbs"
            firebaseOptions.projectID = "openedxmobile-dev"
            firebaseOptions.bundleID = "com.raccoongang.NewEdX.dev"
            firebaseOptions.clientID = "60657986297-t6utefrq6tt0tscr85igqh0ni9gtis8l.apps.googleusercontent.com"
            firebaseOptions.storageBucket = "openedxmobile-dev.appspot.com"
            
            return firebaseOptions
        case .debugStage, .releaseStage:
            let firebaseOptions = FirebaseOptions(googleAppID: "1:156114692773:ios:8058bca851a8bc7c187b4c",
                                                  gcmSenderID: "156114692773")
            firebaseOptions.apiKey = "AIzaSyCKAIXDLM7pnX43P_viTsfgbxrLBOaJwGo"
            firebaseOptions.projectID = "openedxmobile-stage"
            firebaseOptions.bundleID = "com.raccoongang.NewEdX.stage"
            firebaseOptions.clientID = "156114692773-r5pgdcdjqq7sup75fdla4lk3q3kjc6m8.apps.googleusercontent.com"
            firebaseOptions.storageBucket = "openedxmobile-stage.appspot.com"
            
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
