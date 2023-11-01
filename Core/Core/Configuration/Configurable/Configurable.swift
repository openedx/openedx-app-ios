//
//  Configurable.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import Foundation
import FirebaseCore
import Swinject

public enum Apps {
    case openEdx
    case edX
}

public enum TokenType: String {
    case jwt = "JWT"
    case bearer = "BEARER"
}

public enum BuildConfiguration: String {
    case debugDev = "DebugDev"
    case releaseDev = "ReleaseDev"

    case debugStage = "DebugStage"
    case releaseStage = "ReleaseStage"

    case debugProd = "DebugProd"
    case releaseProd = "ReleaseProd"
}

public protocol AppDelegateConfigurable {
    var assembler: Assembler? { get }
    func didFinishLaunching()
}

public protocol AppConfiguratable {
    var app: Apps { get }
    var environment: BuildConfiguration { get }
    var baseURL: URL { get }
    var oAuthClientId: String { get }
    var tokenType: TokenType { get }
    var firebaseOptions: FirebaseOptions? { get }
}

public protocol Configurable: AppConfiguratable {
    var socialLoginEnable: Bool { get }
    var termsOfService: URL? { get }
    var privacyPolicy: URL? { get }
    var feedbackEmail: String { get }
}
