//
//  Environment.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation

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
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}
