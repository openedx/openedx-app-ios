//
//  UserSettings.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.03.2023.
//

import Foundation

public struct UserSettings: Codable {
    public var wifiOnly: Bool
    public var streamingQuality: StreamingQuality
    
    public init(wifiOnly: Bool, streamingQuality: StreamingQuality) {
        self.wifiOnly = wifiOnly
        self.streamingQuality = streamingQuality
    }
}

public enum StreamingQuality: Codable {
    case auto
    case low
    case medium
    case high
}
