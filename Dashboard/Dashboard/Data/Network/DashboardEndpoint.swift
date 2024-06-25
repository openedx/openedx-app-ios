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
    case getEnrollments(username: String, page: Int)
    case getPrimaryEnrollment(username: String, pageSize: Int)
    case getAllCourses(username: String, filteredBy: String, page: Int)
    
    var path: String {
        switch self {
        case let .getEnrollments(username, _):
            return "/api/mobile/v3/users/\(username)/course_enrollments"
        case let .getPrimaryEnrollment(username, _):
            return "/api/mobile/v4/users/\(username)/course_enrollments"
        case let .getAllCourses(username, _, _):
            return "/api/mobile/v4/users/\(username)/course_enrollments"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getEnrollments, .getPrimaryEnrollment, .getAllCourses:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case let .getEnrollments(_, page):
            let params: Parameters = [
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
            
        case let .getPrimaryEnrollment(_, pageSize):
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
