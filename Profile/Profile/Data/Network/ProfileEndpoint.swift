//
//  ProfileEndpoint.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation
import Core
import OEXFoundation
import Alamofire

enum ProfileEndpoint: EndPointType {
    case getUserProfile(username: String)
    case updateUserProfile(username: String, parameters: [String: any Any & Sendable])
    case uploadProfilePicture(username: String, pictureData: Data)
    case deleteProfilePicture(username: String)
    case logOut(refreshToken: String, clientID: String)
    case deleteAccount(password: String)
    case enrollmentsStatus(username: String)
    case getCourseDates(courseID: String)

    var path: String {
        switch self {
        case let .getUserProfile(username):
            return "/api/user/v1/accounts/\(username)"
        case .logOut:
            return "/oauth2/revoke_token/"
        case let .updateUserProfile(username, _):
            return "/api/user/v1/accounts/\(username)"
        case let .uploadProfilePicture(username, _):
            return "/api/user/v1/accounts/\(username)/image"
        case let .deleteProfilePicture(username):
            return "/api/user/v1/accounts/\(username)/image"
        case .deleteAccount:
            return "/api/user/v1/accounts/deactivate_logout/"
        case let .enrollmentsStatus(username):
            return "/api/mobile/v1/users/\(username)/enrollments_status/"
        case let .getCourseDates(courseID):
            return "/api/course_home/v1/dates/\(courseID)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .getUserProfile, .enrollmentsStatus, .getCourseDates:
            return .get
        case .logOut:
            return .post
        case .updateUserProfile:
            return .patch
        case .uploadProfilePicture:
            return .post
        case .deleteProfilePicture:
            return .delete
        case .deleteAccount:
            return .post
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .updateUserProfile:
            return ["Content-Type": "application/merge-patch+json"]
        case .uploadProfilePicture:
            return ["Content-Disposition": "attachment;filename=filename.jpg"]
        default:
            return nil
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .getUserProfile:
            return .request
        case let .logOut(refreshToken, clientID):
            let params: [String: String] = [
                "token": refreshToken,
                "client_id": clientID,
                "token_type_hint": "refresh_token"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        case let .updateUserProfile(_, parameters):
            return .requestParameters(parameters: parameters, encoding: JSONEncoding.default)
        case let .uploadProfilePicture(_, pictureData):
            return .upload(pictureData)
        case let .deleteProfilePicture(username):
            let params: [String: String] = [
                "username": username
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        case let .deleteAccount(password):
            let params: [String: String] = [
                "password": password
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        case .enrollmentsStatus:
            return .requestParameters(parameters: nil, encoding: JSONEncoding.default)
        case .getCourseDates:
            return .requestParameters(encoding: JSONEncoding.default)
        }
    }
}
