//
//  Validator.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

public class Validator {
    
    private let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    private lazy var emailPredicate = {
        NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    }()
    
    public init() {
    }
    
    public func isValidEmail(_ email: String) -> Bool {
        return emailPredicate.evaluate(with: email)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        return password.count >= 2
    }
    
    public func isValidUsername(_ username: String) -> Bool {
        return username.count >= 2 && username.count <= 30
    }
    
}
