//
//  DiscussionInteractor.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.10.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DiscussionInteractorProtocol: Sendable {
    func getCourseDiscussionInfo(courseID: String) async throws -> DiscussionInfo
    func getThreadsList(courseID: String,
                        type: ThreadType,
                        sort: SortType,
                        filter: ThreadsFilter,
                        page: Int) async throws -> ThreadLists
    func getTopics(courseID: String) async throws -> Topics
    func getTopic(courseID: String, topicID: String) async throws -> Topics
    func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists
    func getThread(threadID: String) async throws -> UserThread
    func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Pagination)
    func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Pagination)
    func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Pagination)
    func getResponse(responseID: String) async throws -> UserComment
    func addCommentTo(threadID: String, rawBody: String, parentID: String?) async throws -> Post
    func voteThread(voted: Bool, threadID: String) async throws
    func voteResponse(voted: Bool, responseID: String) async throws
    func flagThread(abuseFlagged: Bool, threadID: String) async throws
    func flagComment(abuseFlagged: Bool, commentID: String) async throws
    func followThread(following: Bool, threadID: String) async throws
    func createNewThread(newThread: DiscussionNewThread) async throws
    func readBody(threadID: String) async throws
}

public actor DiscussionInteractor: DiscussionInteractorProtocol {
    
    private let repository: DiscussionRepositoryProtocol
    
    public init(repository: DiscussionRepositoryProtocol) {
        self.repository = repository
    }

    public func getCourseDiscussionInfo(courseID: String) async throws -> DiscussionInfo {
        try await repository.getCourseDiscussionInfo(courseID: courseID)
    }

    public func getThreadsList(courseID: String,
                               type: ThreadType,
                               sort: SortType,
                               filter: ThreadsFilter,
                               page: Int) async throws -> ThreadLists {
        return try await repository.getThreads(courseID: courseID, type: type, sort: sort, filter: filter, page: page)
    }

    public func getThread(threadID: String) async throws -> UserThread {
        return try await repository.getThread(threadID: threadID)
    }

    public func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists {
        return try await repository.searchThreads(courseID: courseID, searchText: searchText, pageNumber: pageNumber)
    }
    
    public func getTopics(courseID: String) async throws -> Topics {
        return try await repository.getTopics(courseID: courseID)
    }

    public func getTopic(courseID: String, topicID: String) async throws -> Topics {
        return try await repository.getTopic(courseID: courseID, topicID: topicID)
    }

    public func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Pagination) {
        return try await repository.getDiscussionComments(threadID: threadID, page: page)
    }
    
    public func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Pagination) {
        return try await repository.getQuestionComments(threadID: threadID, page: page)
    }
    
    public func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Pagination) {
        return try await repository.getCommentResponses(commentID: commentID, page: page)
    }

    //swiftlint:disable todo
    // TODO: This Api should be updated with type GET, currently we are using this for deep linking on comment screen.
    public func getResponse(responseID: String) async throws -> UserComment {
        return try await repository.getResponse(responseID: responseID)
    }
    //swiftlint:enable todo

    public func addCommentTo(threadID: String, rawBody: String, parentID: String? = nil) async throws -> Post {
        return try await repository.addCommentTo(threadID: threadID,
                                                 rawBody: rawBody,
                                                 parentID: parentID)
    }
    
    public func voteThread(voted: Bool, threadID: String) async throws {
        return try await repository.voteThread(voted: voted, threadID: threadID)
    }
    
    public func voteResponse(voted: Bool, responseID: String) async throws {
        return try await repository.voteResponse(voted: voted, responseID: responseID)
    }
    
    public func flagThread(abuseFlagged: Bool, threadID: String) async throws {
        return try await repository.flagThread(abuseFlagged: abuseFlagged,
                                               threadID: threadID)
    }
    
    public func flagComment(abuseFlagged: Bool, commentID: String) async throws {
        return try await repository.flagComment(abuseFlagged: abuseFlagged,
                                                commentID: commentID)
    }
    
    public func followThread(following: Bool, threadID: String) async throws {
        return try await repository.followThread(following: following,
                                                 threadID: threadID)
    }
    
    public func createNewThread(newThread: DiscussionNewThread) async throws {
        return try await repository.createNewThread(newThread: newThread)
    }
    
    public func readBody(threadID: String) async throws {
        return try await repository.readBody(threadID: threadID)
    }
    
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension DiscussionInteractor {
    static let mock: DiscussionInteractor = DiscussionInteractor(repository: DiscussionRepositoryMock())
}
#endif
