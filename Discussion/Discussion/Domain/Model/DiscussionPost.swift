//
//  DiscussionPost.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation
import SwiftUI
import Core

public enum PostType: String, Codable, Sendable {
    case question
    case discussion
    
    public var localizedValue: String {
        switch self {
        case .question:
            return DiscussionLocalization.PostType.question
        case .discussion:
            return DiscussionLocalization.PostType.discussion
        }
    }
    
    public func getImage() -> Image {
        switch self {
        case .question:
            return CoreAssets.question.swiftUIImage.renderingMode(.template)
        case .discussion:
            return CoreAssets.discussion.swiftUIImage.renderingMode(.template)
        }
    }
}

public struct DiscussionPost: Equatable, Sendable {
    public static func == (lhs: DiscussionPost, rhs: DiscussionPost) -> Bool {
        return lhs.id == rhs.id
    }
    
    public let id: String
    public let title: String
    public let replies: Int
    public let lastPostDate: Date
    public let lastPostDateFormatted: String
    public var isFavorite: Bool
    public let type: PostType
    public let unreadCommentCount: Int
    public let action: (@MainActor @Sendable () -> Void)
    public let hasEndorsed: Bool
    public let voteCount: Int
    public let numPages: Int
    
    public init(
        id: String,
        title: String,
        replies: Int,
        lastPostDate: Date,
        lastPostDateFormatted: String,
        isFavorite: Bool,
        type: PostType,
        unreadCommentCount: Int,
        action: @escaping (
            @MainActor @Sendable () -> Void
        ),
        hasEndorsed: Bool,
        voteCount: Int,
        numPages: Int
    ) {
        self.id = id
        self.title = title
        self.replies = replies
        self.lastPostDate = lastPostDate
        self.lastPostDateFormatted = lastPostDateFormatted
        self.isFavorite = isFavorite
        self.type = type
        self.unreadCommentCount = unreadCommentCount
        self.action = action
        self.hasEndorsed = hasEndorsed
        self.voteCount = voteCount
        self.numPages = numPages
    }
}
