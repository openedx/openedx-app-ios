//
//  WhatsNewModel.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 19.10.2023.
//

import Foundation

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
    
    private func findLatestVersion(_ versions: [String]) -> String? {
        guard let latestVersion = versions.max(by: { $0.isAppVersionGreater(than: $1) == false }) else {
            return nil
        }
        return latestVersion
    }
    
    var domain: [WhatsNewPage] {
        guard let latestVersion = findLatestVersion(self.map { $0.version }) else { return [] }
        return self.first(where: { $0.version == latestVersion })?.messages.map {
            WhatsNewPage(
                image: $0.image,
                title: $0.title,
                description: $0.message
            )
        } ?? []
    }
}
