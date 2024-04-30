//
//  ServerConfig.swift
//  Core
//
//  Created by Saeed Bashir on 4/29/24.
//

import Foundation

private enum Keys: String, RawStringExtractable {
    case valuePropEnabled = "value_prop_enabled"
}

public protocol ServerConfigProtocol {
    var valuePropEnabled: Bool { get }
    var iapConfig: IAPConfig { get }
    func initialize(config: DataLayer.ServerConfigs)
}

public class ServerConfig: ServerConfigProtocol {
    var config: [String: Any] = [:]
    
    public init () {}
    
    public func initialize(config: DataLayer.ServerConfigs) {
        let configSring = config.config
        guard let configData = configSring.data(using: .utf8),
              let config = try? JSONSerialization.jsonObject(with: configData, options: []) as? [String: Any]
        else { return }
        
        self.config = config
    }
    
    public var valuePropEnabled: Bool {
        return config[Keys.valuePropEnabled] as? Bool ?? false
    }
}
