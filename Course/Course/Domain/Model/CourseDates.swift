//
//  CourseDates.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation

public struct CourseDates {
    let datesBannerInfo: DatesBannerInfo
    let courseDateBlocks: [CourseDateBlock]
    let hasEnded, learnerIsFullAccess: Bool
    let userTimezone: String?
    
    var sortedDateToCourseDateBlockDict: [Date: [CourseDateBlock]] {
        var dateToCourseDateBlockDict: [Date: [CourseDateBlock]] = [:]
        var hasToday = false
        let today = Date.today
        
        for block in courseDateBlocks {
            let date = block.date
            if date == today {
                hasToday = true
            }
            
            dateToCourseDateBlockDict[date, default: []].append(block)
        }
        
        if !hasToday {
            let todayBlock = CourseDateBlock(
                assignmentType: nil,
                complete: nil,
                date: today,
                dateType: "",
                description: "",
                learnerHasAccess: true,
                link: "", linkText: nil,
                title: "Today",
                extraInfo: nil,
                firstComponentBlockID: "uniqueIDForToday")
            dateToCourseDateBlockDict[today] = [todayBlock]
        }
        
        return dateToCourseDateBlockDict
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
        return Date.compare(self, to: .today) == .orderedSame
    }
    
    var isInFuture: Bool {
        return Date.compare(self, to: .today) == .orderedDescending
    }
}

public struct CourseDateBlock {
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
    
    var blockTitle: String {
        if isToday {
            return "Today"
        } else {
            return blockStatus.title
        }
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
    
    var title: String {
        switch self {
        case .completed:
            return "Completed"
        case .pastDue:
            return "Past due"
        case .dueNext:
            return "Due next"
        case .unreleased:
            return "Unreleased"
        case .verifiedOnly:
            return "Verified Only"
        default:
            return ""
        }
    }
}
