//
//  DateGroupType.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import SwiftUI
import Theme

public enum DateGroupType: CaseIterable {
    case pastDue
    case today
    case thisWeek
    case nextWeek
    case upcoming
    
    var text: String {
        switch self {
        case .pastDue:
            AppDatesLocalization.Dates.pastDue
        case .today:
            AppDatesLocalization.Dates.today
        case .thisWeek:
            AppDatesLocalization.Dates.thisWeek
        case .nextWeek:
            AppDatesLocalization.Dates.nextWeek
        case .upcoming:
            AppDatesLocalization.Dates.upcoming
        }
    }
    
    var color: Color {
        switch self {
        case .pastDue:
            Theme.Colors.pastDueTimelineColor
        case .today:
            Theme.Colors.todayTimelineColor
        case .thisWeek:
            Theme.Colors.thisWeekTimelineColor
        case .nextWeek:
            Theme.Colors.nextWeekTimelineColor
        case .upcoming:
            Theme.Colors.upcomingTimelineColor
        }
    }
}
