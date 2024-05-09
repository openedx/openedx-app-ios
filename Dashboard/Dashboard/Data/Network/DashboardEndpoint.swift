//
//  DashboardEndpoint.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core
import Alamofire

enum DashboardEndpoint: EndPointType {
    case getMyCourses(username: String, page: Int)
    case getMyLearnCourses(username: String, pageSize: Int)
    case getAllCourses(username: String, filteredBy: String, page: Int)
    
    var path: String {
        switch self {
        case let .getMyCourses(username, _):
            return "/api/mobile/v3/users/\(username)/course_enrollments"
        case let .getMyLearnCourses(username, _):
            return "/api/mobile/v4/users/\(username)/course_enrollments"
        case let .getAllCourses(username, _, _):
            return "/api/mobile/v4/users/\(username)/course_enrollments"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getMyCourses, .getMyLearnCourses, .getAllCourses:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case let .getMyCourses(_, page):
            let params: Parameters = [
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case let .getMyLearnCourses(_, pageSize):
            let params: Parameters = [
                "page_size": pageSize
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case let .getAllCourses(_, filteredBy, page):
            let params: Parameters = [
                "page_size": 10,
                "status": filteredBy,
                "requested_fields": "course_progress",
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
