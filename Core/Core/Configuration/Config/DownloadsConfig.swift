//
//  DownloadsConfig.swift
//  Core
//
//  Created by Ivan Stepanok on 7-03-2025.
//

import Foundation

private enum DownloadsKeys: String {
    case enabled = "ENABLED"
}

public final class DownloadsConfig: NSObject {
    public var enabled: Bool = true

    init(dictionary: [String: AnyObject]) {
        super.init()
        if let isEnabled = dictionary[DownloadsKeys.enabled.rawValue] as? Bool {
            enabled = isEnabled
        }
    }
}

private let key = "DOWNLOADS"
extension Config {
    public var downloads: DownloadsConfig {
        DownloadsConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}
