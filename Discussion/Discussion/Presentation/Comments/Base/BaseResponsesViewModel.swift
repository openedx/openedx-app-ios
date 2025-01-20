//
//  BaseResponsesViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import SwiftUI
import Core
import Combine
import Swinject

@MainActor
public class BaseResponsesViewModel {
    
    @Published public var postComments: Post?
    @Published public var isShowProgress = false
    @Published public var showError = false
    @Published public var showAlert = false
    @Published public var addCommentsIsVisible = true
    internal var comments: [UserComment] = []
    
    public var nextPage = 2
    public var totalPages = 1
    @Published public var itemsCount = 0
    public var fetchInProgress = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    
    internal let interactor: DiscussionInteractorProtocol
    internal let router: DiscussionRouter
    internal let config: ConfigProtocol
    internal let storage: CoreStorage
    internal let addPostSubject = CurrentValueSubject<Post?, Never>(nil)
    private let analytics: DiscussionAnalytics?
    
    init(
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        config: ConfigProtocol,
        storage: CoreStorage,
        analytics: DiscussionAnalytics?
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
        self.storage = storage
        self.analytics = analytics
    }
    
    @MainActor
    public func vote(
        id: String,
        isThread: Bool,
        voted: Bool,
        index: Int?,
        courseID: String,
        responseID: String? = nil,
        isComment: Bool = false
    ) async -> Bool {
        if let index {
            toggleLike(index: index)
        } else {
            toggleLikeOnParrent()
        }
        do {
            if isThread {
                try await interactor.voteThread(voted: voted, threadID: id)
                trackThreadToggleLike(courseID: courseID)
            } else {
                try await interactor.voteResponse(voted: voted, responseID: id)
                if let index {
                    trackResponseCommentToggleLike(
                        courseID: courseID,
                        post: postComments?.comments[index],
                        responseID: responseID,
                        isComment: isComment
                    )
                }
            }
            return true
        } catch let error {
            if let index {
                toggleLike(index: index)
            } else {
                toggleLikeOnParrent()
            }
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
    
    @MainActor
    public func flag(
        id: String,
        isThread: Bool,
        abuseFlagged: Bool,
        index: Int?,
        courseID: String,
        responseID: String? = nil,
        isComment: Bool = false
    ) async -> Bool {
        if let index {
            postComments?.comments[index].abuseFlagged.toggle()
        } else {
            postComments?.abuseFlagged.toggle()
        }
        do {
            if isThread {
                try await interactor.flagThread(abuseFlagged: abuseFlagged, threadID: id)
                trackThreadToggleReport(courseID: courseID)
            } else {
                try await interactor.flagComment(abuseFlagged: abuseFlagged, commentID: id)
                if let index {
                    trackResponseToggleReport(
                        courseID: courseID,
                        post: postComments?.comments[index],
                        responseID: responseID,
                        isComment: isComment
                    )
                }
            }
            
            return true
        } catch let error {
            if let index {
                postComments?.comments[index].abuseFlagged.toggle()
            } else {
                postComments?.abuseFlagged.toggle()
            }
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
    
    @MainActor
    public func followThread(following: Bool, threadID: String) async -> Bool {
        postComments?.followed.toggle()
        do {
            try await interactor.followThread(following: following, threadID: threadID)
            return true
        } catch let error {
            postComments?.followed.toggle()
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
    
    func addNewPost(_ post: Post) {
        postComments?.comments.append(post)
        itemsCount += 1
    }
    
    private func toggleLikeOnParrent() {
        postComments?.voted.toggle()
        if let voted = postComments?.voted {
            if voted {
                postComments?.votesCount += 1
            } else {
                postComments?.votesCount -= 1
            }
        }
    }
    
    private func toggleLike(index: Int) {
        postComments?.comments[index].voted.toggle()
        if let voted = postComments?.comments[index].voted {
            if voted {
                postComments?.comments[index].votesCount += 1
            } else {
                postComments?.comments[index].votesCount -= 1
            }
        }
    }
    
    func trackToggleFollowThread(
        courseID: String,
        threadID: String,
        author: String,
        follow: Bool
    ) {
        analytics?.discussionFollowToggle(
            courseID: courseID,
            threadID: threadID,
            author: author,
            follow: follow
        )
    }
    
    func trackThreadToggleLike(
        courseID: String
    ) {
        guard let postComments else {
            return
        }
        
        analytics?.discussionLikeToggle(
            courseID: courseID,
            threadID: postComments.threadID,
            responseID: nil,
            commentID: nil,
            author: postComments.authorName,
            discussionType: "thread",
            like: postComments.voted
        )
    }
    
    func trackThreadToggleReport(
        courseID: String
    ) {
        guard let postComments else { return }
        
        analytics?.discussionReportToggle(
            courseID: courseID,
            threadID: postComments.threadID,
            responseID: nil,
            commentID: nil,
            author: postComments.authorName,
            discussionType: "thread",
            report: postComments.abuseFlagged
        )
    }
    
    func trackResponseToggleReport(
        courseID: String,
        post: Post?,
        responseID: String? = nil,
        isComment: Bool
    ) {
        guard let post else { return }
        
        analytics?.discussionReportToggle(
            courseID: courseID,
            threadID: post.threadID,
            responseID: isComment ? responseID : post.commentID,
            commentID: isComment ? post.commentID : nil,
            author: post.authorName,
            discussionType: isComment ? "comment" : "response",
            report: post.abuseFlagged
        )
    }
    
    func trackResponseCommentToggleLike(
        courseID: String,
        post: Post?,
        responseID: String? = nil,
        isComment: Bool
    ) {
        guard let post else { return }
        
        analytics?.discussionLikeToggle(
            courseID: courseID,
            threadID: post.threadID,
            responseID: isComment ? responseID : post.commentID,
            commentID: isComment ? post.commentID : nil,
            author: post.authorName,
            discussionType: isComment ? "comment" : "response",
            like: post.voted
        )
    }
}
