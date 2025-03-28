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
    private var fetchInProgress = false
    private var allDates: [CourseDate] = []
    
    let connectivity: ConnectivityProtocol
    private let interactor: DatesViewInteractorProtocol
    private let courseManager: CourseStructureManagerProtocol
    private let analytics: AppDatesAnalytics
    private(set) var router: AppDatesRouter
    
    public init(
        interactor: DatesViewInteractorProtocol,
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
        }
        
        do {
            if connectivity.isInternetAvaliable {
                
                let offlineDates = try await interactor.getCourseDatesOffline(page: nextPage)
                
                allDates = offlineDates
                self.processDates(allDates)
                
                if !offlineDates.isEmpty && nextPage == 1 {
                    isShowProgress = false
                    fetchInProgress = true
                    await interactor.clearAllCourseDates()
                }
                
                let (dates, nextPageUrl) = try await interactor.getCourseDates(page: nextPage)
                
//                if nextPage == 1 {
//                    allDates = []
//                    coursesDates = []
//                }
                
                allDates = dates
                hasNextPage = nextPageUrl != nil
                
                if hasNextPage {
                    nextPage += 1
                }
                
                if delayedLoadSecondPage {
                    print(">>> 🐺 delayedLoadSecondPage true, start loadNextPageIfNeeded", allDates.count - 3)
                    await loadNextPageIfNeeded(index: allDates.count - 3)
                }
                
            } else {
                let dates = try await interactor.getCourseDatesOffline(page: nil)
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
    
    public func loadNextPageIfNeeded(index: Int) async {
        if !hasNextPage && nextPage == 1 && index == allDates.count - 3 {
            delayedLoadSecondPage = true
            fetchInProgress = false
            print(">>> 🐺 1")
            return
        }
        guard connectivity.isInternetAvaliable
                && !fetchInProgress
                && hasNextPage
                && index == allDates.count - 3 else { return }
        
        fetchInProgress = true
        isLoadingNextPage = true
        
        if delayedLoadSecondPage {
            print(">>> 🐺 delayedLoadSecondPage = false")
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
            groups.append(DateGroup(type: .pastDue, dates: pastDue.sorted(by: { $0.date < $1.date })))
            showShiftDueDatesView = true
        }
        
        if !today.isEmpty {
            groups.append(DateGroup(type: .today, dates: today.sorted(by: { $0.date < $1.date })))
        }
        
        if !thisWeek.isEmpty {
            groups.append(DateGroup(type: .thisWeek, dates: thisWeek.sorted(by: { $0.date < $1.date })))
        }
        
        if !nextWeek.isEmpty {
            groups.append(DateGroup(type: .nextWeek, dates: nextWeek.sorted(by: { $0.date < $1.date })))
        }
        
        if !upcoming.isEmpty {
            groups.append(DateGroup(type: .upcoming, dates: upcoming.sorted(by: { $0.date < $1.date })))
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
        
//        for course in Set(pastDueCourses) {
//            do {
//                guard let courseID = course.id else { continue }
//                print(">>>>>>> COURSE FOR SHIFT: \(course.id), \(course.name)")
//
////                try await courseManager.shiftDueDates(courseID: courseID)
//                NotificationCenter.default.post(name: .shiftCourseDates, object: (course.id, course.name))
//                try await Task.sleep(nanoseconds: 2_000_000_000)
//            } catch let error {
//                isShowProgressForDueDates = false
//                if error.isInternetError || error is NoCachedDataError {
//                    errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
//                } else {
//                    errorMessage = CoreLocalization.Error.unknownError
//                }
//                
//            }
//        }
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
            print(">>>>>>> COURSE FOR SHIFT: \(course.id), \(course.name)")
            NotificationCenter.default.post(name: .shiftCourseDates, object: (course.id, course.name))
        }
    }
}
