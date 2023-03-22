//
//  Data_ResetPassword.swift
//  Core
//
//  Created by  Stepanok Ivan on 02.12.2022.
//

import Foundation

extension DataLayer {
    public struct ResetPassword: Codable {
        let success: Bool
        let value: String
    }
}
