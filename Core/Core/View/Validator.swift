//
//  Validator.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

public class Validator {
    
    private let usernameOrEmailRegex = "^([a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.com|[a-zA-Z0-9._%+-]+)$"
    private lazy var usernameOrEmailPredicate = {
        NSPredicate(format: "SELF MATCHES %@", usernameOrEmailRegex)
    }()
    
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private lazy var emailPredicate = {
        NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    }()
    
    public init() {
    }
    
    public func isValidUsernameOrEmail(_ string: String) -> Bool {
        return usernameOrEmailPredicate.evaluate(with: string)
    }
    
    public func isValidEmail(_ string: String) -> Bool {
        return emailPredicate.evaluate(with: string)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        return password.count >= 2
    }
}
