//
//  DateExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.09.2022.
//

import Foundation

public extension Date {
    init(iso8601: String) {
        let formats = ["yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"]
        let calender = Calendar.current
        var date: Date
        var dateFormatter: DateFormatter?
        dateFormatter = DateFormatter()
        dateFormatter?.locale = .current
        
        date = formats.compactMap { format -> Date? in
            dateFormatter?.dateFormat = format
            guard let formattedDate = dateFormatter?.date(from: iso8601) else { return nil }
            let components = calender.dateComponents(
                [.year, .month, .day, .hour, .minute, .second],
                from: formattedDate
            )
            return calender.date(from: components)
        }
        .first ?? Date()
        
        defer {
            dateFormatter = nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    func timeAgoDisplay(dueIn: Bool = false) -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        
        let dueString = dueIn ? CoreLocalization.Date.due : ""
        let dueInString = dueIn ? CoreLocalization.Date.dueIn : ""
        
        let startOfCurrentDate = calendar.startOfDay(for: currentDate)
        let startOfSelfDate = calendar.startOfDay(for: self)
        
        let daysRemaining = Calendar.current.dateComponents(
            [.day],
            from: startOfCurrentDate,
            to: self
        ).day ?? 0
        
        guard let sevenDaysAgo = calendar.date(byAdding: .day, value: -7, to: startOfCurrentDate),
              let sevenDaysAhead = calendar.date(byAdding: .day, value: 7, to: startOfCurrentDate) else {
            return dueInString + self.dateToString(style: .mmddyy, useRelativeDates: false)
        }
        
        let isCurrentYear = calendar.component(.year, from: self) == calendar.component(.year, from: startOfCurrentDate)
        
        if calendar.isDateInToday(startOfSelfDate) {
            return dueString + CoreLocalization.Date.today
        }
        
        if calendar.isDateInYesterday(startOfSelfDate) {
            return dueString + CoreLocalization.yesterday
        }
        
        if calendar.isDateInTomorrow(startOfSelfDate) {
            return dueString + CoreLocalization.tomorrow
        }
        
        if startOfSelfDate > startOfCurrentDate && startOfSelfDate <= sevenDaysAhead {
            let weekdayFormatter = DateFormatter()
            weekdayFormatter.dateFormat = "EEEE"
            if startOfSelfDate == calendar.date(byAdding: .day, value: 1, to: startOfCurrentDate) {
                return dueInString + CoreLocalization.tomorrow
            } else if startOfSelfDate == calendar.date(byAdding: .day, value: 7, to: startOfCurrentDate) {
                return CoreLocalization.Date.next(weekdayFormatter.string(from: startOfSelfDate))
            } else {
                return dueIn ? (
                    CoreLocalization.Date.dueInDays(daysRemaining)
                ) : weekdayFormatter.string(from: startOfSelfDate)
            }
        }
        
        if startOfSelfDate < startOfCurrentDate && startOfSelfDate >= sevenDaysAgo {
            guard let daysAgo = calendar.dateComponents(
                [.day],
                from: startOfSelfDate,
                to: startOfCurrentDate
            ).day else {
                return self.dateToString(style: .mmddyy, useRelativeDates: false)
            }
            return CoreLocalization.Date.daysAgo(daysAgo)
        }
        
        let specificFormatter = DateFormatter()
        specificFormatter.dateFormat = isCurrentYear ? "MMMM d" : "MMMM d, yyyy"
        return dueInString + specificFormatter.string(from: self)
    }
    
    func isDateInNextWeek(date: Date, currentDate: Date) -> Bool {
        let calendar = Calendar.current
        guard let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: currentDate) else { return false }
        let startOfNextWeek = calendar.startOfDay(for: nextWeek)
        guard let endOfNextWeek = calendar.date(byAdding: .day, value: 6, to: startOfNextWeek) else { return false }
        let startOfSelfDate = calendar.startOfDay(for: date)
        return startOfSelfDate >= startOfNextWeek && startOfSelfDate <= endOfNextWeek
    }
    
