//
//  DiscussionRepository.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.10.2022.
//

import Foundation
import Core
import Combine

public protocol DiscussionRepositoryProtocol {
    func getThreads(courseID: String, type: ThreadType, filter: ThreadsFilter, page: Int) async throws -> ThreadLists
    func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists
    func getTopics(courseID: String) async throws -> Topics
    func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Int)
    func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Int)
    func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Int)
    func addCommentTo(threadID: String, rawBody: String, parentID: String?) async throws -> Post
    func voteThread(voted: Bool, threadID: String) async throws
    func voteResponse(voted: Bool, responseID: String) async throws
    func flagThread(abuseFlagged: Bool, threadID: String) async throws
    func flagComment(abuseFlagged: Bool, commentID: String) async throws
    func followThread(following: Bool, threadID: String) async throws
    func createNewThread(newThread: DiscussionNewThread) async throws
    func readBody(threadID: String) async throws
    func renameThreadUser(data: Data) async throws -> DataLayer.ThreadListsResponse
    func renameUsers(data: Data) async throws -> DataLayer.CommentsResponse
    func renameUsersInJSON(stringJSON: String) -> String
}

public class DiscussionRepository: DiscussionRepositoryProtocol {
    
    private let api: API
    private let appStorage: AppStorage
    private let config: Config
    private let router: DiscussionRouter
    
    public init(api: API, appStorage: AppStorage, config: Config, router: DiscussionRouter) {
        self.api = api
        self.appStorage = appStorage
        self.config = config
        self.router = router
    }
    
    public func getThreads(courseID: String, type: ThreadType, filter: ThreadsFilter, page: Int) async throws -> ThreadLists {
        let threads = try await api.requestData(DiscussionEndpoint
            .getThreads(courseID: courseID, type: type, filter: filter, page: page))
        
        return try await renameThreadUser(data: threads).domain
    }
    
    public func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists {
        let posts = try await api.requestData(DiscussionEndpoint.searchThreads(courseID: courseID,
                                                                               searchText: searchText,
                                                                               pageNumber: pageNumber))
        return try await renameThreadUser(data: posts).domain
    }
    
    public func getTopics(courseID: String) async throws -> Topics {
        let topics = try await api.requestData(DiscussionEndpoint
            .getTopics(courseID: courseID))
            .mapResponse(DataLayer.TopicsResponse.self)
        return topics.domain
    }
    
