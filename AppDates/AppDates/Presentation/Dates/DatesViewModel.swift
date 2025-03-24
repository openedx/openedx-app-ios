//
//  DatesViewModel.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Combine
import Core
import SwiftUI

@MainActor
public final class DatesViewModel: ObservableObject {
    
    @Published public var coursesDates: [DateGroup] = []
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published private(set) var isLoadingNextPage = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    // Pagination properties
    private var currentPage = 1
    private var hasNextPage = false
    private var allDates: [CourseDate] = []
    
    let connectivity: ConnectivityProtocol
    private let interactor: DatesViewInteractorProtocol
    private let courseManager: CourseStructureManagerProtocol
    private let router: AppDatesRouter
    
    public init(
        interactor: DatesViewInteractorProtocol,
        connectivity: ConnectivityProtocol,
        courseManager: CourseStructureManagerProtocol,
        router: AppDatesRouter
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.courseManager = courseManager
        self.router = router
    }
    
    public func loadDates(isRefresh: Bool = false) async {
        isShowProgress = !isRefresh
        
        if isRefresh {
            currentPage = 1
            allDates = []
        }
        
        do {
            if connectivity.isInternetAvaliable {
                let (dates, nextPage) = try await interactor.getCourseDates(page: currentPage)
                allDates = dates
                hasNextPage = nextPage != nil
            } else {
                let dates = try await interactor.getCourseDatesOffline()
                allDates = dates
            }
            
            self.isShowProgress = false
            self.processDates(allDates)
        } catch {
            self.isShowProgress = false
            self.errorMessage = error.localizedDescription
        }
    }
    
    public func loadNextPageIfNeeded() async {
        guard connectivity.isInternetAvaliable && hasNextPage && !isLoadingNextPage else { return }
        
        isLoadingNextPage = true
        
        do {
            currentPage += 1
            
            let (newDates, nextPage) = try await interactor.getCourseDates(page: currentPage)
            allDates.append(contentsOf: newDates)
            hasNextPage = nextPage != nil
            processDates(allDates)
            isLoadingNextPage = false
        } catch {
            isLoadingNextPage = false
            errorMessage = error.localizedDescription
        }
    }
    
    func openVertical(date: CourseDate) async {
        guard let courseId = date.courseId else { return }

        router
            .showCourseScreens(
                courseID: courseId,
                hasAccess: date.hasAccess,
                courseStart: Date(),
                courseEnd: Date(),
                enrollmentStart: nil,
                enrollmentEnd: nil,
                title: date.courseName,
                courseRawImage: nil,
                showDates: false,
                lastVisitedBlockID: date.blockId
            )
    }
    
    private func processDates(_ dates: [CourseDate]) {
        let now = Date()
        let calendar = Calendar.current
        
        // Group dates by type
        var pastDue: [CourseDate] = []
        var today: [CourseDate] = []
        var thisWeek: [CourseDate] = []
        var nextWeek: [CourseDate] = []
        var upcoming: [CourseDate] = []
        
        for date in dates {
            if date.date < now {
                pastDue.append(date)
            } else if calendar.isDateInToday(date.date) {
                today.append(date)
            } else if calendar.isDate(date.date, equalTo: now, toGranularity: .weekOfYear) {
                thisWeek.append(date)
            } else if calendar.isDate(
                date.date,
                equalTo: now.addingTimeInterval(
                    7*24*60*60
                ),
                toGranularity: .weekOfYear
            ) {
                nextWeek.append(date)
            } else {
                upcoming.append(date)
            }
        }
        
        // Create date groups
        var groups: [DateGroup] = []
        
        if !pastDue.isEmpty {
            groups.append(DateGroup(type: .pastDue, dates: pastDue))
        }
        
        if !today.isEmpty {
            groups.append(DateGroup(type: .today, dates: today))
        }
        
        if !thisWeek.isEmpty {
            groups.append(DateGroup(type: .thisWeek, dates: thisWeek))
        }
        
        if !nextWeek.isEmpty {
            groups.append(DateGroup(type: .nextWeek, dates: nextWeek))
        }
        
        if !upcoming.isEmpty {
            groups.append(DateGroup(type: .upcoming, dates: upcoming))
        }
        
        self.coursesDates = groups
    }
}
