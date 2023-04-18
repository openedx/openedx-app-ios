//
//  ThreadResponse.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 17.11.2022.
//

import Foundation
import Core

public extension DataLayer {
    // MARK: - ThreadLists
    struct ThreadListsResponse: Codable {
        public let threads: [ThreadList]
        public let textSearchRewrite: String?
        public let pagination: Pagination
        
        enum CodingKeys: String, CodingKey {
            case threads = "results"
            case textSearchRewrite = "text_search_rewrite"
            case pagination = "pagination"
        }
        
        public init(threads: [ThreadList], textSearchRewrite: String?, pagination: Pagination) {
            self.threads = threads
            self.textSearchRewrite = textSearchRewrite
            self.pagination = pagination
        }
    }
 
    // MARK: - Thread
    struct ThreadList: Codable {
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
        public let courseID: String
        public let type: PostType
        public let title: String
        public let pinned: Bool
        public let closed: Bool
        public let following: Bool
        public let commentCount: Int
        public let unreadCommentCount: Int
        public let read: Bool
        public let hasEndorsed: Bool
        public let users: Users?
        
        enum CodingKeys: String, CodingKey {
            case id
            case author
            case authorLabel = "author_label"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case rawBody = "raw_body"
            case renderedBody = "rendered_body"
            case abuseFlagged = "abuse_flagged"
            case voted
            case voteCount = "vote_count"
            case courseID = "course_id"
            case type
            case title
            case pinned
            case closed
            case following
            case commentCount = "comment_count"
            case unreadCommentCount = "unread_comment_count"
            case read
            case hasEndorsed = "has_endorsed"
            case users
        }
    }
    
    // MARK: - Users
    struct Users: Codable {
        public let userName: UserName?
    }

    // MARK: - UserName
    struct UserName: Codable {
        public let profile: Profile?
    }

    // MARK: - Profile
    struct Profile: Codable {
        public let image: AvatarImage?
    }

    // MARK: - Image
    struct AvatarImage: Codable {
        public let hasImage: Bool?
        public let imageURLFull: String?
        public let imageURLLarge: String?
        public let imageURLMedium: String?
        public let imageURLSmall: String?
        
        enum CodingKeys: String, CodingKey {
            case hasImage = "has_image"
            case imageURLFull = "image_url_full"
            case imageURLLarge = "image_url_large"
            case imageURLMedium = "image_url_medium"
            case imageURLSmall = "image_url_small"
        }
    }
}
