//
//  SearchViewModel.swift
//  Discovery
//
//  Created by Paul Maul on 10.02.2023.
//

import Foundation
import Core
import SwiftUI
import Combine

@MainActor
@Observable public final class SearchViewModel<S: Scheduler> {
    var nextPage = 1
    var totalPages = 1

    private(set) var fetchInProgress = false
    var isSearchActive = false
    var animated: Bool = false
    var searchResults: [CourseItem] = []
    var showError: Bool = false

    var searchText: String = "" {
          didSet {
              handleSearchTextChange(oldValue: oldValue, newValue: searchText)
          }
      }

    private var prevQuery: String = ""
    private var subscription = Set<AnyCancellable>()
    private let debounce: Debounce<S>

    @ObservationIgnored private var searchTask: Task<Void, Never>?

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: DiscoveryRouter
    let analytics: DiscoveryAnalytics
    let storage: CoreStorage
    private let interactor: DiscoveryInteractorProtocol
    let connectivity: ConnectivityProtocol
    
    public init(interactor: DiscoveryInteractorProtocol,
                connectivity: ConnectivityProtocol,
                router: DiscoveryRouter,
                analytics: DiscoveryAnalytics,
                storage: CoreStorage,
                debounce: Debounce<S>
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.router = router
        self.analytics = analytics
        self.storage = storage
        self.debounce = debounce
    }

    private func handleSearchTextChange(oldValue: String, newValue: String) {
        searchTask?.cancel()

        searchTask = Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(500))

            guard !Task.isCancelled else { return }

            let term = newValue.trimmingCharacters(in: .whitespaces)

            if !term.isEmpty {
                if term == prevQuery { return }

                nextPage = 1

                await search(page: nextPage, searchTerm: newValue)
            } else {
                prevQuery = ""
                searchResults.removeAll()
            }
        }
    }

    @MainActor
    public func searchCourses(index: Int, searchTerm: String) async {
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
                var results: [CourseItem] = []
                await results = try interactor.search(page: page, searchTerm: searchTerm)
                
                if results.isEmpty {
                    searchResults.removeAll()
                    fetchInProgress = false
                    return
                }
                
                if page == 1 {
                    searchResults = results
                } else {
                    searchResults += results
                }
                
                if !searchResults.isEmpty {
                    self.nextPage += 1
                    totalPages = results[0].numPages
                }
                
                analytics.discoveryCoursesSearch(label: searchTerm,
                                                 coursesCount: searchResults.first?.coursesCount ?? 0)
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
}
