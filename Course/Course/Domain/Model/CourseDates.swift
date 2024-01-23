//
//  CourseDates.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation
import Core

public struct CourseDates {
    let datesBannerInfo: DatesBannerInfo
    let courseDateBlocks: [CourseDateBlock]
    let hasEnded, learnerIsFullAccess: Bool
    let userTimezone: String?
    
    var sortedStatusToDateToCourseDateBlockDict: [CompletionStatus: [Date: [CourseDateBlock]]] {
        var statusToDateToCourseDateBlockDict: [CompletionStatus: [Date: [CourseDateBlock]]] = [:]
        var statusToCourseDateBlockDict: [CompletionStatus: [CourseDateBlock]] = [:]
        
        for block in courseDateBlocks {
            let date = block.date
            switch true {
            case block.complete ?? false:
                statusToCourseDateBlockDict[.completed, default: []].append(block)
            case date.isInPast:
                statusToCourseDateBlockDict[.pastDue, default: []].append(block)
            case date.isToday:
                if date < Date() {
                    statusToCourseDateBlockDict[.pastDue, default: []].append(block)
                } else {
                    statusToCourseDateBlockDict[.today, default: []].append(block)
                }
            case date.isThisWeek:
                statusToCourseDateBlockDict[.thisWeek, default: []].append(block)
            case date.isNextWeek:
                statusToCourseDateBlockDict[.nextWeek, default: []].append(block)
            case date.isUpcoming:
                statusToCourseDateBlockDict[.upcoming, default: []].append(block)
            default:
                statusToCourseDateBlockDict[.upcoming, default: []].append(block)
            }
        }
        
        for status in statusToCourseDateBlockDict.keys {
            let courseDateBlocks = statusToCourseDateBlockDict[status]
            var dateToCourseDateBlockDict: [Date: [CourseDateBlock]] = [:]
            
            for block in courseDateBlocks ?? [] {
                let date = block.date
                dateToCourseDateBlockDict[date, default: []].append(block)
            }
            statusToDateToCourseDateBlockDict[status] = dateToCourseDateBlockDict
        }
        
        return statusToDateToCourseDateBlockDict
    }
}

extension Date {
    static var today: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    static func compare(_ fromDate: Date, to toDate: Date) -> ComparisonResult {
        if fromDate > toDate {
            return .orderedDescending
        } else if fromDate < toDate {
            return .orderedAscending
        }
        return .orderedSame
    }
    
    var isInPast: Bool {
        return Date.compare(self, to: .today) == .orderedAscending
    }
    
    var isToday: Bool {
        let calendar = Calendar.current
        let selfComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let todayComponents = calendar.dateComponents([.year, .month, .day], from: .today)
        return selfComponents == todayComponents
    }
    
    var isInFuture: Bool {
        return Date.compare(self, to: .today) == .orderedDescending
    }
    
    var isThisWeek: Bool {
        // Items due within the next 7 days (7*24 hours from now)
        let calendar = Calendar.current
        let nextDay = calendar.date(byAdding: .day, value: 1, to: .today) ?? .distantPast
        let nextSeventhDay = calendar.date(byAdding: .day, value: 8, to: .today) ?? .distantPast
        return (nextDay...nextSeventhDay).contains(self)
    }
    
    var isNextWeek: Bool {
        // Items due within the next 14 days (14*24 hours from now)
        let calendar = Calendar.current
        let nextEighthDay = calendar.date(byAdding: .day, value: 8, to: .today) ?? .distantPast
        let nextFourteenthDay = calendar.date(byAdding: .day, value: 15, to: .today) ?? .distantPast
        return (nextEighthDay...nextFourteenthDay).contains(self)
    }
    
    var isUpcoming: Bool {
        // Items due after the next 14 days (14*24 hours from now)
        let calendar = Calendar.current
        let nextFourteenthDay = calendar.date(byAdding: .day, value: 14, to: .today) ?? .distantPast
        return Date.compare(self, to: nextFourteenthDay) == .orderedDescending
    }
}

