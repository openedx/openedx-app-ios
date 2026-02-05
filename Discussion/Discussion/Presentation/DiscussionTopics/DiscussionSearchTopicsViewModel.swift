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

@MainActor
@Observable
public final class DiscussionSearchTopicsViewModel {

    private(set) var fetchInProgress = false
    var isSearchActive = false
    var searchResults: [DiscussionPost] = []
    var showError: Bool = false
    var searchText: String = "" {
        didSet {
            handleSearchTextChange(searchText)
        }
    }

    private var prevQuery: String = ""
    private var courseID: String
    private var threads: [UserThread] = []

    private var nextPage = 1
    private var totalPages = 1

    nonisolated(unsafe) private var searchTask: Task<Void, Never>?
    nonisolated(unsafe) private var observationTask: Task<Void, Never>?
    // Keep CurrentValueSubject for now since it's passed to router
    @ObservationIgnored internal let postStateSubject = CurrentValueSubject<PostState?, Never>(nil)
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscussionRouter
    private let interactor: DiscussionInteractorProtocol
    private let storage: CoreStorage
    private let debounceInterval: TimeInterval

    public init(
        courseID: String,
        interactor: DiscussionInteractorProtocol,
        storage: CoreStorage,
        router: DiscussionRouter,
        debounceInterval: TimeInterval = 0.8
    ) {
        self.courseID = courseID
        self.interactor = interactor
        self.storage = storage
        self.router = router
        self.debounceInterval = debounceInterval

        // Setup observer for postStateSubject
        observationTask = Task {
            for await state in postStateSubject.values {
                guard let state = state else { continue }
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
            }
        }
    }

    deinit {
        searchTask?.cancel()
        observationTask?.cancel()
    }

    private func handleSearchTextChange(_ text: String) {
        // Cancel previous search task
        searchTask?.cancel()

        // Start new debounced search
        searchTask = Task {
            try? await Task.sleep(nanoseconds: UInt64(debounceInterval * 1_000_000_000))

            guard !Task.isCancelled else { return }

            let term = text.trimmingCharacters(in: .whitespaces)

            if !term.isEmpty {
                if term == prevQuery {
                    return
                }
                nextPage = 1
                await search(page: nextPage, searchTerm: text)
            } else {
                prevQuery = ""
                searchResults.removeAll()
            }
        }
    }
    
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
            result
                .append(
                    thread.discussionPost(
                        useRelativeDates: storage.useRelativeDates,
                        action: { [weak self] in
                            guard let self else { return }
                            self.router.showThread(
                                thread: thread,
                                postStateSubject: self.postStateSubject,
                                isBlackedOut: false,
                                animated: true
                            )
                        })
                )
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
