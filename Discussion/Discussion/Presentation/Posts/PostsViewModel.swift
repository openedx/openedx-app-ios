//
//  PostsViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Combine
import Core

public class PostsViewModel: ObservableObject {
    
    public enum ButtonType {
        case sort
        case filter
    }
    
    public enum SortType {
        case recentActivity
        case mostActivity
        case mostVotes
        
        var localizedValue: String {
            switch self {
            case .recentActivity:
                return DiscussionLocalization.Posts.Sort.recentActivity
            case .mostActivity:
                return DiscussionLocalization.Posts.Sort.mostActivity
            case .mostVotes:
                return DiscussionLocalization.Posts.Sort.mostVotes
            }
        }
    }
    
    public enum FilterType {
        case allPosts
        case unread
        case unanswered
        
        var localizedValue: String {
            switch self {
            case .allPosts:
                return DiscussionLocalization.Posts.Filter.allPosts
            case .unread:
                return DiscussionLocalization.Posts.Filter.unread
            case .unanswered:
                return DiscussionLocalization.Posts.Filter.unanswered
            }
        }
    }
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var filteredPosts: [DiscussionPost] = []
    @Published var filterTitle: FilterType = .allPosts
    @Published var sortTitle: SortType = .recentActivity
    
    @Published var filterButtons: [ActionSheet.Button] = []
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public var type: ThreadType!
    public var topics: Topics?
    private var topicsFetched: Bool = false
    
    private var discussionPosts: [DiscussionPost] = []
    private var threads: ThreadLists = ThreadLists(threads: [])
    
    private let interactor: DiscussionInteractorProtocol
    private let router: DiscussionRouter
    private let config: Config
    
    internal let postStateSubject = CurrentValueSubject<PostState?, Never>(nil)
    private var cancellable: AnyCancellable?
    
    public init(interactor: DiscussionInteractorProtocol,
                router: DiscussionRouter,
                config: Config) {
        self.interactor = interactor
        self.router = router
        self.config = config
        
        cancellable = postStateSubject
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] state in
                guard let self, let state else { return }
                switch state {
                case let .followed(id, followed):
                    self.updatePostFollowedState(id: id, followed: followed)
                case let .replyAdded(id):
                    self.updatePostRepliesCountState(id: id)
                case let .readed(id):
                    self.updateUnreadCommentsCount(id: id)
                }
            })
    }
    
    public func generateButtons(type: ButtonType) {
        switch type {
        case .sort:
            self.filterButtons = [
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Sort.recentActivity)) {
                    self.sortTitle = .recentActivity
                    self.sortPosts()
                },
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Sort.mostActivity)) {
                    self.sortTitle = .mostActivity
                    self.sortPosts()
                },
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Sort.mostVotes)) {
                    self.sortTitle = .mostVotes
                    self.sortPosts()
                },
                .cancel()
            ]
        case .filter:
            self.filterButtons = [
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Filter.allPosts)) {
                    self.filterTitle = .allPosts
                    self.sortPosts()
                },
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Filter.unread)) {
                    self.filterTitle = .unread
                    self.sortPosts()
                },
                ActionSheet.Button.default(Text(DiscussionLocalization.Posts.Filter.unanswered)) {
                    self.filterTitle = .unanswered
                    self.sortPosts()
                },
                .cancel()
            ]
        }
    }
    
    func generatePosts(threads: ThreadLists?) -> [DiscussionPost] {
        var result: [DiscussionPost] = []
        if let threads = threads?.threads {
            for thread in threads {
                result.append(thread.discussionPost(action: { [weak self] in
                    guard let self else { return }
                    self.router.showThread(thread: thread, postStateSubject: self.postStateSubject)
                }))
            }
        }
        
        return result
    }
    
    @MainActor
    func getPostsPagination(courseID: String, withProgress: Bool = true) async -> Bool {
        self.threads.threads = []
        guard await getPosts(courseID: courseID, pageNumber: 1, withProgress: withProgress) else { return false }
        if !threads.threads.isEmpty {
            if threads.threads[0].numPages > 1 {
                for i in 2...threads.threads[0].numPages {
                    guard await getPosts(courseID: courseID, pageNumber: i, withProgress: withProgress) else { return false }
                }
            }
        }
        
        return true
    }
    
    @MainActor
    public func getPosts(courseID: String, pageNumber: Int, withProgress: Bool = true) async -> Bool {
        isShowProgress = withProgress
        do {
            switch type {
            case .allPosts:
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .allPosts,
                                    page: pageNumber).threads
            case .followingPosts:
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .followingPosts,
                                    page: pageNumber).threads
            case .nonCourseTopics:
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .nonCourseTopics,
                                    page: pageNumber).threads
            case .courseTopics(topicID: let topicID):
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .courseTopics(topicID: topicID),
                                    page: pageNumber).threads
            case .none:
                isShowProgress = false
                return false
            }
            discussionPosts = generatePosts(threads: threads)
            filteredPosts = discussionPosts
            self.sortPosts()
            isShowProgress = false
            return true
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
    
    private func sortPosts() {
        self.filteredPosts = self.discussionPosts
        switch filterTitle {
        case .allPosts:
            break
        case .unread:
            self.filteredPosts = self.filteredPosts.filter({ $0.unreadCommentCount > 0 })
        case .unanswered:
            self.filteredPosts = self.filteredPosts.filter({ $0.type == .question && !$0.hasEndorsed })
        }
        switch sortTitle {
        case .recentActivity:
            self.filteredPosts = self.filteredPosts.sorted(by: { $0.lastPostDate > $1.lastPostDate })
        case .mostActivity:
            self.filteredPosts = self.filteredPosts.sorted(by: { $0.replies > $1.replies })
        case .mostVotes:
            self.filteredPosts = self.filteredPosts.sorted(by: { $0.voteCount > $1.voteCount })
        }
    }
    
    private func updateUnreadCommentsCount(id: String) {
        var threads = threads.threads
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.unreadCommentCount = 0
        threads[index] = thread
        
        self.threads = ThreadLists(threads: threads)
        discussionPosts = generatePosts(threads: self.threads)
        sortPosts()
    }
    
    private func updatePostFollowedState(id: String, followed: Bool) {
        var threads = threads.threads
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.following = followed
        threads[index] = thread
        
        self.threads = ThreadLists(threads: threads)
        discussionPosts = generatePosts(threads: self.threads)
        sortPosts()
    }
    
    private func updatePostRepliesCountState(id: String) {
        var threads = threads.threads
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.commentCount += 1
        thread.updatedAt = Date()
        threads[index] = thread
        
        self.threads = ThreadLists(threads: threads)
        discussionPosts = generatePosts(threads: self.threads)
        sortPosts()
    }
}
