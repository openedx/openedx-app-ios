//
//  Environment.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Core

enum `Environment`: String {
    case debugDev = "DebugDev"
    case releaseDev = "ReleaseDev"
    
    case debugStage = "DebugStage"
    case releaseStage = "ReleaseStage"
    
    case debugProd = "DebugProd"
    case releaseProd = "ReleaseProd"
}