    init(subtitleTime: String) {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.year, .month, .day], from: now)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss,SSS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = "\(components.year!)-\(components.month!)-\(components.day!) \(subtitleTime)"
        guard let date = dateFormatter.date(from: dateString) else {
            self = now
            return
        }
        self = date
    }
    
    init(milliseconds: Double) {
        let now = Date()
        let calendar = Calendar.current
        var components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: now)
        components.nanosecond = Int((milliseconds.truncatingRemainder(dividingBy: 1)) * 1000000)
        let seconds = Int(milliseconds)
        components.second = seconds % 60
        components.minute = (seconds / 60) % 60
        components.hour = (seconds / 3600) % 24
        let date = calendar.date(from: components) ?? Date()
        self = date
    }
}

public enum DateStringStyle {
    case courseStartsMonthDDYear
    case courseEndsMonthDDYear
    case startDDMonthYear
    case endedMonthDay
    case mmddyy
    case monthYear
    case lastPost
    case iso8601
    case shortWeekdayMonthDayYear
}

public extension Date {
    
    func secondsSinceMidnight() -> Double {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute, .second], from: self)
        
        guard let hours = components.hour, let minutes = components.minute, let seconds = components.second else {
            return 0.0
        }
        
        let totalSeconds = Double(hours) * 3600.0 + Double(minutes) * 60.0 + Double(seconds)
        return totalSeconds
    }
    
    func dateToString(style: DateStringStyle, useRelativeDates: Bool, dueIn: Bool = false) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = .current
        
        if useRelativeDates {
            return timeAgoDisplay(dueIn: dueIn)
        } else {
            switch style {
            case .courseStartsMonthDDYear:
                dateFormatter.dateStyle = .medium
            case .courseEndsMonthDDYear:
                dateFormatter.dateStyle = .medium
            case .endedMonthDay:
                dateFormatter.dateFormat = CoreLocalization.DateFormat.mmmmDd
            case .mmddyy:
                dateFormatter.dateFormat = "dd.MM.yy"
            case .monthYear:
                dateFormatter.dateFormat = "MMMM yyyy"
            case .startDDMonthYear:
                dateFormatter.dateFormat = "dd MMM yyyy"
            case .lastPost:
                dateFormatter.dateFormat = CoreLocalization.DateFormat.mmmDdYyyy
            case .iso8601:
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            case .shortWeekdayMonthDayYear:
                applyShortWeekdayMonthDayYear(dateFormatter: dateFormatter)
            }
        }
        
        let date = dateFormatter.string(from: self)
        
        switch style {
        case .courseStartsMonthDDYear:
            return CoreLocalization.Date.courseStarts + " " + date
        case .courseEndsMonthDDYear:
            if Date() < self {
                return CoreLocalization.Date.courseEnds + " " + date
            } else {
                return CoreLocalization.Date.courseEnded + " " + date
            }
        case .endedMonthDay:
            return CoreLocalization.Date.ended + " " + date
        case .mmddyy, .monthYear:
            return date
        case .startDDMonthYear:
            if Date() < self {
                return CoreLocalization.Date.start + " " + date
            } else {
                return CoreLocalization.Date.started + " " + date
            }
        case .lastPost:
            let days = Calendar.current.dateComponents([.day], from: self, to: Date())
            if let day = days.day {
                if day < 2 {
                    return timeAgoDisplay()
                } else {
                    return date
                }
            } else {
                return date
            }
        case .iso8601:
            return date
        case .shortWeekdayMonthDayYear:
            return (
                dueIn ? CoreLocalization.Date.dueIn : ""
            ) + date
        }
    }
    
    private func applyShortWeekdayMonthDayYear(dateFormatter: DateFormatter) {
        dateFormatter.dateFormat = "MMMM d, yyyy"
    }
    
    func isCurrentYear() -> Bool {
        let selfYear = Calendar.current.component(.year, from: self)
        let runningYear = Calendar.current.component(.year, from: Date())
        return selfYear == runningYear
    }
}

public extension Date {
    func isEarlierThanOrEqualTo(date: Date) -> Bool {
        timeIntervalSince1970 <= date.timeIntervalSince1970
    }
    
    func isLaterThanOrEqualTo(date: Date) -> Bool {
        timeIntervalSince1970 >= date.timeIntervalSince1970
    }
}
