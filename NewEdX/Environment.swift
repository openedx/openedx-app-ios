//
//  Environment.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation

enum Environment: String {
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
    
    private var configuration: [String: Any] = [:]
    
    var baseURL: String {
        guard let environmentConfig = configuration[environment.rawValue] as? [String: Any],
              let baseURL = environmentConfig["baseURL"] as? String else {
            fatalError("Missing baseURL configuration for environment: \(environment.rawValue)")
        }
        return baseURL
    }
    
    var clientId: String {
        guard let environmentConfig = configuration[environment.rawValue] as? [String: Any],
              let clientId = environmentConfig["clientId"] as? String else {
            fatalError("Missing clientId configuration for environment: \(environment.rawValue)")
        }
        return clientId
    }
    
    private init() {
        let currentConfiguration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as! String
        environment = Environment(rawValue: currentConfiguration)!
        
        guard let url = Bundle.main.url(forResource: "Configuration", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
            fatalError("Failed to load Configuration.json")
        }
        
        configuration = json
    }
}

/*-
 
 MARK: Example of Configuration.json 
 
{
  "DebugDev": {
    "baseURL": "https://example.com",
    "clientId": "DEBUG_CLIENT_ID"
  },
  "ReleaseDev": {
    "baseURL": "https://example.com",
    "clientId": "RELEASE_CLIENT_ID"
  },
  "DebugStage": {
 "baseURL": "https://example.com",
    "clientId": "DEBUG_CLIENT_ID"
  },
  "ReleaseStage": {
 "baseURL": "https://example.com",
    "clientId": "RELEASE_CLIENT_ID"
  },
  "DebugProd": {
    "baseURL": "https://example.com",
    "clientId": "PROD_CLIENT_ID"
  },
  "ReleaseProd": {
    "baseURL": "https://example.com",
    "clientId": "PROD_CLIENT_ID"
  }
}
 */
