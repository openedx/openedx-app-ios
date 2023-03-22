//
//  DiscussionInteractor.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.10.2022.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DiscussionInteractorProtocol {
    func getThreadsList(courseID: String, type: ThreadType, page: Int) async throws -> ThreadLists
    func getTopics(courseID: String) async throws -> Topics
    func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists
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
}

public class DiscussionInteractor: DiscussionInteractorProtocol {
    
    private let repository: DiscussionRepositoryProtocol
    
    public init(repository: DiscussionRepositoryProtocol) {
        self.repository = repository
    }
    
    public func getThreadsList(courseID: String, type: ThreadType, page: Int) async throws -> ThreadLists {
        return try await repository.getThreads(courseID: courseID, type: type, page: page)
    }
    
    public func searchThreads(courseID: String, searchText: String, pageNumber: Int) async throws -> ThreadLists {
        return try await repository.searchThreads(courseID: courseID, searchText: searchText, pageNumber: pageNumber)
    }
    
    public func getTopics(courseID: String) async throws -> Topics {
        return try await repository.getTopics(courseID: courseID)
    }
    
    public func getDiscussionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        return try await repository.getDiscussionComments(threadID: threadID, page: page)
    }
    
    public func getQuestionComments(threadID: String, page: Int) async throws -> ([UserComment], Int) {
        return try await repository.getQuestionComments(threadID: threadID, page: page)
    }
    
    public func getCommentResponses(commentID: String, page: Int) async throws -> ([UserComment], Int) {
        return try await repository.getCommentResponses(commentID: commentID, page: page)
    }
    
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
