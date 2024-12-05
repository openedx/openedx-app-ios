//
//  Data_CourseDates.swift
//  Core
//
//  Created by  Stepanok Ivan on 05.06.2024.
//

import Foundation

public extension DataLayer {
    struct CourseDates: Codable {
        let datesBannerInfo: DatesBannerInfo?
        let courseDateBlocks: [CourseDateBlock]
        let hasEnded, learnerIsFullAccess: Bool
        let userTimezone: String?
        
        enum CodingKeys: String, CodingKey {
            case datesBannerInfo = "dates_banner_info"
            case courseDateBlocks = "course_date_blocks"
            case hasEnded = "has_ended"
            case learnerIsFullAccess = "learner_is_full_access"
            case userTimezone = "user_timezone"
        }
    }
    
    struct CourseDateBlock: Codable {
        let assignmentType: String?
        let complete: Bool?
        let date, dateType, description: String
        let learnerHasAccess: Bool
        let link, title: String
        let linkText: String?
        let extraInfo: String?
        let firstComponentBlockID: String
        
        enum CodingKeys: String, CodingKey {
            case assignmentType = "assignment_type"
            case complete, date
            case dateType = "date_type"
            case description
            case learnerHasAccess = "learner_has_access"
            case link
            case linkText = "link_text"
            case title
            case extraInfo = "extra_info"
            case firstComponentBlockID = "first_component_block_id"
        }
    }
    
    struct DatesBannerInfo: Codable {
        let missedDeadlines, contentTypeGatingEnabled, missedGatedContent: Bool
        let verifiedUpgradeLink: String?

        enum CodingKeys: String, CodingKey {
            case missedDeadlines = "missed_deadlines"
            case contentTypeGatingEnabled = "content_type_gating_enabled"
            case missedGatedContent = "missed_gated_content"
            case verifiedUpgradeLink = "verified_upgrade_link"
        }
        
        var status: BannerInfoStatus? {
            if upgradeToCompleteGraded {
                return .upgradeToCompleteGradedBanner
            } else if upgradeToReset {
                return .upgradeToResetBanner
            } else if resetDates {
                return .resetDatesBanner
            } else if showDatesTabBannerInfo {
                return .datesTabInfoBanner
            }
            
            return nil
        }
        
        // Case 1
        private var showDatesTabBannerInfo: Bool {
            return !missedDeadlines
        }
        
        // Case 2
        private var upgradeToCompleteGraded: Bool {
            return contentTypeGatingEnabled && !missedDeadlines
        }
        
        // Case 3
        private var upgradeToReset: Bool {
            return !upgradeToCompleteGraded && missedDeadlines && missedGatedContent
        }
        
        // Case 4
        private var resetDates: Bool {
            return !upgradeToCompleteGraded && missedDeadlines && !missedGatedContent
        }
    }
    
    enum BannerInfoStatus: Sendable {
        case datesTabInfoBanner
        case upgradeToCompleteGradedBanner
        case upgradeToResetBanner
        case resetDatesBanner
            
        public var header: String {
            switch self {
            case .datesTabInfoBanner:
                CoreLocalization.CourseDates.ResetDate.TabInfoBanner.header
            case .upgradeToCompleteGradedBanner:
                CoreLocalization.CourseDates.ResetDate.UpgradeToCompleteGradedBanner.header
            case .upgradeToResetBanner:
                CoreLocalization.CourseDates.ResetDate.UpgradeToResetBanner.header
            case .resetDatesBanner:
                CoreLocalization.CourseDates.ResetDate.ResetDateBanner.header
            }
        }
        
        public var body: String {
            switch self {
            case .datesTabInfoBanner:
                CoreLocalization.CourseDates.ResetDate.TabInfoBanner.body
            case .upgradeToCompleteGradedBanner:
                CoreLocalization.CourseDates.ResetDate.UpgradeToCompleteGradedBanner.body
            case .upgradeToResetBanner:
                CoreLocalization.CourseDates.ResetDate.UpgradeToResetBanner.body
            case .resetDatesBanner:
                CoreLocalization.CourseDates.ResetDate.ResetDateBanner.body
            }
        }
        
        public var buttonTitle: String {
            switch self {
            case .upgradeToCompleteGradedBanner, .upgradeToResetBanner:
                // Mobile payments are not implemented yet and to avoid breaking appstore guidelines,
                // upgrade button is hidden, which leads user to payments
                ""
            case .resetDatesBanner:
                CoreLocalization.CourseDates.ResetDate.ResetDateBanner.button
            default:
                ""
            }
        }
        
        public var analyticsBannerType: String {
            switch self {
            case .datesTabInfoBanner:
                "info"
            case .upgradeToCompleteGradedBanner:
                "upgrade_to_participate"
            case .upgradeToResetBanner:
                "upgrade_to_shift"
            case .resetDatesBanner:
                "shift_dates"
            }
        }
    }
}

public extension DataLayer {
    struct CourseDateBanner: Codable {
        let datesBannerInfo: DatesBannerInfo
        let hasEnded: Bool
        
        enum CodingKeys: String, CodingKey {
            case datesBannerInfo = "dates_banner_info"
            case hasEnded = "has_ended"
        }
    }
}

public extension DataLayer.CourseDates {
    func domain(useRelativeDates: Bool) -> CourseDates {
        return CourseDates(
            datesBannerInfo: DatesBannerInfo(
                missedDeadlines: datesBannerInfo?.missedDeadlines ?? false,
                contentTypeGatingEnabled: datesBannerInfo?.contentTypeGatingEnabled ?? false,
                missedGatedContent: datesBannerInfo?.missedGatedContent ?? false,
                verifiedUpgradeLink: datesBannerInfo?.verifiedUpgradeLink,
                status: datesBannerInfo?.status),
            courseDateBlocks: courseDateBlocks.map { block in
                CourseDateBlock(
                    assignmentType: block.assignmentType,
                    complete: block.complete,
                    date: Date(iso8601: block.date),
                    dateType: block.dateType,
                    description: block.description,
                    learnerHasAccess: block.learnerHasAccess,
                    link: block.link,
                    linkText: block.linkText ?? nil,
                    title: block.title,
                    extraInfo: block.extraInfo,
                    firstComponentBlockID: block.firstComponentBlockID,
                    useRelativeDates: useRelativeDates)
            },
            hasEnded: hasEnded,
            learnerIsFullAccess: learnerIsFullAccess,
            userTimezone: userTimezone)
    }
}

public extension DataLayer.CourseDateBanner {
    var domain: CourseDateBanner {
        return CourseDateBanner(
            datesBannerInfo: DatesBannerInfo(
                missedDeadlines: datesBannerInfo.missedDeadlines,
                contentTypeGatingEnabled: datesBannerInfo.contentTypeGatingEnabled,
                missedGatedContent: datesBannerInfo.missedGatedContent,
                verifiedUpgradeLink: datesBannerInfo.verifiedUpgradeLink,
                status: datesBannerInfo.status),
            hasEnded: hasEnded
        )
    }
}
