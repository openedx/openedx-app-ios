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
    
    var statusDatesBlocks: [CompletionStatus: [Date: [CourseDateBlock]]] {
        var statusDatesBlocks: [CompletionStatus: [Date: [CourseDateBlock]]] = [:]
        var statusBlocks: [CompletionStatus: [CourseDateBlock]] = [:]
        
        for block in courseDateBlocks {
            let date = block.date
            switch true {
            case block.complete ?? false || block.blockStatus == .courseStartDate:
                statusBlocks[.completed, default: []].append(block)
            case date.isInPast:
                statusBlocks[.pastDue, default: []].append(block)
            case date.isToday:
                if date < Date() {
                    statusBlocks[.pastDue, default: []].append(block)
                } else {
                    statusBlocks[.today, default: []].append(block)
                }
            case date.isThisWeek:
                statusBlocks[.thisWeek, default: []].append(block)
            case date.isNextWeek:
                statusBlocks[.nextWeek, default: []].append(block)
            case date.isUpcoming:
                statusBlocks[.upcoming, default: []].append(block)
            default:
                statusBlocks[.upcoming, default: []].append(block)
            }
        }
        
        for status in statusBlocks.keys {
            let courseDateBlocks = statusBlocks[status]
            var dateToCourseDateBlockDict: [Date: [CourseDateBlock]] = [:]
            
            for block in courseDateBlocks ?? [] {
                let date = block.date
                dateToCourseDateBlockDict[date, default: []].append(block)
            }
            statusDatesBlocks[status] = dateToCourseDateBlockDict
        }
        
        return statusDatesBlocks
    }
    
    var dateBlocks: [Date: [CourseDateBlock]] {
        return courseDateBlocks.reduce(into: [:]) { result, block in
            let date = block.date
            result[date, default: []].append(block)
        }
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
            return CoreAssets.lockIcon
        }
        
        if isAssignment {
            return CoreAssets.assignmentIcon
        }
        
        switch blockStatus {
        case .courseStartDate, .courseEndDate:
            return CoreAssets.schoolCapIcon
        case .verifiedUpgradeDeadline, .verificationDeadlineDate:
            return CoreAssets.calendarIcon
        case .courseExpiredDate:
            return CoreAssets.lockWithWatchIcon
        case .certificateAvailbleDate:
            return CoreAssets.certificateIcon
        default:
            return CoreAssets.calendarIcon
        }
    }
}

public struct DatesBannerInfo {
    let missedDeadlines, contentTypeGatingEnabled, missedGatedContent: Bool
    let verifiedUpgradeLink: String?
    let status: DataLayer.BannerInfoStatus?
}

public struct CourseDateBanner {
    let datesBannerInfo: DatesBannerInfo
    let hasEnded: Bool
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
    
    var localized: String {
        switch self {
        case .completed:
            return CourseLocalization.CourseDates.completed
        case .pastDue:
            return CourseLocalization.CourseDates.pastDue
        case .today:
            return CourseLocalization.CourseDates.today
        case .thisWeek:
            return CourseLocalization.CourseDates.today
        case .nextWeek:
            return CourseLocalization.CourseDates.today
        case .upcoming:
            return CourseLocalization.CourseDates.today
        }
    }
}

extension Array {
    mutating func modifyForEach(_ body: (_ element: inout Element) -> Void) {
        for index in indices {
            modifyElement(atIndex: index) { body(&$0) }
        }
    }

    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> Void) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
}
