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
public final class SearchViewModel<S: Scheduler>: ObservableObject {
    var nextPage = 1
    var totalPages = 1
    @Published private(set) var fetchInProgress = false
    @Published var isSearchActive = false
    @Published var searchResults: [CourseItem] = []
    @Published var showError: Bool = false
    @Published var searchText: String = ""
    private var prevQuery: String = ""
    private var subscription = Set<AnyCancellable>()
    private let debounce: Debounce<S>
    
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
        
        $searchText
            .debounce(for: debounce.dueTime, scheduler: debounce.scheduler)
            .removeDuplicates()
            .sink { str in
                let term = str
                    .trimmingCharacters(in: .whitespaces)
                Task.detached(priority: .high) {
                    if !term.isEmpty {
                        if await term == self.prevQuery { return }
                        await MainActor.run {
                            self.nextPage = 1
                        }
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
