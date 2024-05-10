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
        dateFormatter?.locale = Locale(identifier: "en_US_POSIX")
        
        date = formats.compactMap { format in
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
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = .current
        formatter.unitsStyle = .full
        formatter.locale = Locale(identifier: "en_US_POSIX")
        if description == Date().description {
            return CoreLocalization.Date.justNow
        } else {
            return formatter.localizedString(for: self, relativeTo: Date())
        }
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
    
    func dateToString(style: DateStringStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        switch style {
        case .courseStartsMonthDDYear:
            dateFormatter.dateFormat = CoreLocalization.DateFormat.mmmDdYyyy
        case .courseEndsMonthDDYear:
            dateFormatter.dateFormat = CoreLocalization.DateFormat.mmmDdYyyy
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
            return getShortWeekdayMonthDayYear(dateFormatterString: date)
        }
    }
    
    private func applyShortWeekdayMonthDayYear(dateFormatter: DateFormatter) {
        if isCurrentYear() {
            let days = Calendar.current.dateComponents([.day], from: self, to: Date())
            if let day = days.day, (-6 ... -2).contains(day) {
                dateFormatter.dateFormat = "EEEE"
            } else {
                dateFormatter.dateFormat = "MMMM d"
            }
        } else {
            dateFormatter.dateFormat = "MMMM d, yyyy"
        }
    }
    
    private func getShortWeekdayMonthDayYear(dateFormatterString: String) -> String {
        let days = Calendar.current.dateComponents([.day], from: self, to: Date())
        
        if let day = days.day {
            guard isCurrentYear() else {
                // It's past year or future year
                return dateFormatterString
            }
            
            switch day {
            case -6...(-2):
                return dateFormatterString
            case 2...6:
                return timeAgoDisplay()
            case -1:
                return CoreLocalization.tomorrow
            case 1:
                return CoreLocalization.yesterday
            default:
                if day > 6 || day < -6 {
                    return dateFormatterString
                } else {
                    // It means, date is in hours past due or upcoming
                    return timeAgoDisplay()
                }
            }
        } else {
            return dateFormatterString
        }
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
