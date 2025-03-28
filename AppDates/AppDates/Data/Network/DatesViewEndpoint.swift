//
//  DatesViewEndpoint.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation
import Core
import Alamofire
import OEXFoundation

enum DatesViewEndpoint: EndPointType {
    case getCourseDates(username: String, page: Int)
    case resetAllRelativeCourseDeadlines
    
    var path: String {
        switch self {
        case let .getCourseDates(username, _):
            return "/api/mobile/v3/course_dates/\(username)/"
        case .resetAllRelativeCourseDeadlines:
            return "/api/course_experience/v1/reset_all_relative_course_deadlines/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCourseDates:
            return .get
        case .resetAllRelativeCourseDeadlines:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case let .getCourseDates(_, page):
            let params: Parameters = [
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case .resetAllRelativeCourseDeadlines:
            return .request
        }
    }
}
