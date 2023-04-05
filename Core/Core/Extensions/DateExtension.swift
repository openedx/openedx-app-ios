//
//  DateExtension.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.09.2022.
//

import Foundation

public extension Date {
    init(iso8601: String) {
        let date: Date
        var dateFormatter: DateFormatter?
        dateFormatter = DateFormatter()
        dateFormatter?.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        date = dateFormatter?.date(from: iso8601) ?? Date()
        defer {
            dateFormatter = nil
        }
        self.init(timeInterval: 0, since: date)
    }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = .current
        formatter.unitsStyle = .full
        if self.description == Date().description {
            return CoreLocalization.Date.justNow
        } else {
            return formatter.localizedString(for: self, relativeTo: Date())
        }
    }
    
    init(subtitleTime: String) {
          let calendar = Calendar.current
          let now = Date()
          var components = calendar.dateComponents([.year, .month, .day], from: now)
          var dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss,SSS"
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
    case startDDMonthYear
    case endedMonthDay
    case mmddyy
    case monthYear
    case lastPost
    case iso8601
}

public extension Date {
    func dateToString(style: DateStringStyle) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        
        switch style {
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
        }
        
        let date = dateFormatter.string(from: self)

        switch style {
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
                    return self.timeAgoDisplay()
                } else {
                    return date
                }
            } else {
                return date
            }
        case .iso8601:
            return date
        }
    }
}
