//
//  ProfileType.swift
//  Profile
//
//  Created by  Stepanok Ivan on 01.12.2022.
//

import Foundation

public enum ProfileType: Sendable {
    case full
    case limited
    
    public var boolValue: Bool {
        switch self {
        case .full:
            return true
        case .limited:
            return false
        }
    }
    
    public var param: String {
        switch self {
        case .full:
            return "all_users"
        case .limited:
            return "private"
        }
    }
    
    public mutating func toggle() {
        if self == .full {
            self = .limited
        } else {
            self = .full
        }
    }
    
    public var localizedValue: String {
        switch self {
        case .full:
            return ProfileLocalization.fullProfile
        case .limited:
            return ProfileLocalization.limitedProfile
        }
    }
    
    public var switchToButtonTitle: String {
        switch self {
        case .full:
            return ProfileLocalization.limitedProfile
        case .limited:
            return ProfileLocalization.fullProfile
        }
    }
    
    public var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
}
