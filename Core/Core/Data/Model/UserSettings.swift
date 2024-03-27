//
//  UserSettings.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.03.2023.
//

import Foundation

public struct UserSettings: Codable, Hashable {
    public var wifiOnly: Bool
    public var streamingQuality: StreamingQuality
    public var downloadQuality: DownloadQuality

    public init(
        wifiOnly: Bool,
        streamingQuality: StreamingQuality,
        downloadQuality: DownloadQuality
    ) {
        self.wifiOnly = wifiOnly
        self.streamingQuality = streamingQuality
        self.downloadQuality = downloadQuality
    }
}

public enum StreamingQuality: Codable {
    case auto
    case low
    case medium
    case high
    
    public var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
}

public enum DownloadQuality: Codable, CaseIterable {
    case auto
    case low
    case medium
    case high
    
    public var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
    
}
