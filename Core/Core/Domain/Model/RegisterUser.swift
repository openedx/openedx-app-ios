//
//  RegisterUser.swift
//  Core
//
//  Created by  Stepanok Ivan on 25.10.2022.
//

import Foundation

public struct RegisterUser {
    public let fullName: String
    public let publicUsername: String
    public let email: String
    public let password: String
    public let gender: String
    public let yearOfBirth: String
    public let educationLevel: String
    public let tellUsWhyInterested: String
    public let selectedCountry: String
    
    public init(fullName: String, publicUsername: String, email: String, password: String,
                gender: String, yearOfBirth: String, educationLevel: String,
                tellUsWhyInterested: String, selectedCountry: String) {
        self.fullName = fullName
        self.publicUsername = publicUsername
        self.email = email
        self.password = password
        self.gender = gender
        self.yearOfBirth = yearOfBirth
        self.educationLevel = educationLevel
        self.tellUsWhyInterested = tellUsWhyInterested
        self.selectedCountry = selectedCountry
    }
}
