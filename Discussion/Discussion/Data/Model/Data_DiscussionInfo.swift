//
//  Data_DiscussionInfo.swift
//  Discussion
//
//  Created by Eugene Yatsenko on 19.03.2024.
//

import Foundation
import Core

public struct DiscussionBlackout: Sendable {
    var start: String
    var end: String
}

public extension DataLayer {
    struct DiscussionInfo: Codable {
        var discussionID: String?
        var blackouts: [DiscussionBlackout]?
    }

    struct DiscussionBlackout: Codable, Sendable {
        var start: String
        var end: String
    }
}

public extension DataLayer.DiscussionInfo {
    var domain: DiscussionInfo {
        .init(
            discussionID: discussionID,
            blackouts: blackouts?.compactMap { .init(start: $0.start, end: $0.end)  }
        )
    }
}
