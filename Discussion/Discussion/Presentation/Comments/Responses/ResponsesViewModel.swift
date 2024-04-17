//
//  ResponsesViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import SwiftUI
import Core
import Combine

public class ResponsesViewModel: BaseResponsesViewModel, ObservableObject {
    
    @Published var scrollTrigger: Bool = false
    private let threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
    public var isBlackedOut: Bool = false

    public init(
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        config: ConfigProtocol,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
    ) {
        self.threadStateSubject = threadStateSubject
        super.init(interactor: interactor, router: router, config: config)
    }

    func generateCommentsResponses(comments: [UserComment], parentComment: Post) -> Post? {
        var result = parentComment
        
        result.comments = comments.map { c in
            Post(authorName: c.authorName,
                 authorAvatar: c.authorAvatar,
                 postDate: c.postDate,
                 postTitle: c.postTitle,
                 postBodyHtml: c.postBodyHtml,
                 postBody: c.postBody,
                 postVisible: c.postVisible,
                 voted: c.voted,
                 followed: c.followed,
                 votesCount: c.votesCount,
                 responsesCount: c.responsesCount,
                 comments: [],
                 threadID: c.threadID,
                 commentID: c.commentID,
                 parentID: c.parentID,
                 abuseFlagged: c.abuseFlagged,
                 closed: parentComment.closed)
        }
        return result
    }
    
    @MainActor
    func postComment(threadID: String, rawBody: String, parentID: String?) async {
        isShowProgress = true
        do {
            let newComment = try await interactor.addCommentTo(threadID: threadID,
                                                               rawBody: rawBody,
                                                               parentID: parentID)
            isShowProgress = false
            addPostSubject.send(newComment)
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    @MainActor
    func fetchMorePosts(commentID: String, parentComment: Post, index: Int) async {
        if totalPages > 1 {
            if index == comments.count - 3 {
                if totalPages != 1 {
                    if nextPage != totalPages + 1 {
                        if await self.getComments(commentID: commentID,
                                                  parentComment: parentComment,
                                                  page: nextPage) {
                            self.nextPage += 1
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    func getComments(commentID: String, parentComment: Post, page: Int) async -> Bool {
        guard !fetchInProgress else { return false }
        do {
            let (comments, pagination) = try await interactor
                .getCommentResponses(commentID: commentID, page: page)
            self.totalPages = pagination.numPages
            self.itemsCount = pagination.count
            if page == 1 {
                self.comments = comments
            } else {
                self.comments += comments
            }
            postComments = generateCommentsResponses(comments: self.comments, parentComment: parentComment)
            return true
        } catch let error {
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
    
    func sendThreadLikeState() {
        if let postComments {
            threadStateSubject.send(.voted(
                id: postComments.commentID,
                voted: postComments.voted,
                votesCount: postComments.votesCount)
            )
        }
    }
    
    func sendThreadReportState() {
        if let postComments {
            threadStateSubject.send(.flagged(
                id: postComments.commentID,
                flagged: postComments.abuseFlagged)
            )
        }
    }
    
    func sendThreadPostsCountState() {
        if let postComments {
            threadStateSubject.send(.postAdded(id: postComments.commentID))
        }
    }
}
