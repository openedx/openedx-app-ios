//
//  Data_MyProfile.swift
//  Core
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation

// MARK: "api/user/v1/accounts/\(username)"

// MARK: - UserProfile
public extension DataLayer {
    struct UserProfile: Codable, Sendable {
        public let id: Int?
        public let accountPrivacy: AccountPrivacy?
        public let profileImage: ProfileImage?
        public let username: String?
        public let bio: String?
        public let country: String?
        public let dateJoined: String?
        public let languageProficiencies: [LanguageProficiency]?
        public let levelOfEducation: String?
        public let socialLinks: [SocialLink]?
        public let accomplishmentsShared: Bool?
        public let name: String?
        public let email: String?
        public let gender: String?
        public let state: String?
        public let goals: String?
        public let isActive: Bool?
        public let lastLogin: String?
        public let mailingAddress: String?
        public let requiresParentalConsent: Bool?
        public let yearOfBirth: Int?
        public let phoneNumber: String?
        public let activationKey: String?
        public let isVerifiedNameEnabled: Bool?
        
        enum CodingKeys: String, CodingKey {
            case accountPrivacy = "account_privacy"
            case profileImage = "profile_image"
            case username
            case bio
            case country
            case dateJoined = "date_joined"
            case languageProficiencies = "language_proficiencies"
            case levelOfEducation = "level_of_education"
            case socialLinks = "social_links"
            case accomplishmentsShared = "accomplishments_shared"
            case name
            case email
            case id
            case gender
            case state
            case goals
            case isActive = "is_active"
            case lastLogin = "last_login"
            case mailingAddress = "mailing_address"
            case requiresParentalConsent = "requires_parental_consent"
            case yearOfBirth = "year_of_birth"
            case phoneNumber = "phone_number"
            case activationKey = "activation_key"
            case isVerifiedNameEnabled = "is_verified_name_enabled"
        }
    }
}

// MARK: - AccountPrivacy
public enum AccountPrivacy: String, Codable, Sendable {
    case privateAccess = "private"
    case allUsers = "all_users"
    case allUsersBig = "ALL_USERS"
    
    public var boolValue: Bool {
        switch self {
        case .privateAccess:
            return false
        case .allUsers, .allUsersBig:
            return true
        }
    }
}

// MARK: - LanguageProficiency
public extension DataLayer {
    struct LanguageProficiency: Codable, Sendable {
        public let code: String
    }
}

// MARK: - ProfileImage
public extension DataLayer {
    struct ProfileImage: Codable, Sendable {
        public let hasImage: Bool?
        public let imageURLFull: String?
        public let imageURLLarge: String?
        public let imageURLMedium: String?
        public let imageURLSmall: String?
        
        enum CodingKeys: String, CodingKey {
            case hasImage = "has_image"
            case imageURLFull = "image_url_full"
            case imageURLLarge = "image_url_large"
            case imageURLMedium = "image_url_medium"
            case imageURLSmall = "image_url_small"
        }
    }
}

// MARK: - SocialLink
public extension DataLayer {
    struct SocialLink: Codable, Sendable {
        public let platform: String
        public let socialLink: String
        
        enum CodingKeys: String, CodingKey {
            case platform
            case socialLink = "social_link"
        }
    }
}

public extension DataLayer.UserProfile {
    
    var domain: UserProfile {
        UserProfile(
            avatarUrl: profileImage?.imageURLFull ?? "",
            name: name ?? "",
            username: username ?? "",
            dateJoined: Date(iso8601: dateJoined ?? ""),
            yearOfBirth: yearOfBirth ?? 0,
            country: country ?? "",
            spokenLanguage: languageProficiencies?[safe: 0]?.code ?? "",
            shortBiography: bio ?? "",
            isFullProfile: accountPrivacy?.boolValue ?? true,
            email: email ?? "")
    }
}
