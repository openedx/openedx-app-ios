//
//  DiscoveryEndpoint.swift
//  Discovery
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation
import Core
import Alamofire

enum DiscoveryEndpoint: EndPointType {
    case getDiscovery(username: String, page: Int)
    case searchCourses(username: String, page: Int, searchTerm: String)
    
    var path: String {
        switch self {
        case .getDiscovery:
            return "/api/courses/v1/courses/"
        case .searchCourses:
            return "/api/courses/v1/courses/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getDiscovery, .searchCourses:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case let .getDiscovery(_, page):
            let params: Parameters = [
//                "username": username,
                "mobile": true,
                "permissions": ["enroll", "see_about_page", "see_in_catalog"],
                "page": page
            ]
            return .requestParameters(parameters: params, encoding: CustomGetEncoding())
            
        case let .searchCourses(username, page, searchTerm):
            let params: Parameters = [
                "username": username,
                "mobile": true,
                "mobile_search": true,
                "page": page,
                "search_term": searchTerm
            ]
            
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
