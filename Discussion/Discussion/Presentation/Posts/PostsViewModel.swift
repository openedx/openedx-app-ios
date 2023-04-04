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

public extension ThreadsFilter {
    
    var localizedValue: String {
        switch self {
        case .allThreads:
            return DiscussionLocalization.Posts.Filter.allPosts
        case .unread:
            return DiscussionLocalization.Posts.Filter.unread
        case .unanswered:
            return DiscussionLocalization.Posts.Filter.unanswered
        }
    }
}

public class PostsViewModel: ObservableObject {
    
    public var nextPage = 1
    public var totalPages = 1
    public private(set) var fetchInProgress = false
    
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
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var filteredPosts: [DiscussionPost] = []
    @Published var filterTitle: ThreadsFilter = .allThreads {
        willSet {
            if let courseID {
              resetPosts()
                Task {
                    _ = await getPosts(courseID: courseID, pageNumber: 1)
                }
            }
        }
    }
    @Published var sortTitle: SortType = .recentActivity
    
    @Published var filterButtons: [ActionSheet.Button] = []
    
    public var courseID: String?
    
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
    
    public func resetPosts() {
        filteredPosts = []
        discussionPosts = []
        threads.threads = []
        nextPage = 1
        totalPages = 1
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
                    self.filterTitle = .allThreads
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
    func getPostsPagination(courseID: String, index: Int, withProgress: Bool = true) async {
        print(">>>>>> INDEX", index)
        if !fetchInProgress {
            if totalPages > 1 {
                if index == threads.threads.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            _ = await getPosts(courseID: courseID,
                                               pageNumber: self.nextPage,
                                               withProgress: withProgress)
                        }
                    }
                }
            }
        }
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
                                    filter: filterTitle,
                                    page: pageNumber).threads
                self.totalPages = threads.threads[0].numPages
                self.nextPage += 1
            case .followingPosts:
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .followingPosts,
                                    filter: filterTitle,
                                    page: pageNumber).threads
                self.totalPages = threads.threads[0].numPages
                self.nextPage += 1
            case .nonCourseTopics:
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .nonCourseTopics,
                                    filter: filterTitle,
                                    page: pageNumber).threads
                self.totalPages = threads.threads[0].numPages
                self.nextPage += 1
            case .courseTopics(topicID: let topicID):
                threads.threads += try await interactor
                    .getThreadsList(courseID: courseID,
                                    type: .courseTopics(topicID: topicID),
                                    filter: filterTitle,
                                    page: pageNumber).threads
                self.totalPages = threads.threads[0].numPages
                self.nextPage += 1
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
