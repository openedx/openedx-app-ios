//
//  ResetPassword.swift
//  Core
//
//  Created by  Stepanok Ivan on 02.12.2022.
//

import Foundation

public struct ResetPassword: Sendable {
    public let success: Bool
    public let responseText: String
    
    public init(success: Bool, responseText: String) {
        self.success = success
        self.responseText = responseText
    }
}

public extension DataLayer.ResetPassword {
    var domain: ResetPassword {
        .init(success: success, responseText: value)
    }
}
