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
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let connectivity: ConnectivityProtocol
    private let interactor: DatesViewInteractorProtocol
    
    public init(
        interactor: DatesViewInteractorProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.connectivity = connectivity
    }
    
    public func loadDates(isRefresh: Bool = false) async {
        isShowProgress = !isRefresh
        
        do {
            let dates: [CourseDate]
            
            if connectivity.isInternetAvaliable {
                dates = try await interactor.getCourseDates(page: 1)
            } else {
                dates = try await interactor.getCourseDatesOffline()
            }
            
            self.isShowProgress = false
            self.processDates(dates)
        } catch {
            self.isShowProgress = false
            self.errorMessage = error.localizedDescription
        }
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
    
    // For testing and preview
    public func loadMockDates(isRefresh: Bool = false) async {
        isShowProgress = !isRefresh
        
        try? await Task.sleep(for: .seconds(1))
        self.isShowProgress = false
        
        self.coursesDates = [
            DateGroup(
                type: .pastDue,
                dates: [
                    CourseDate(
                        date: Date().addingTimeInterval(-86400 * 5),
                        title: "Past Assignment 1",
                        courseName: "Course 1"
                    ),
                    CourseDate(
                        date: Date().addingTimeInterval(-86400 * 4),
                        title: "Past Assignment 2",
                        courseName: "Course 2"
                    ),
                    CourseDate(
                        date: Date().addingTimeInterval(-86400 * 3),
                        title: "Past Assignment 3",
                        courseName: "Course 3"
                    )
                ]
            ),
            DateGroup(
                type: .today,
                dates: [
                    CourseDate(
                        date: Date(),
                        title: "Today's Assignment",
                        courseName: "Course 4"
                    ),
                    CourseDate(
                        date: Date(),
                        title: "Another Today's Task",
                        courseName: "Course 5"
                    )
                ]
            ),
            DateGroup(
                type: .thisWeek,
                dates: [
                    CourseDate(
                        date: Date().addingTimeInterval(86400 * 1),
                        title: "This Week Task 1",
                        courseName: "Course 6"
                    ),
                    CourseDate(
                        date: Date().addingTimeInterval(86400 * 2),
                        title: "This Week Task 2",
                        courseName: "Course 7"
                    )
                ]
            ),
            DateGroup(
                type: .nextWeek,
                dates: [
                    CourseDate(
                        date: Date().addingTimeInterval(86400 * 7),
                        title: "Next Week Task",
                        courseName: "Course 8"
                    )
                ]
            ),
            DateGroup(
                type: .upcoming,
                dates: [
                    CourseDate(
                        date: Date().addingTimeInterval(86400 * 14),
                        title: "Future Task 1",
                        courseName: "Course 9"
                    ),
                    CourseDate(
                        date: Date().addingTimeInterval(86400 * 15),
                        title: "Future Task 2",
                        courseName: "Course 10"
                    )
                ]
            )
        ]
    }
}
