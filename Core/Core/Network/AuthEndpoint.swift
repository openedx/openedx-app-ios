//
//  AuthEndpoint.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.10.2022.
//

import Foundation
import Alamofire
import OEXFoundation

enum AuthEndpoint: EndPointType {
    case getAccessToken(username: String, password: String, clientId: String, tokenType: String)
    case exchangeAccessToken(externalToken: String, backend: String, clientId: String, tokenType: String)
    case getUserInfo
    case getAuthCookies
    case getRegisterFields
    case validateRegistrationFields([String: String])
    case registerUser([String: String])
    case resetPassword(email: String)

    var path: String {
        switch self {
        case .getAccessToken:
            return "/oauth2/access_token"
        case let .exchangeAccessToken(_, backend, _, _):
            return "/oauth2/exchange_access_token/\(backend)/"
        case .getUserInfo:
            return "/api/mobile/v0.5/my_user_info"
        case .getAuthCookies:
            return "/oauth2/login/"
        case .getRegisterFields:
            return "/user_api/v1/account/registration/"
        case .registerUser:
            return "/user_api/v1/account/registration/"
        case .validateRegistrationFields:
            return "/api/user/v1/validation/registration"
        case .resetPassword:
            return "password_reset/"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .getAccessToken, .exchangeAccessToken:
            return .post
        case .getUserInfo:
            return .get
        case .getAuthCookies:
            return .post
        case .getRegisterFields:
            return .get
        case .registerUser:
            return .post
        case .validateRegistrationFields:
            return .post
        case .resetPassword:
            return .post
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: HTTPTask {
        switch self {
        case let .getAccessToken(username, password, clientId, tokenType):
            let params: [String: Encodable & Sendable] = [
                "grant_type": AuthConstants.GrantTypePassword,
                "client_id": clientId,
                "username": username,
                "password": password,
                "token_type": tokenType,
                "asymmetric_jwt": true
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        case let .exchangeAccessToken(externalToken, _, clientId, tokenType):
            let params: [String: Encodable & Sendable] = [
                "client_id": clientId,
                "token_type": tokenType,
                "access_token": externalToken,
                "asymmetric_jwt": true
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.httpBody)
        case .getUserInfo:
            return .request
        case .getAuthCookies:
            return .requestCookies
        case .getRegisterFields:
            return .request
        case .registerUser(let fields):
            return .requestParameters(parameters: fields, encoding: URLEncoding.httpBody)
        case .validateRegistrationFields(let fields):
            return .requestParameters(parameters: fields, encoding: URLEncoding.httpBody)
        case let .resetPassword(email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.httpBody)
        }
    }
}
