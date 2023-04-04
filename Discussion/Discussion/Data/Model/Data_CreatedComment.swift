//
//  CreatedComment.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation
import Core

public extension DataLayer {
    struct CreatedComment: Codable {
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
        public let abuseFlaggedAnyUser: String?
        public let profileImage: ProfileImage

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
            case abuseFlaggedAnyUser = "abuse_flagged_any_user"
            case profileImage = "profile_image"
        }
    }
}

public extension DataLayer.CreatedComment {
    var domain: Post {
        Post(authorName: author ?? DiscussionLocalization.anonymous,
             authorAvatar: profileImage.imageURLSmall?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "",
                     postDate: Date(iso8601: createdAt),
                     postTitle: "",
                     postBodyHtml: renderedBody,
                     postBody: rawBody,
                     postVisible: true,
                     voted: voted,
                     followed: false,
                     votesCount: voteCount,
                     responsesCount: 0,
                     comments: [],
                     threadID: threadID,
                     commentID: id,
                     parentID: parentID,
                     abuseFlagged: abuseFlagged)
    }
}
