//
//  CommentsResponse.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 17.11.2022.
//

import Foundation
import Core

public extension DataLayer {
    // MARK: - CommentsResponse
    struct CommentsResponse: Codable {
        public var comments: [Comments]
        public let pagination: Pagination
        
        enum CodingKeys: String, CodingKey {
            case comments = "results"
            case pagination = "pagination"
        }
        
        public init(comments: [Comments], pagination: Pagination) {
            self.comments = comments
            self.pagination = pagination
        }
    }
    
    // MARK: - Comments
    struct Comments: Codable {
        public let id: String
        public let author: String?
        public let authorLabel: String?
        public let createdAt: String
        public let updatedAt: String
        public let rawBody: String
        public let renderedBody: String
        public let abuseFlagged: Bool
        public let voted: Bool
        public let voteCount: Int
        public let editableFields: [String]
        public let canDelete: Bool
        public let threadID: String
        public let parentID: String?
        public let endorsed: Bool
        public let endorsedBy: String?
        public let endorsedByLabel: String?
        public let endorsedAt: String?
        public let childCount: Int
        public let children: [String]
        public let users: Users?
        
        enum CodingKeys: String, CodingKey {
            case id = "id"
            case author = "author"
            case authorLabel = "author_label"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case rawBody = "raw_body"
            case renderedBody = "rendered_body"
            case abuseFlagged = "abuse_flagged"
            case voted = "voted"
            case voteCount = "vote_count"
            case editableFields = "editable_fields"
            case canDelete = "can_delete"
            case threadID = "thread_id"
            case parentID = "parent_id"
            case endorsed = "endorsed"
            case endorsedBy = "endorsed_by"
            case endorsedByLabel = "endorsed_by_label"
            case endorsedAt = "endorsed_at"
            case childCount = "child_count"
            case children = "children"
            case users
        }
        
        public init(id: String, author: String?, authorLabel: String?, createdAt: String, updatedAt: String, rawBody: String,
                    renderedBody: String, abuseFlagged: Bool, voted: Bool, voteCount: Int, editableFields: [String],
                    canDelete: Bool, threadID: String, parentID: String?, endorsed: Bool, endorsedBy: String?,
                    endorsedByLabel: String?, endorsedAt: String?, childCount: Int, children: [String], users: Users?) {
            self.id = id
            self.author = author
            self.authorLabel = authorLabel
            self.createdAt = createdAt
            self.updatedAt = updatedAt
            self.rawBody = rawBody
            self.renderedBody = renderedBody
            self.abuseFlagged = abuseFlagged
            self.voted = voted
            self.voteCount = voteCount
            self.editableFields = editableFields
            self.canDelete = canDelete
            self.threadID = threadID
            self.parentID = parentID
            self.endorsed = endorsed
            self.endorsedBy = endorsedBy
            self.endorsedByLabel = endorsedByLabel
            self.endorsedAt = endorsedAt
            self.childCount = childCount
            self.children = children
            self.users = users
        }
    }
}

public extension DataLayer.CommentsResponse {
    var domain: [UserComment] {
        self.comments.map { comment in
            UserComment(
                authorName: comment.author ?? DiscussionLocalization.anonymous,
                authorAvatar: comment.users?.userName?.profile?.image?.imageURLLarge ?? "",
                postDate: Date(iso8601: comment.createdAt),
                postTitle: "",
                postBody: comment.rawBody,
                postBodyHtml: comment.renderedBody,
                postVisible: true,
                voted: comment.voted,
                followed: false,
                votesCount: comment.voteCount,
                responsesCount: comment.childCount,
                threadID: comment.threadID,
                commentID: comment.id,
                parentID: comment.id,
                abuseFlagged: comment.abuseFlagged
            )
        }
    }
}
