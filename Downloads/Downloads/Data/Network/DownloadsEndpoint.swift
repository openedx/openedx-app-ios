//
//  DownloadsEndpoint.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Core
import Alamofire
import OEXFoundation

enum DownloadsEndpoint: EndPointType {
    case getDownloadCourses(username: String)
    
    var path: String {
        switch self {
        case .getDownloadCourses(let username):
            return "/api/mobile/v1/download_courses/\(username)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getDownloadCourses:
            return .get
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case .getDownloadCourses:
            return .request
        }
    }
}
