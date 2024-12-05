//
//  NotificationsEndpoints.swift
//  OpenEdX
//
//  Created by Volodymyr Chekyrta on 21.05.24.
//

import Foundation
import Core
import OEXFoundation
import Alamofire

enum NotificationsEndpoints: EndPointType {
    
    case syncFirebaseToken(token: String)
    
    var path: String {
        switch self {
        case .syncFirebaseToken:
            return "/api/mobile/v4/notifications/create-token/"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .syncFirebaseToken:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var task: HTTPTask {
        switch self {
        case let .syncFirebaseToken(token):
            let params: [String: Encodable & Sendable] = [
                "registration_id": token,
                "active": true
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        }
    }
}
