//
//  CourseEndpoint.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation
import Core
import OEXFoundation
import Alamofire

enum CourseEndpoint: EndPointType {
    case getCourseBlocks(courseID: String, userName: String)
    case pageHTML(pageUrlString: String)
    case blockCompletionRequest(username: String, courseID: String, blockID: String)
    case getHandouts(courseID: String)
    case getUpdates(courseID: String)
    case resumeBlock(userName: String, courseID: String)
    case getSubtitles(url: String, selectedLanguage: String)
    case getCourseDates(courseID: String)
    case getCourseDeadlineInfo(courseID: String)
    case courseDatesReset(courseID: String)

    var path: String {
        switch self {
        case .getCourseBlocks:
            return "/api/mobile/v4/course_info/blocks/"
        case .pageHTML(let url):
            return "/xblock/\(url)"
        case .blockCompletionRequest:
            return "/api/completion/v1/completion-batch"
        case let .getHandouts(courseID):
            return "/api/mobile/v1/course_info/\(courseID)/handouts"
        case .getUpdates(let courseID):
            return "/api/mobile/v1/course_info/\(courseID)/updates"
        case let .resumeBlock(userName, courseID):
            return "/api/mobile/v1/users/\(userName)/course_status_info/\(courseID)"
        case let .getSubtitles(url, _):
            return url
        case .getCourseDates(let courseID):
            return "/api/course_home/v1/dates/\(courseID)"
        case .getCourseDeadlineInfo(let courseID):
            return "/api/course_experience/v1/course_deadlines_info/\(courseID)"
        case .courseDatesReset:
            return "/api/course_experience/v1/reset_course_deadlines"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getCourseBlocks:
            return .get
        case .pageHTML:
            return .get
        case .blockCompletionRequest:
            return .post
        case .getHandouts:
            return .get
        case .getUpdates:
            return .get
        case .resumeBlock:
            return .get
        case .getSubtitles:
            return .get
        case .getCourseDates:
            return .get
        case .getCourseDeadlineInfo:
            return .get
        case .courseDatesReset:
            return .post
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: HTTPTask {
        switch self {
        case let .getCourseBlocks(courseID, userName):
            let params: [String: Encodable & Sendable] = [
                "username": userName,
                "course_id": courseID,
                "depth": "all",
                "student_view_data": "video,discussion,html,problem",
                "nav_depth": "4",
                "requested_fields": """
                contains_gated_content,show_gated_sections,special_exam_info,graded,
                format,student_view_multi_device,due,completion,assignment_progress
                """,
                "block_counts": "video"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .pageHTML:
            return .request
        case let .blockCompletionRequest(username, courseID, blockID):
            let params: [String: any Any & Sendable] = [
                "username": username,
                "course_key": courseID,
                "blocks": [blockID: 1.0]
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case .getHandouts:
            return .requestParameters(encoding: JSONEncoding.default)
        case .getUpdates:
            return .requestParameters(encoding: JSONEncoding.default)
        case .resumeBlock:
            return .requestParameters(encoding: JSONEncoding.default)
        case let .getSubtitles(_, subtitleLanguage):
            //           let languageCode = Locale.current.languageCode ?? "en"
            let params: [String: any Any & Sendable] = [
                "lang": subtitleLanguage
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getCourseDates:
            return .requestParameters(encoding: JSONEncoding.default)
        case .getCourseDeadlineInfo:
            return .requestParameters(encoding: JSONEncoding.default)
        case let .courseDatesReset(courseID):
            return .requestParameters(parameters: ["course_key": courseID], encoding: JSONEncoding.default)
        }
    }
}
