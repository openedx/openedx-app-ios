//
//  DiscussionEndpoint.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.10.2022.
//

import Foundation
import Core
import OEXFoundation
import Alamofire

enum DiscussionEndpoint: EndPointType {
    case getCourseDiscussionInfo(courseID: String)
    case getThreads(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int)
    case getThread(threadID: String)
    case getTopics(courseID: String)
    case getTopic(courseID: String, topicID: String)
    case getDiscussionComments(threadID: String, page: Int)
    case getQuestionComments(threadID: String, page: Int)
    case getCommentResponses(commentID: String, page: Int)
    case getResponse(responseID: String)
    case addCommentTo(threadID: String, rawBody: String, parentID: String? = nil)
    case voteThread(voted: Bool, threadID: String)
    case voteResponse(voted: Bool, responseID: String)
    case flagThread(abuseFlagged: Bool, threadID: String)
    case flagComment(abuseFlagged: Bool, commentID: String)
    case followThread(following: Bool, threadID: String)
    case createNewThread(newThread: DiscussionNewThread)
    case readBody(threadID: String)
    case searchThreads(courseID: String, searchText: String, pageNumber: Int = 1)
    
    var path: String {
        switch self {
        case let .getCourseDiscussionInfo(courseID):
            return "/api/discussion/v1/courses/\(courseID)"
        case .getThreads:
            return "/api/discussion/v1/threads/"
        case let .getThread(threadID):
            return "/api/discussion/v1/threads/\(threadID)/"
        case let .getTopics(courseID):
            return "/api/discussion/v1/course_topics/\(courseID)"
        case let .getTopic(courseID, _):
            return "/api/discussion/v1/course_topics/\(courseID)"
        case .getDiscussionComments:
            return "/api/discussion/v1/comments/"
        case .getQuestionComments:
            return "/api/discussion/v1/comments/"
        case let .getCommentResponses(commentID, _):
            return "/api/discussion/v1/comments/\(commentID)"
        case let .getResponse(responseID):
            return "/api/discussion/v1/comments/\(responseID)/"
        case .addCommentTo:
            return "/api/discussion/v1/comments/"
        case let .voteThread(_, threadID):
            return "/api/discussion/v1/threads/\(threadID)/"
        case let .voteResponse(_, responseID):
            return "/api/discussion/v1/comments/\(responseID)/"
        case let .flagThread(_, threadID):
            return "/api/discussion/v1/threads/\(threadID)/"
        case let .flagComment(_, commentID):
            return "/api/discussion/v1/comments/\(commentID)/"
        case let .followThread(_, threadID):
            return "/api/discussion/v1/threads/\(threadID)/"
        case .createNewThread:
            return "/api/discussion/v1/threads/"
        case .readBody(threadID: let threadID):
            return "/api/discussion/v1/threads/\(threadID)/"
        case .searchThreads:
            return "/api/discussion/v1/threads/"
        }
    
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCourseDiscussionInfo:
            return .get
        case .getThreads, .getThread:
            return .get
        case .getTopics, .getTopic:
            return .get
        case .getDiscussionComments:
            return .get
        case .getQuestionComments:
            return .get
        case .getCommentResponses:
            return .get
        case .getResponse:
            return .patch
        case .addCommentTo:
            return .post
        case .voteThread:
            return .patch
        case .voteResponse:
            return .patch
        case .flagThread:
            return .patch
        case .flagComment:
            return .patch
        case .followThread:
            return .patch
        case .createNewThread:
            return .post
        case .readBody:
            return .patch
        case .searchThreads:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .getCourseDiscussionInfo,
                .getThreads,
                .getThread,
                .getTopics,
                .getTopic,
                .getDiscussionComments,
                .getQuestionComments,
                .getCommentResponses,
                .addCommentTo,
                .createNewThread,
                .searchThreads:
            return nil
        case .voteThread,
                .voteResponse,
                .flagThread,
                .flagComment,
                .followThread,
                .readBody,
                .getResponse:
            return ["Content-Type": "application/merge-patch+json"]
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getCourseDiscussionInfo:
            return .requestParameters(encoding: URLEncoding.queryString)
        case let .getThreads(courseID, type, sort, filter, page):
            var parameters: [String: Encodable & Sendable]
            switch type {
            case .allPosts:
                parameters = [
                    "course_id": courseID,
                    "requested_fields": "profile_image",
                    "page": page
                ]
            case .followingPosts:
                parameters = [
                    "course_id": courseID,
                    "following": true,
                    "requested_fields": "profile_image",
                    "page": page
                ]
            case .nonCourseTopics:
                parameters = [
                    "course_id": courseID,
                    "topic_id": "course",
                    "requested_fields": "profile_image",
                    "page": page
                ]
            case let .courseTopics(topicID):
                parameters = [
                    "course_id": courseID,
                    "topic_id": topicID,
                    "requested_fields": "profile_image",
                    "page": page
                ]
            }
            switch filter {
            case .allThreads:
                break
            case .unread:
                parameters["view"] = "unread"
            case .unanswered:
                parameters["view"] = "unanswered"
            }
            switch sort {
            case .recentActivity:
                parameters["order_by"] = "last_activity_at"
            case .mostActivity:
                parameters["order_by"] = "comment_count"
            case .mostVotes:
                parameters["order_by"] = "vote_count"
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getThread:
            return .requestParameters(
                parameters: ["requested_fields": "profile_image"],
                encoding: URLEncoding.queryString
            )
        case .getTopics:
            return .requestParameters(encoding: URLEncoding.queryString)
        case let .getTopic(_, topicID):
            let parameters: [String: Encodable & Sendable] = [
                "topic_id": topicID
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .getDiscussionComments(threadID, page):
            let parameters: [String: Encodable & Sendable] = [
                "thread_id": threadID,
                "requested_fields": "profile_image",
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .getQuestionComments(threadID, page):
            let parameters: [String: Encodable & Sendable] = [
                "thread_id": threadID,
                "endorsed": false,
                "requested_fields": "profile_image",
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case let .getCommentResponses(_, page):
            let parameters: [String: Encodable & Sendable] = [
                "requested_fields": "profile_image",
                "page": page
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        case .getResponse:
            return .requestParameters(parameters: [:], encoding: URLEncoding.queryString)
        case let .addCommentTo(threadID, rawBody, parentID):
            var parameters: [String: Encodable & Sendable] = [
                "thread_id": threadID,
                "raw_body": rawBody
            ]
            if parentID != "" {
                parameters["parent_id"] = parentID
            }
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .voteThread(voted, _):
            let parameters: [String: Encodable & Sendable] = [
                "voted": !voted
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .voteResponse(voted, _):
            let parameters: [String: Encodable & Sendable] = [
                "voted": !voted
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .flagThread(abuseFlagged, _):
            let parameters: [String: Encodable & Sendable] = [
                "abuse_flagged": !abuseFlagged
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .flagComment(abuseFlagged, _):
            let parameters: [String: Encodable & Sendable] = [
                "abuse_flagged": !abuseFlagged
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .followThread(following, _):
            let parameters: [String: Encodable & Sendable] = [
                "following": !following
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .createNewThread(newThread):
            let parameters: [String: Encodable & Sendable] = [
                "course_id": newThread.courseID,
                "topic_id": newThread.topicID,
                "type": newThread.type.rawValue,
                "title": newThread.title,
                "raw_body": newThread.rawBody,
                "following": newThread.followPost
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .readBody:
            let parameters: [String: Encodable & Sendable] = [
                "read": true
            ]
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case .searchThreads(courseID: let courseID, searchText: let searchText, pageNumber: let pageNumber):
            let parameters: [String: Encodable & Sendable] = [
                "course_id": courseID,
                "text_search": searchText,
                "page": pageNumber,
                "requested_fields": "profile_image"
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
}
