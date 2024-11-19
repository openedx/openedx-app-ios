//
//  Post.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation

public struct Post: Sendable {
    public let authorName: String
    public var authorAvatar: String
    public let postDate: Date
    public let postTitle: String
    public let postBodyHtml: String
    public let postBody: String
    public let postVisible: Bool
    public var voted: Bool
    public var followed: Bool
    public var votesCount: Int
    public var responsesCount: Int
    public var comments: [Post]
    public let threadID: String
    public let commentID: String
    public let parentID: String?
    public var abuseFlagged: Bool
    public var closed: Bool
    
    public init(
        authorName: String,
        authorAvatar: String,
        postDate: Date,
        postTitle: String,
        postBodyHtml: String,
        postBody: String,
        postVisible: Bool,
        voted: Bool,
        followed: Bool,
        votesCount: Int,
        responsesCount: Int,
        comments: [Post],
        threadID: String,
        commentID: String,
        parentID: String?,
        abuseFlagged: Bool,
        closed: Bool
    ) {
        self.authorName = authorName
        self.authorAvatar = authorAvatar
        self.postDate = postDate
        self.postTitle = postTitle
        self.postBodyHtml = postBodyHtml
        self.postBody = postBody
        self.postVisible = postVisible
        self.voted = voted
        self.followed = followed
        self.votesCount = votesCount
        self.responsesCount = responsesCount
        self.comments = comments
        self.threadID = threadID
        self.commentID = commentID
        self.parentID = parentID
        self.abuseFlagged = abuseFlagged
        self.closed = closed
    }
}
