//
//  Data_CourseDates.swift
//  Course
//
//  Created by Muhammad Umer on 10/18/23.
//

import Foundation
import Core

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
    }
}

public extension DataLayer.CourseDates {
    var domain: CourseDates {
        return CourseDates(
            datesBannerInfo: DatesBannerInfo(
                missedDeadlines: datesBannerInfo?.missedDeadlines ?? false,
                contentTypeGatingEnabled: datesBannerInfo?.contentTypeGatingEnabled ?? false,
                missedGatedContent: datesBannerInfo?.missedGatedContent ?? false,
                verifiedUpgradeLink: datesBannerInfo?.verifiedUpgradeLink),
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
                    firstComponentBlockID: block.firstComponentBlockID)
            },
            hasEnded: hasEnded,
            learnerIsFullAccess: learnerIsFullAccess,
            userTimezone: userTimezone)
    }
}
