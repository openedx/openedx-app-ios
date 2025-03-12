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
    
    var path: String {
        switch self {
        case let .getCourseDates(username, _):
            return "/api/mobile/v3/course_dates/\(username)/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getCourseDates:
            return .get
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
        }
    }
}
