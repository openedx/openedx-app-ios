//
//  UserComment.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 17.11.2022.
//

import Foundation

public struct UserComment: Hashable, Sendable {
    public let authorName: String
    public let authorAvatar: String
    public let postDate: Date
    public let postTitle: String
    public let postBody: String
    public let postBodyHtml: String
    public let postVisible: Bool
    public var voted: Bool
    public let followed: Bool
    public var votesCount: Int
    public let responsesCount: Int
    public let threadID: String
    public let commentID: String
    public let parentID: String?
    public var abuseFlagged: Bool
    
    public init(
        authorName: String,
        authorAvatar: String,
        postDate: Date,
        postTitle: String,
        postBody: String,
        postBodyHtml: String,
        postVisible: Bool,
        voted: Bool,
        followed: Bool,
        votesCount: Int,
        responsesCount: Int,
        threadID: String,
        commentID: String,
        parentID: String?,
        abuseFlagged: Bool
    ) {
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.postDate = postDate
        self.postTitle = postTitle
        self.postBody = postBody
        self.postBodyHtml = postBodyHtml
        self.postVisible = postVisible
        self.voted = voted
        self.followed = followed
        self.votesCount = votesCount
        self.responsesCount = responsesCount
        self.threadID = threadID
        self.commentID = commentID
        self.parentID = parentID
        self.abuseFlagged = abuseFlagged
    }
}

public extension UserComment {
    var post: Post {
        Post(
            authorName: authorName,
            authorAvatar: authorAvatar,
            postDate: postDate,
            postTitle: postTitle,
            postBodyHtml: postBodyHtml,
            postBody: postBody,
            postVisible: postVisible,
            voted: voted,
            followed: followed,
            votesCount: votesCount,
            responsesCount: responsesCount,
            comments: [],
            threadID: threadID,
            commentID: commentID,
            parentID: parentID,
            abuseFlagged: abuseFlagged,
            closed: false
        )
    }
}
