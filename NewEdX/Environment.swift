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
        case .debugProd, .releaseProd:
            return "https://lms-rg-app-ios-stage.raccoongang.com"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "T7od4OFlYni7hTMnepfQuF1XUoqsESjEClltL40T"
        case .debugProd, .releaseProd:
            return "kHDbLaYlc1lpY1obmyAAEp9dX9qPqeDrBiVGQFIy"
        }
    }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}
