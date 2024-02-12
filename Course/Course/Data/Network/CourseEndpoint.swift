//
//  CourseEndpoint.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 26.09.2022.
//

import Foundation
import Core
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

    var path: String {
        switch self {
        case .getCourseBlocks:
            return "/api/mobile/v3/course_info/blocks/"
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
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: HTTPTask {
        switch self {
        case let .getCourseBlocks(courseID, userName):
            let params: [String: Encodable] = [
                "username": userName,
                "course_id": courseID,
                "depth": "all",
                "student_view_data": "video,discussion,html",
                "nav_depth": "4",
                "requested_fields": """
                contains_gated_content,show_gated_sections,special_exam_info,graded,
                format,student_view_multi_device,due,completion
                """,
                "block_counts": "video"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .pageHTML:
            return .request
        case let .blockCompletionRequest(username, courseID, blockID):
            let params: [String: Any] = [
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
            let params: [String: Any] = [
                "lang": subtitleLanguage
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        case .getCourseDates:
            return .requestParameters(encoding: JSONEncoding.default)
        }
    }
}