    public func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        let response = try await api.requestData(DiscussionEndpoint
            .getDiscussionComments(threadID: threadID, page: page))
        let result = try await renameUsers(data: response)
        return (result.domain, result.pagination.numPages)
    }
    
    public func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        let response = try await api.requestData(DiscussionEndpoint
            .getQuestionComments(threadID: threadID, page: page))
        let result = try await renameUsers(data: response)
        return (result.domain, result.pagination.numPages)
    }
    
    public func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Int) {
        let response = try await api.requestData(DiscussionEndpoint
            .getCommentResponses(commentID: commentID, page: page))
        let result = try await renameUsers(data: response)
        return (result.domain, result.pagination.numPages)
    }
    
    public func addCommentTo(threadID: String, rawBody: String, parentID: String? = nil) async throws -> Post {
        let endpoint = DiscussionEndpoint.addCommentTo(threadID: threadID, rawBody: rawBody, parentID: parentID)
        return try await api.requestData(endpoint).mapResponse(DataLayer.CreatedComment.self).domain
    }
    
    public func voteThread(voted: Bool, threadID: String) async throws {
        try await api.requestData(DiscussionEndpoint.voteThread(voted: voted, threadID: threadID))
    }
    
    public func voteResponse(voted: Bool, responseID: String) async throws {
        try await api.requestData(DiscussionEndpoint.voteResponse(voted: voted, responseID: responseID))
    }
    
    public func flagThread(abuseFlagged: Bool, threadID: String) async throws {
        try await api.requestData(DiscussionEndpoint.flagThread(abuseFlagged: abuseFlagged, threadID: threadID))
    }
    
    public func flagComment(abuseFlagged: Bool, commentID: String) async throws {
        try await api.requestData(DiscussionEndpoint.flagComment(abuseFlagged: abuseFlagged, commentID: commentID))
    }
    
    public func followThread(following: Bool, threadID: String) async throws {
        try await api.requestData(DiscussionEndpoint.followThread(following: following, threadID: threadID))
    }
    
    public func createNewThread(newThread: DiscussionNewThread) async throws {
        try await api.requestData(DiscussionEndpoint.createNewThread(newThread: newThread))
    }
    
    public func readBody(threadID: String) async throws {
//        _ = try await api.request(DiscussionEndpoint.readBody(threadID: threadID))
    }
    
    public func renameThreadUser(data: Data) async throws -> DataLayer.ThreadListsResponse {
        var modifiedJSON = ""
        let parsed = try data.mapResponse(DataLayer.ThreadListsResponse.self)
        
        if let stringJSON = String(data: data, encoding: .utf8) {
            modifiedJSON = renameUsersInJSON(stringJSON: stringJSON)
            if let modifiedParsed = try modifiedJSON.data(using: .utf8)?.mapResponse(DataLayer.ThreadListsResponse.self) {
                return modifiedParsed
            } else {
                return parsed
            }
        } else {
            return parsed
        }
    }
    
    public func renameUsers(data: Data) async throws -> DataLayer.CommentsResponse {
        var modifiedJSON = ""
        let parsed = try data.mapResponse(DataLayer.CommentsResponse.self)
        
        if let stringJSON = String(data: data, encoding: .utf8) {
            modifiedJSON = renameUsersInJSON(stringJSON: stringJSON)
            if let modifiedParsed = try modifiedJSON.data(using: .utf8)?.mapResponse(DataLayer.CommentsResponse.self) {
                return modifiedParsed
            } else {
                return parsed
            }
        } else {
            return parsed
        }
    }
    
    public func renameUsersInJSON(stringJSON: String) -> String {
        var modifiedJSON = stringJSON
        let userNames = stringJSON.find(from: "\"users\":{\"", to: "\":{\"profile\":")
        if userNames.count >= 1 {
            for i in 0...userNames.count-1 {
                modifiedJSON = modifiedJSON.replacingOccurrences(of: "\"users\":{\"" + userNames[i],
                                                                 with: "\"users\":{\"" + "userName",
                                                                 options: .literal,
                                                                 range: nil)
            }
            return modifiedJSON
        } else {
            return stringJSON
        }
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
// swiftlint:disable all
public class DiscussionRepositoryMock: DiscussionRepositoryProtocol {
    
    var comments = [
            UserComment(authorName: "Bill",
                        authorAvatar: "",
                        postDate: Date(),
                        postTitle: "Time to test",
                        postBody: "Test the comment right now <a href=\"https://google.com\"> Link to Google</a>",
                        postBodyHtml: "Test the comment right now",
                        postVisible: true,
                        voted: true,
                        followed: true,
                        votesCount: 23,
                        responsesCount: 34,
                        threadID: "",
                        commentID: "",
                        parentID: "",
                        abuseFlagged: false),
            UserComment(authorName: "John",
                        authorAvatar: "",
                        postDate: Date(),
                        postTitle: "Its okay to be an android developer",
                        postBody: "Good article about it <a href=\"https://www.pharmaceuticalonline.com/doc/human-error-deviations-how-you-can-stop-creating-most-of-them-0001\"> Link to Google</a>",
                        postBodyHtml: "Good article about it",
                        postVisible: true,
                        voted: true,
                        followed: true,
                        votesCount: 23,
                        responsesCount: 34,
                        threadID: "",
                        commentID: "",
                        parentID: "",
                        abuseFlagged: false)
        ]
    
    public func getThreads(courseID: String, type: ThreadType, filter: ThreadsFilter, page: Int) async throws -> ThreadLists {
        ThreadLists(
            threads: [
                UserThread(id: "", author: "Peter",
                           authorLabel: "Peter Parker",
                           createdAt: Date(),
                           updatedAt: Date(),
                           rawBody: "Its time to load something",
                           renderedBody: "<b>Its time to load something</b>",
                           voted: true,
                           voteCount: 14,
                           courseID: "",
                           type: .discussion,
                           title: "Thread about nature",
                           pinned: false,
                           closed: false,
                           following: false,
                           commentCount: 12,
                           avatar: "",
                           unreadCommentCount: 4,
                           abuseFlagged: false,
                           hasEndorsed: false,
                           numPages: 1),
                UserThread(id: "", author: "Peter",
                           authorLabel: "Peter Parker",
                           createdAt: Date(),
                           updatedAt: Date(),
                           rawBody: "Its time to load something",
                           renderedBody: "<b>Its time to load something</b>",
                           voted: true,
                           voteCount: 3,
                           courseID: "",
                           type: .question,
                           title: "Exam questions here",
                           pinned: false,
                           closed: false,
                           following: false,
                           commentCount: 5,
                           avatar: "",
                           unreadCommentCount: 1,
                           abuseFlagged: false,
                           hasEndorsed: false,
                           numPages: 12)
            ])
    }
    
    public func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists {
        ThreadLists(
                threads: [
                    UserThread(id: "", author: "Peter",
                            authorLabel: "Peter Parker",
                            createdAt: Date(),
                            updatedAt: Date(),
                            rawBody: "Its time to load something",
                            renderedBody: "<b>Its time to load something</b>",
                            voted: true,
                            voteCount: 14,
                            courseID: "",
                            type: .discussion,
                            title: "Thread about nature",
                            pinned: false,
                            closed: false,
                            following: false,
                            commentCount: 12,
                            avatar: "",
                            unreadCommentCount: 4,
                            abuseFlagged: false,
                            hasEndorsed: false,
                            numPages: 1),
                    UserThread(id: "", author: "Peter",
                            authorLabel: "Peter Parker",
                            createdAt: Date(),
                            updatedAt: Date(),
                            rawBody: "Its time to load something",
                            renderedBody: "<b>Its time to load something</b>",
                            voted: true,
                            voteCount: 3,
                            courseID: "",
                            type: .question,
                            title: "Exam questions here",
                            pinned: false,
                            closed: false,
                            following: false,
                            commentCount: 5,
                            avatar: "",
                            unreadCommentCount: 1,
                            abuseFlagged: false,
                            hasEndorsed: false,
                            numPages: 12)
                ])
    }
    
    public func getTopics(courseID: String) async throws -> Topics {
        Topics(
            coursewareTopics:
                [
                    CoursewareTopics(id: "", name: "CourseWare Topics",
                                     threadListURL: "",
                                     children: [CoursewareTopics(id: "",
                                                                 name: "Child topic",
                                                                 threadListURL: "",
                                                                 children: [])])
                ],
            nonCoursewareTopics:
                [
                    CoursewareTopics(id: "", name: "Non Courseware Topics", threadListURL: "", children: [])
                ]
        )
    }
    
    public func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        (comments, 10)
    }
    
    public func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        (comments, 10)
    }
    
    public func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Int) {
        (comments, 10)
    }
    
    public func addCommentTo(threadID: String, rawBody: String, parentID: String?) async throws  -> Post {
        Post(
            authorName: "John",
            authorAvatar: "",
            postDate: Date(),
            postTitle: "Post title",
            postBodyHtml: "<b>Hello World!</b>",
            postBody: "Hello World!",
            postVisible: true,
            voted: false,
            followed: false,
            votesCount: 2,
            responsesCount: 3,
            comments: [],
            threadID: "threadID",
            commentID: "commentID",
            parentID: nil,
            abuseFlagged: false,
            closed: false
        )
    }
    
    public func voteThread(voted: Bool, threadID: String) async throws {
        
    }
    
    public func voteResponse(voted: Bool, responseID: String) async throws {
        
    }
    
    public func flagThread(abuseFlagged: Bool, threadID: String) async throws {
        
    }
    
    public func flagComment(abuseFlagged: Bool, commentID: String) async throws {
        
    }
    
    public func followThread(following: Bool, threadID: String) async throws {
        
    }
    
    public func createNewThread(newThread: DiscussionNewThread) async throws {
        
    }
    
    public func readBody(threadID: String) async throws {
        
    }
    
    public func renameThreadUser(data: Data) async throws -> DataLayer.ThreadListsResponse {
        DataLayer.ThreadListsResponse(threads: [],
                                           textSearchRewrite: "",
                                      pagination: DataLayer.Pagination(next: "", previous: "", count: 0, numPages: 0) )
    }
    
    public func renameUsers(data: Data) async throws -> DataLayer.CommentsResponse {
        DataLayer.CommentsResponse(
            comments: [
                DataLayer.Comments(id: "", author: "Bill",
                                   authorLabel: nil,
                                   createdAt: "25.11.2043",
                                   updatedAt: "25.11.2043",
                                   rawBody: "Raw Body",
                                   renderedBody: "Rendered body",
                                   abuseFlagged: false,
                                   voted: true,
                                   voteCount: 2,
                                   editableFields: [],
                                   canDelete: true,
                                   threadID: "",
                                   parentID: nil,
                                   endorsed: false,
                                   endorsedBy: nil,
                                   endorsedByLabel: nil,
                                   endorsedAt: nil,
                                   childCount: 0,
                                   children: [],
                                   users: nil)
            ], pagination: DataLayer.Pagination(next: nil, previous: nil, count: 0, numPages: 0))
    }
    
    public func renameUsersInJSON(stringJSON: String) -> String {
        return stringJSON
    }    
}
#endif
