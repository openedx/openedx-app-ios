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
            return "https://example-dev.com"
        case .debugProd, .releaseProd:
            return "https://example.com"
        }
    }
    
    var clientId: String {
        switch environment {
        case .debugDev, .releaseDev:
            return "DEBUG_CLIENT_ID"
        case .debugProd, .releaseProd:
            return "PROD_CLIENT_ID"
        }
    }
    
    init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
    }
}
