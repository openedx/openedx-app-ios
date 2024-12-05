//
//  UserProfile.swift
//  Core
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation

public struct UserProfile: Hashable, Sendable {
    public let avatarUrl: String
    public let name: String
    public let username: String
    public let dateJoined: Date
    public var yearOfBirth: Int
    public let country: String
    public let spokenLanguage: String?
    public let shortBiography: String
    public let isFullProfile: Bool
    public let email: String
    
    public init(
        avatarUrl: String,
        name: String,
        username: String,
        dateJoined: Date,
        yearOfBirth: Int,
        country: String,
        spokenLanguage: String? = nil,
        shortBiography: String,
        isFullProfile: Bool,
        email: String
    ) {
        self.avatarUrl = avatarUrl
        self.name = name
        self.username = username
        self.dateJoined = dateJoined
        self.yearOfBirth = yearOfBirth
        self.country = country
        self.spokenLanguage = spokenLanguage
        self.shortBiography = shortBiography
        self.isFullProfile = isFullProfile
        self.email = email
    }
    
    public init() {
        self.avatarUrl = ""
        self.name = ""
        self.username = ""
        self.dateJoined = Date()
        self.yearOfBirth = 0
        self.country = ""
        self.spokenLanguage = ""
        self.shortBiography = ""
        self.isFullProfile = true
        self.email = ""
    }
}