public struct CourseDateBlock: Identifiable {
    public let id: UUID = UUID()
    
    let assignmentType: String?
    let complete: Bool?
    let date: Date
    let dateType, description: String
    let learnerHasAccess: Bool
    let link: String
    let linkText: String?
    let title: String
    let extraInfo: String?
    let firstComponentBlockID: String
    
    var formattedDate: String {
        return date.dateToString(style: .shortWeekdayMonthDayYear)
    }
    
    var isInPast: Bool {
        return date.isInPast
    }
    
    var isToday: Bool {
        if dateType.isEmpty {
            return true
        } else {
            return date.isToday
        }
    }
    
    var isInFuture: Bool {
        return date.isInFuture
    }
    
    var isThisWeek: Bool {
        return date.isThisWeek
    }
    
    var isNextWeek: Bool {
        return date.isNextWeek
    }
    
    var isUpcoming: Bool {
        return date.isUpcoming
    }
    
    var isAssignment: Bool {
        return BlockStatus.status(of: dateType) == .assignment
    }
    
    var isVerifiedOnly: Bool {
        return !learnerHasAccess
    }
    
    var isComplete: Bool {
        return complete ?? false
    }
    
    var isLearnerAssignment: Bool {
        return learnerHasAccess && isAssignment
    }
    
    var isPastDue: Bool {
        return !isComplete && (date < .today)
    }
    
    var isUnreleased: Bool {
        return link.isEmpty
    }
    
    var canShowLink: Bool {
        return !isUnreleased && isLearnerAssignment
    }
    
    var isAvailable: Bool {
        return learnerHasAccess && (!isUnreleased || !isLearnerAssignment)
    }
    
    var blockStatus: BlockStatus {
        if isComplete {
            return .completed
        }
        
        if !learnerHasAccess {
            return .verifiedOnly
        }
        
        if isAssignment {
            if isInPast {
                return isUnreleased ? .unreleased : .pastDue
            } else if isToday || isInFuture {
                return isUnreleased ? .unreleased : .dueNext
            }
        }
        
        return BlockStatus.status(of: dateType)
    }
    
    var blockImage: ImageAsset? {
        if !learnerHasAccess {
            return CoreAssets.locked
        }
        
        if isAssignment {
            return CoreAssets.assignment
        }
        
        switch blockStatus {
        case .courseStartDate, .courseEndDate, .verifiedUpgradeDeadline, .verificationDeadlineDate:
            return CoreAssets.school
        case .courseExpiredDate:
            return CoreAssets.locked
        case .certificateAvailbleDate:
            return CoreAssets.certificateIcon
        default:
            return nil
        }
    }
}

public struct DatesBannerInfo {
    let missedDeadlines, contentTypeGatingEnabled, missedGatedContent: Bool
    let verifiedUpgradeLink: String?
}

public enum BlockStatus {
    case completed
    case pastDue
    case dueNext
    case unreleased
    case verifiedOnly
    case assignment
    case verifiedUpgradeDeadline
    case courseExpiredDate
    case verificationDeadlineDate
    case certificateAvailbleDate
    case courseStartDate
    case courseEndDate
    case event
    
    static func status(of type: String) -> BlockStatus {
        switch type {
        case "assignment-due-date": return .assignment
        case "verified-upgrade-deadline": return .verifiedUpgradeDeadline
        case "course-expired-date": return .courseExpiredDate
        case "verification-deadline-date": return .verificationDeadlineDate
        case "certificate-available-date": return .certificateAvailbleDate
        case "course-start-date": return .courseStartDate
        case "course-end-date": return .courseEndDate
        default: return .event
        }
    }
}

public enum CompletionStatus: String {
    case completed = "Completed"
    case pastDue = "Past Due"
    case today = "Today"
    case thisWeek = "This Week"
    case nextWeek = "Next Week"
    case upcoming = "Upcoming"
}
