//
//  WhatsNewModel.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 19.10.2023.
//

import Foundation
import SwiftUI

// MARK: - WhatsNewModelElement
public struct WhatsNewModelElement: Codable {
    public let version: String
    public let messages: [Message]
    
    public init(version: String, messages: [Message]) {
        self.version = version
        self.messages = messages
    }
}

// MARK: - Message
public struct Message: Codable {
    public let image: String
    public let title: String
    public let message: String

    public init(image: String, title: String, message: String) {
        self.image = image
        self.title = title
        self.message = message
    }
}

public typealias WhatsNewModel = [WhatsNewModelElement]

extension WhatsNewModel {
    
    private func compareVersions(_ version1: String, _ version2: String) -> ComparisonResult {
        let v1 = version1.split(separator: ".").compactMap { Int($0) }
        let v2 = version2.split(separator: ".").compactMap { Int($0) }

        for (a, b) in zip(v1, v2) {
            if a != b {
                return a < b ? .orderedAscending : .orderedDescending
            }
        }

        return v1.count < v2.count ? .orderedAscending : (v1.count > v2.count ? .orderedDescending : .orderedSame)
    }

    private func findLatestVersion(_ versions: [String]) -> String? {
        guard let latestVersion = versions.max(by: { compareVersions($0, $1) == .orderedAscending }) else {
            return nil
        }
        return latestVersion
    }
    
    
    var domain: [WhatsNewPage] {
        guard let latestVersion = findLatestVersion(self.map { $0.version }) else { return [] }
        return self.first(where: { $0.version == latestVersion })?.messages.map {
                WhatsNewPage(image: $0.image,
                             title: $0.title,
                             description: $0.message)
        } ?? []
    }
}
