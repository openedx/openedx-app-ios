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
    @Published private(set) var noDates = false
    @Published var showShiftDueDatesView = false
    @Published var isShowProgressForDueDates = false
    @Published var delayedLoadSecondPage = false
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    // Pagination properties
    private var nextPage = 1
    private var hasNextPage = false
    private(set) var fetchInProgress = false
    private var allDates: [CourseDate] = []
    private var datesLoadedFromServer = false
    
    // Items per page constant
    private let itemsPerPage = 20
    
    let connectivity: ConnectivityProtocol
    private let interactor: DatesInteractorProtocol
    private let courseManager: CourseStructureManagerProtocol
    private let analytics: AppDatesAnalytics
    private(set) var router: AppDatesRouter
    
    public init(
        interactor: DatesInteractorProtocol,
        connectivity: ConnectivityProtocol,
        courseManager: CourseStructureManagerProtocol,
        analytics: AppDatesAnalytics,
        router: AppDatesRouter
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
        self.courseManager = courseManager
        self.analytics = analytics
        self.router = router
    }
    
    @MainActor
    public func loadDates(isRefresh: Bool = false) async {
        if isRefresh {
            analytics.datesRefreshPulled()
        }
        
        isShowProgress = !isRefresh
        
        if isRefresh {
            nextPage = 1
            hasNextPage = false
            delayedLoadSecondPage = false
            datesLoadedFromServer = false
        }
        
        do {
            if connectivity.isInternetAvaliable {
                
                let offlineDates = try await interactor.getCourseDatesOffline(limit: itemsPerPage, offset: 0)
                
                allDates = offlineDates
                self.processDates(allDates)
                
                if !offlineDates.isEmpty && nextPage == 1 {
                    isShowProgress = false
                    fetchInProgress = true
                }
                
                let (dates, nextPageUrl) = try await interactor.getCourseDates(page: nextPage)
                datesLoadedFromServer = true
                
                allDates = dates
                hasNextPage = nextPageUrl != nil
                
                if hasNextPage {
                    nextPage += 1
                } else {
                    delayedLoadSecondPage = false
                }
                
                if delayedLoadSecondPage, hasNextPage {
                    await loadNextPageIfNeeded(for: allDates[allDates.count - 3])
                }
                
            } else {
                let dates = try await interactor.getCourseDatesOffline(limit: nil, offset: nil)
                allDates = []
                coursesDates = []
                allDates = dates
                hasNextPage = false
            }
            noDates = allDates.isEmpty
            self.isShowProgress = false
            self.fetchInProgress = false
            self.processDates(allDates)
        } catch let error {
            isShowProgress = false
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.isUpdateRequeiredError {
                self.router.showUpdateRequiredView(showAccountLink: true)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    public func loadNextPageIfNeeded(for date: CourseDate) async {
        guard let index = allDates.firstIndex(where: { $0.id == date.id }) else { return }

        if !datesLoadedFromServer
            && !hasNextPage
            && nextPage == 1
            && index == allDates.count - 3
            && connectivity.isInternetAvaliable {
            delayedLoadSecondPage = true
            fetchInProgress = false
            return
        }
        guard connectivity.isInternetAvaliable
                && !fetchInProgress
                && hasNextPage
                && index == allDates.count - 3 else { return }
        
        fetchInProgress = true
        isLoadingNextPage = true
        
        if delayedLoadSecondPage {
            delayedLoadSecondPage = false
        }
        
        do {
            let (newDates, nextPageUrl) = try await interactor.getCourseDates(page: nextPage)
            allDates.append(contentsOf: newDates)
            
            hasNextPage = nextPageUrl != nil
            
            if hasNextPage {
                nextPage += 1
            }
            
            processDates(allDates)
            fetchInProgress = false
            isLoadingNextPage = false
        } catch let error {
            isShowProgress = false
            isLoadingNextPage = false
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.isUpdateRequeiredError {
                self.router.showUpdateRequiredView(showAccountLink: true)
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func openVertical(date: CourseDate) async {
        guard let courseId = date.courseId else { return }
        
        analytics.datesCourseClicked(courseId: courseId, courseName: date.courseName)
        
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
        
        let startOfToday = calendar.startOfDay(for: now)

        for date in dates {
            if date.date < startOfToday {
                pastDue.append(date)
            } else if calendar.isDateInToday(date.date) {
                today.append(date)
            } else if calendar.isDate(date.date, equalTo: now, toGranularity: .weekOfYear) {
                thisWeek.append(date)
            } else if calendar.isDate(
                date.date,
                equalTo: now.addingTimeInterval(7 * 24 * 60 * 60),
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
            showShiftDueDatesView = true
        } else {
            showShiftDueDatesView = false
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
    
    @MainActor
    public func shiftDueDates() async {
        isShowProgressForDueDates = true
        
        do {
            try await interactor.resetAllRelativeCourseDeadlines()
            sendShiftDatesNotifications()
            isShowProgressForDueDates = false
            await loadDates(isRefresh: true)
        } catch let error {
            isShowProgressForDueDates = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
        isShowProgressForDueDates = false
        withAnimation(.bouncy(duration: 0.15)) {
            showShiftDueDatesView = false
        }
    }
    
    private func sendShiftDatesNotifications() {
        struct Course: Hashable {
            let id: String?
            let name: String
        }
        
        let pastDueCourses = coursesDates
            .filter { $0.type == .pastDue }
            .flatMap { $0.dates.compactMap { Course(id: $0.courseId, name: $0.courseName) } }
        
        for course in Set(pastDueCourses) {
            guard let courseID = course.id else { continue }
            NotificationCenter.default.post(name: .shiftCourseDates, object: (courseID, course.name))
        }
    }
}
