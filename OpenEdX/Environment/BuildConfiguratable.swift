//
//  BuildEnvironmentProtocol.swift
//  OpenEdX
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import Foundation
import Core
import FirebaseCore

enum `Environment`: String {
    case debugDev = "DebugDev"
    case releaseDev = "ReleaseDev"

    case debugStage = "DebugStage"
    case releaseStage = "ReleaseStage"

    case debugProd = "DebugProd"
    case releaseProd = "ReleaseProd"
}

protocol BuildConfiguratable {
    var environment: Environment { get }
    var baseURL: String { get }
    var clientId: String { get }
    var firebaseOptions: FirebaseOptions? { get }
}
