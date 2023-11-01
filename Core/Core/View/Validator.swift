//
//  Validator.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

public class Validator {
    
    private let emailRegEx = ".+@.+\\..+"
    private lazy var emailPredicate = {
        NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    }()
    
    public init() {
    }
    
    public func isValidEmail(_ string: String) -> Bool {
        return emailPredicate.evaluate(with: string)
    }
    
    public func isValidPassword(_ password: String) -> Bool {
        return password.count >= 2
    }
}
