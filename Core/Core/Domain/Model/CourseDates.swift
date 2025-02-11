//
//  CourseDates.swift
//  Core
//
//  Created by  Stepanok Ivan on 05.06.2024.
//

import Foundation
import CryptoKit

public struct CourseDates: Sendable {
    public let datesBannerInfo: DatesBannerInfo
    public let courseDateBlocks: [CourseDateBlock]
    public let hasEnded, learnerIsFullAccess: Bool
    public let userTimezone: String?
    
    public var statusDatesBlocks: [CompletionStatus: [Date: [CourseDateBlock]]] {
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
    
    public var dateBlocks: [Date: [CourseDateBlock]] {
        return courseDateBlocks.reduce(into: [:]) { result, block in
            let date = block.date
            result[date, default: []].append(block)
        }
    }
    
    public init(
        datesBannerInfo: DatesBannerInfo,
        courseDateBlocks: [CourseDateBlock],
        hasEnded: Bool,
        learnerIsFullAccess: Bool,
        userTimezone: String?
    ) {
        self.datesBannerInfo = datesBannerInfo
        self.courseDateBlocks = courseDateBlocks
        self.hasEnded = hasEnded
        self.learnerIsFullAccess = learnerIsFullAccess
        self.userTimezone = userTimezone
    }
    
    public var checksum: String {
        var combinedString = ""
        for block in self.courseDateBlocks {
            let assignmentType = block.assignmentType ?? ""
            combinedString += assignmentType + block.firstComponentBlockID + block.date.description
        }
        
        let checksumData = SHA256.hash(data: Data(combinedString.utf8))
        let checksumString = checksumData.map { String(format: "%02hhx", $0) }.joined()
        return checksumString
    }
}

public extension Date {
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

public struct CourseDateBlock: Identifiable, Sendable {
    public let id: UUID = UUID()
    
    public let assignmentType: String?
    public let complete: Bool?
    public let date: Date
    public let dateType, description: String
    public let learnerHasAccess: Bool
    public let link: String
    public let linkText: String?
    public let title: String
    public let extraInfo: String?
    public let firstComponentBlockID: String
    public let useRelativeDates: Bool
    
    public var formattedDate: String {
        return date.dateToString(style: .shortWeekdayMonthDayYear, useRelativeDates: useRelativeDates)
    }
    
    public var isInPast: Bool {
        return date.isInPast
    }
    
    public var isToday: Bool {
        if dateType.isEmpty {
            return true
        } else {
            return date.isToday
        }
    }
    
    public var isInFuture: Bool {
        return date.isInFuture
    }
    
    public var isThisWeek: Bool {
        return date.isThisWeek
    }
    
    public var isNextWeek: Bool {
        return date.isNextWeek
    }
    
    public var isUpcoming: Bool {
        return date.isUpcoming
    }
    
    public var isAssignment: Bool {
        return BlockStatus.status(of: dateType) == .assignment
    }
    
    public var isVerifiedOnly: Bool {
        return !learnerHasAccess
    }
    
    public var isComplete: Bool {
        return complete ?? false
    }
    
    public var isLearnerAssignment: Bool {
        return learnerHasAccess && isAssignment
    }
    
    public var isPastDue: Bool {
        return !isComplete && (date < .today)
    }
    
    public var isUnreleased: Bool {
        return link.isEmpty
    }
    
    public var canShowLink: Bool {
        return !isUnreleased && isLearnerAssignment
    }
    
    public var isAvailable: Bool {
        return learnerHasAccess && (!isUnreleased || !isLearnerAssignment)
    }
    
    public var blockStatus: BlockStatus {
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
    
    public var blockImage: ImageAsset? {
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

public struct DatesBannerInfo: Sendable {
    public let missedDeadlines, contentTypeGatingEnabled, missedGatedContent: Bool
    public let verifiedUpgradeLink: String?
    public let status: DataLayer.BannerInfoStatus?
    
    public init(
        missedDeadlines: Bool,
        contentTypeGatingEnabled: Bool,
        missedGatedContent: Bool,
        verifiedUpgradeLink: String?,
        status: DataLayer.BannerInfoStatus?
    ) {
        self.missedDeadlines = missedDeadlines
        self.contentTypeGatingEnabled = contentTypeGatingEnabled
        self.missedGatedContent = missedGatedContent
        self.verifiedUpgradeLink = verifiedUpgradeLink
        self.status = status
    }
}

public struct CourseDateBanner: Sendable {
    public let datesBannerInfo: DatesBannerInfo
    public let hasEnded: Bool
    
    public init(datesBannerInfo: DatesBannerInfo, hasEnded: Bool) {
        self.datesBannerInfo = datesBannerInfo
        self.hasEnded = hasEnded
    }
}

public enum BlockStatus: Sendable {
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

public enum CompletionStatus: String, Sendable {
    case completed = "Completed"
    case pastDue = "Past Due"
    case today = "Today"
    case thisWeek = "This Week"
    case nextWeek = "Next Week"
    case upcoming = "Upcoming"
    
    public var localized: String {
        switch self {
        case .completed:
            return CoreLocalization.CourseDates.completed
        case .pastDue:
            return CoreLocalization.CourseDates.pastDue
        case .today:
            return CoreLocalization.CourseDates.today
        case .thisWeek:
            return CoreLocalization.CourseDates.thisWeek
        case .nextWeek:
            return CoreLocalization.CourseDates.nextWeek
        case .upcoming:
            return CoreLocalization.CourseDates.upcoming
        }
    }
}

public extension Array {
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
