//
//  DiscussionInfo.swift
//  Discussion
//
//  Created by Eugene Yatsenko on 19.03.2024.
//

import Foundation

public struct DiscussionInfo: Sendable {
    public var discussionID: String?
    public var blackouts: [DiscussionBlackout]?

    public func isBlackedOut() -> Bool {
        guard let blackouts = blackouts else {
            return false
        }
        var isBlackedOut = false
        for blackout in blackouts {
            let start = Date(iso8601: blackout.start)
            let end = Date(iso8601: blackout.end)

            if Date().isEarlierThanOrEqualTo(date: end) &&
                Date().isLaterThanOrEqualTo(date: start) {
                isBlackedOut = true
            }
        }

        return isBlackedOut
    }
}
