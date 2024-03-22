//
//  DiscussionSearchTopicsViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 21.02.2023.
//

import Foundation
import SwiftUI
import Core
import Combine

public class DiscussionSearchTopicsViewModel<S: Scheduler>: ObservableObject {
    
    @Published private(set) var fetchInProgress = false
    @Published var isSearchActive = false
    @Published var searchResults: [DiscussionPost] = []
    @Published var showError: Bool = false
    @Published var searchText: String = ""
    
    private var prevQuery: String = ""
    private var courseID: String
    private var subscription = Set<AnyCancellable>()
    @Published private var threads: [UserThread] = []
    
    private var nextPage = 1
    private var totalPages = 1
    
    internal let postStateSubject = CurrentValueSubject<PostState?, Never>(nil)
    private var cancellable: AnyCancellable?
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscussionRouter
    private let interactor: DiscussionInteractorProtocol
    private let debounce: Debounce<S>
    
    public init(
        courseID: String,
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        debounce: Debounce<S>
    ) {
        self.courseID = courseID
        self.interactor = interactor
        self.router = router
        self.debounce = debounce

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
                case let .liked(id, voted, voteCount):
                    self.updatePostLikedState(id: id, voted: voted, voteCount: voteCount)
                case let .reported(id, reported):
                    self.updatePostReportedState(id: id, reported: reported)
                }
            })
        
        $searchText
            .debounce(for: debounce.dueTime, scheduler: debounce.scheduler)
            .removeDuplicates()
            .sink { str in
                let term = str
                    .trimmingCharacters(in: .whitespaces)
                Task.detached(priority: .high) {
                    if !term.isEmpty {
                        if term == self.prevQuery {
                            return
                        }
                        self.nextPage = 1
                        await self.search(page: self.nextPage, searchTerm: str)
                    } else {
                        await MainActor.run {
                            self.prevQuery = ""
                            self.searchResults.removeAll()
                        }
                    }
                }
            }
            .store(in: &subscription)
    }
    
    @MainActor
    func searchCourses(index: Int, searchTerm: String) async {
        if !fetchInProgress {
            if totalPages > 1 {
                if index == searchResults.count - 3 {
                    if totalPages != 1 {
                        if nextPage <= totalPages {
                            await search(page: self.nextPage, searchTerm: searchTerm)
                        }
                    }
                }
            }
        }
    }
    
    @MainActor
    private func search(page: Int, searchTerm: String) async {
        self.prevQuery = searchTerm
        fetchInProgress = true
        
        do {
            if !searchTerm.trimmingCharacters(in: .whitespaces).isEmpty {
                let results = try await interactor.searchThreads(
                    courseID: courseID,
                    searchText: searchTerm,
                    pageNumber: page
                ).threads
                
                if results.isEmpty {
                    searchResults.removeAll()
                    threads = []
                    fetchInProgress = false
                    return
                }
                
                if page == 1 {
                    threads = results
                } else {
                    threads += results
                }
                
                searchResults = generatePosts(threads: threads)
                
                if !searchResults.isEmpty {
                    self.nextPage += 1
                    totalPages = results[0].numPages
                }
            }
            
            fetchInProgress = false
        } catch let error {
            fetchInProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    private func generatePosts(threads: [UserThread]) -> [DiscussionPost] {
        var result: [DiscussionPost] = []
        for thread in threads {
            result.append(thread.discussionPost(action: { [weak self] in
                guard let self else { return }
                self.router.showThread(
                    thread: thread,
                    postStateSubject: self.postStateSubject,
                    animated: true
                )
            }))
        }
        return result
    }
    
    private func updateUnreadCommentsCount(id: String) {
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.unreadCommentCount = 0
        threads[index] = thread
        searchResults = generatePosts(threads: threads)
    }
    
    private func updatePostFollowedState(id: String, followed: Bool) {
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.following = followed
        threads[index] = thread
        searchResults = generatePosts(threads: threads)
    }
    
    private func updatePostRepliesCountState(id: String) {
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.commentCount += 1
        thread.updatedAt = Date()
        threads[index] = thread
        searchResults = generatePosts(threads: threads)
    }
    
    private func updatePostLikedState(id: String, voted: Bool, voteCount: Int) {
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.voted = voted
        thread.voteCount = voteCount
        threads[index] = thread
        searchResults = generatePosts(threads: threads)
    }
    
    private func updatePostReportedState(id: String, reported: Bool) {
        guard let index = threads.firstIndex(where: { $0.id == id }) else { return }
        var thread = threads[index]
        thread.abuseFlagged = reported
        threads[index] = thread
        searchResults = generatePosts(threads: threads)
    }
}
