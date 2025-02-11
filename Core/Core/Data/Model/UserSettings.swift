//
//  UserSettings.swift
//  Core
//
//  Created by  Stepanok Ivan on 17.03.2023.
//

import Foundation

public struct UserSettings: Codable, Hashable, Sendable {
    public var wifiOnly: Bool
    public var streamingQuality: StreamingQuality
    public var downloadQuality: DownloadQuality
    public var videoPlaybackSpeed: Float

    public init(
        wifiOnly: Bool,
        streamingQuality: StreamingQuality,
        downloadQuality: DownloadQuality,
        playbackSpeed: Float
    ) {
        self.wifiOnly = wifiOnly
        self.streamingQuality = streamingQuality
        self.downloadQuality = downloadQuality
        self.videoPlaybackSpeed = playbackSpeed
    }
}

public enum StreamingQuality: Codable, Sendable {
    case auto
    case low
    case medium
    case high
    
    public var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
    
    public var resolution: CGSize {
        switch self {
        case .auto:
            return CGSize(width: 1280, height: 720)
        case .low:
            return CGSize(width: 640, height: 360)
        case .medium:
            return CGSize(width: 854, height: 480)
        case .high:
            return CGSize(width: 1280, height: 720)
        }
    }
}

public enum DownloadQuality: Codable, CaseIterable, Sendable {
    case auto
    case low
    case medium
    case high
    
    public var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
    
}
