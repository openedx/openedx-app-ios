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
    case getMyCourses(username: String)

    var path: String {
        switch self {
        case .getMyCourses(let username):
            return "/api/mobile/v1/users/\(username)/course_enrollments/"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getMyCourses:
            return .get
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: HTTPTask {
        switch self {
        case .getMyCourses:
            return .request
        }
    }
}
