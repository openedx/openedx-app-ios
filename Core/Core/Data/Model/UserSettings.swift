//
//  UserSettings.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.03.2023.
//

import Foundation

public struct UserSettings: Codable {
    public var wifiOnly: Bool
    public var downloadQuality: VideoQuality
    
    public init(wifiOnly: Bool, downloadQuality: VideoQuality) {
        self.wifiOnly = wifiOnly
        self.downloadQuality = downloadQuality
    }
}

public enum VideoQuality: Codable {
    case auto
    case low
    case medium
    case high
}
