//
//  BuildEnvironmentProtocol.swift
//  OpenEdX
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import Foundation
import Core
import FirebaseCore

protocol BuildEnvironmentProtocol {
    var environment: Environment { get }
    var baseURL: String { get }
    var clientId: String { get }

    var firebaseOptions: FirebaseOptions? { get }
}
