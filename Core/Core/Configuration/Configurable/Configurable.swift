//
//  Configurable.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import Foundation

public enum TokenType: String {
    case jwt = "JWT"
    case bearer = "BEARER"
}

public enum Apps {
    case openEdx
    case edX
}

public protocol Configurable {
    var app: Apps { get }
    var baseURL: URL { get }
    var oAuthClientId: String { get }
    var tokenType: TokenType { get }
    var termsOfService: URL? { get }
    var privacyPolicy: URL? { get }
    var feedbackEmail: String { get }
}
