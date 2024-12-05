//
//  ThreadViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 18.10.2022.
//

import Foundation
import Combine
import Core

public final class ThreadViewModel: BaseResponsesViewModel, ObservableObject {
    
    @Published var scrollTrigger: Bool = false
    
    internal let threadStateSubject = CurrentValueSubject<ThreadPostState?, Never>(nil)
    private var cancellable: AnyCancellable?
    private let postStateSubject: CurrentValueSubject<PostState?, Never>
    public var isBlackedOut: Bool = false

    public init(
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        config: ConfigProtocol,
        storage: CoreStorage,
        postStateSubject: CurrentValueSubject<PostState?, Never>
    ) {
        self.postStateSubject = postStateSubject
        super.init(interactor: interactor, router: router, config: config, storage: storage)
        
        cancellable = threadStateSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                guard let self, let state else { return }
                switch state {
                case let .voted(id, voted, votesCount):
                    self.updateThreadLikeState(id: id, voted: voted, votesCount: votesCount)
                case let .flagged(id, flagged):
                    self.updateThreadReportState(id: id, flagged: flagged)
                case let .postAdded(id):
                    self.updateThreadPostsCountState(id: id)
                    self.sendPostRepliesCountState()
                }
            })
    }
    
    func generateComments(comments: [UserComment], thread: UserThread) -> Post {
        var result = Post(
            authorName: thread.author,
            authorAvatar: thread.avatar,
            postDate: thread.createdAt,
            postTitle: thread.title,
            postBodyHtml: thread.renderedBody,
            postBody: thread.rawBody,
            postVisible: true,
            voted: thread.voted,
            followed: thread.following,
            votesCount: thread.voteCount,
            responsesCount: comments.last?.responsesCount ?? 0,
            comments: [],
            threadID: thread.id,
            commentID: thread.courseID,
            parentID: nil,
            abuseFlagged: thread.abuseFlagged,
            closed: thread.closed
        )
        result.comments = comments.map { c in
            Post(
                authorName: c.authorName,
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
                closed: thread.closed
            )
        }
        return result
    }
    
    @MainActor
    public func postComment(threadID: String, rawBody: String, parentID: String?) async {
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
    public func fetchMorePosts(thread: UserThread, index: Int) async -> Bool {
        if totalPages > 1 {
            if index == comments.count - 3 {
                if totalPages != 1 {
                    if nextPage != totalPages+1 {
                        if await self.getThreadData(thread: thread, page: nextPage) {
                            self.nextPage += 1
                            return true
                        }
                    }
                }
            }
        }
        return false
    }
    
    @MainActor
    public func getThreadData(thread: UserThread, page: Int, refresh: Bool = false) async -> Bool {
        guard !fetchInProgress else { return false }
        fetchInProgress = true
        do {
            try await interactor.readBody(threadID: thread.id)
            switch thread.type {
            case .question:
                let (comments, pagination) = try await interactor
                    .getQuestionComments(threadID: thread.id, page: page)
                self.totalPages = pagination.numPages
                self.itemsCount = pagination.count
                var threadPost = thread
                if page == 1 {
                    self.comments = comments
                    if refresh {
                        threadPost = await getThreadPost(thread: thread)
                    }
                } else {
                    self.comments += comments
                }
                postComments = generateComments(comments: self.comments, thread: threadPost)
            case .discussion:
                let (comments, pagination) = try await interactor
                    .getDiscussionComments(threadID: thread.id, page: page)
                self.totalPages = pagination.numPages
                self.itemsCount = pagination.count
                var threadPost = thread
                if page == 1 {
                    self.comments = comments
                    if refresh {
                        threadPost = await getThreadPost(thread: thread)
                    }
                } else {
                    self.comments += comments
                }
                postComments = generateComments(comments: self.comments, thread: threadPost)
            }
            fetchInProgress = false
            return true
        } catch let error {
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            fetchInProgress = false
            return false
        }
    }
    
    func getThreadPost(thread: UserThread) async -> UserThread {
        do {
            var threadPost = try await interactor.getThread(threadID: thread.id)
            threadPost.avatar = thread.avatar
            return threadPost
        } catch {
            return thread
        }
    }

    func sendPostFollowedState() {
        if let postComments {
            postStateSubject.send(.followed(id: postComments.threadID, postComments.followed))
        }
    }
    
    func sendUpdateUnreadState() {
        if let postComments {
            postStateSubject.send(.readed(id: postComments.threadID))
        }
    }
    
    func sendPostRepliesCountState() {
        if let postComments {
            postStateSubject.send(.replyAdded(id: postComments.threadID))
        }
    }
    
    func sendReportedState() {
        if let postComments {
            postStateSubject.send(.reported(id: postComments.threadID, postComments.abuseFlagged))
        }
    }
    
    func sendPostLikedState() {
        if let postComments {
            postStateSubject.send(.liked(id: postComments.threadID, postComments.voted, postComments.votesCount) )
        }
    }
    
    private func updateThreadLikeState(id: String, voted: Bool, votesCount: Int) {
        guard var comments = postComments else { return }
        guard let index = comments.comments.firstIndex(where: { $0.commentID == id }) else { return }
        var comment = comments.comments[index]
        comment.voted = voted
        comment.votesCount = votesCount
        comments.comments[index] = comment
        postComments = comments
    }
    
    private func updateThreadReportState(id: String, flagged: Bool) {
        guard var comments = postComments else { return }
        guard let index = comments.comments.firstIndex(where: { $0.commentID == id }) else { return }
        var comment = comments.comments[index]
        comment.abuseFlagged = flagged
        comments.comments[index] = comment
        postComments = comments
    }
    
    private func updateThreadPostsCountState(id: String) {
        guard var comments = postComments else { return }
        guard let index = comments.comments.firstIndex(where: { $0.commentID == id }) else { return }
        var comment = comments.comments[index]
        comment.responsesCount += 1
        comments.comments[index] = comment
        postComments = comments
    }
}
