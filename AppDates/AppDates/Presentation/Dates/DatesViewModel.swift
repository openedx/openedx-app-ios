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
    
    //    let router: DatesViewRouter
    let connectivity: ConnectivityProtocol = Connectivity()
    
    //    private let interactor: DatesViewInteractorProtocol
    //    private let analytics: DatesViewAnalytics
    
    public init(
        //        interactor: DatesViewInteractorProtocol,
        //        router: DatesViewRouter,
        //        analytics: ProfileAnalytics,
//        connectivity: ConnectivityProtocol
    ) {
        //        self.interactor = interactor
        //        self.router = router
        //        self.analytics = analytics
//        self.connectivity = connectivity
    }
    
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
