//
//  UserThread.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 17.11.2022.
//

import Foundation
import Core

public struct ThreadLists: Sendable {
    public var threads: [UserThread]
    
    public init(threads: [UserThread]) {
        self.threads = threads
    }
}

public struct UserThread: Sendable {
    public let id: String
    public let author: String
    public let authorLabel: String
    public let createdAt: Date
    public var updatedAt: Date
    public let rawBody: String
    public let renderedBody: String
    public var voted: Bool
    public var voteCount: Int
    public let courseID: String
    public let type: PostType
    public let title: String
    public let pinned: Bool
    public let closed: Bool
    public var following: Bool
    public var commentCount: Int
    public var avatar: String
    public var unreadCommentCount: Int
    public var abuseFlagged: Bool
    public let hasEndorsed: Bool
    public let numPages: Int
    
    public init(
        id: String,
        author: String,
        authorLabel: String,
        createdAt: Date,
        updatedAt: Date,
        rawBody: String,
        renderedBody: String,
        voted: Bool,
        voteCount: Int,
        courseID: String,
        type: PostType,
        title: String,
        pinned: Bool,
        closed: Bool,
        following: Bool,
        commentCount: Int,
        avatar: String,
        unreadCommentCount: Int,
        abuseFlagged: Bool,
        hasEndorsed: Bool,
        numPages: Int
    ) {
        self.id = id
        self.author = author
        self.authorLabel = authorLabel
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.rawBody = rawBody
        self.renderedBody = renderedBody
        self.voted = voted
        self.voteCount = voteCount
        self.courseID = courseID
        self.type = type
        self.title = title
        self.pinned = pinned
        self.closed = closed
        self.following = following
        self.commentCount = commentCount
        self.avatar = avatar
        self.unreadCommentCount = unreadCommentCount
        self.abuseFlagged = abuseFlagged
        self.hasEndorsed = hasEndorsed
        self.numPages = numPages
    }
}

public extension UserThread {
    func discussionPost(useRelativeDates: Bool, action: @escaping (@MainActor @Sendable () -> Void)) -> DiscussionPost {
        return DiscussionPost(
            id: id,
            title: title,
            replies: commentCount,
            lastPostDate: updatedAt,
            lastPostDateFormatted: updatedAt.dateToString(
                style: .lastPost,
                useRelativeDates: useRelativeDates
            ),
            isFavorite: following,
            type: type,
            unreadCommentCount: unreadCommentCount,
            action: action,
            hasEndorsed: hasEndorsed,
            voteCount: voteCount,
            numPages: numPages
        )
    }
}

public extension DataLayer.ThreadListsResponse {
    var domain: ThreadLists {
        let threadsReady = threads.map({
            UserThread(id: $0.id,
                       author: $0.author ?? DiscussionLocalization.anonymous,
                       authorLabel: $0.authorLabel ?? "",
                       createdAt: Date(iso8601: $0.createdAt),
                       updatedAt: Date(iso8601: $0.updatedAt),
                       rawBody: $0.rawBody,
                       renderedBody: $0.renderedBody,
                       voted: $0.voted,
                       voteCount: $0.voteCount,
                       courseID: $0.courseID,
                       type: $0.type,
                       title: $0.title,
                       pinned: $0.pinned,
                       closed: $0.closed,
                       following: $0.following,
                       commentCount: $0.commentCount,
                       avatar: $0.users?.userName?.profile?.image?.imageURLLarge ?? "",
                       unreadCommentCount: $0.unreadCommentCount,
                       abuseFlagged: $0.abuseFlagged,
                       hasEndorsed: $0.hasEndorsed,
                       numPages: pagination.numPages)
        })
        return ThreadLists(threads: threadsReady)
    }
}

public extension DataLayer.ThreadList {
    var userThread: UserThread {
        UserThread(
            id: id,
            author: author ?? DiscussionLocalization.anonymous,
            authorLabel: authorLabel ?? "",
            createdAt: Date(iso8601: createdAt),
            updatedAt: Date(iso8601: updatedAt),
            rawBody: rawBody,
            renderedBody: renderedBody,
            voted: voted,
            voteCount: voteCount,
            courseID: courseID,
            type: type,
            title: title,
            pinned: pinned,
            closed: closed,
            following: following,
            commentCount: commentCount,
            avatar: users?.userName?.profile?.image?.imageURLLarge ?? "",
            unreadCommentCount: unreadCommentCount,
            abuseFlagged: abuseFlagged,
            hasEndorsed: hasEndorsed,
            numPages: 0
        )
    }
}
