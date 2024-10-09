//
//  SSOHelper.swift
//  Authorization
//
//  Created by Rawan Matar on 02/06/2024.
//

import Foundation

// https://developer.apple.com/documentation/ios-ipados-release-notes/foundation-release-notes

/**
    A Helper for some of the SSO preferences.
    Keeps data under the UserDefaults.
 */
public class SSOHelper: NSObject {

    public enum UserDefaultKeys: String, CaseIterable {
        case cookiePayload
        case cookieSignature
        case userInfo
        
        var description: String {
            switch self {
            case .cookiePayload:
                return "edx-jwt-cookie-header-payload"
            case .cookieSignature:
                return "edx-jwt-cookie-signature"
            case .userInfo:
                return "edx-user-info"
            }
        }
    }

    // MARK: - Singleton
    
    public static let shared = SSOHelper()
            
    // MARK: - Public Properties
    
    /// Authentication
    public var cookiePayload: String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: UserDefaultKeys.cookiePayload.rawValue)
        }
        set (newValue) {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserDefaultKeys.cookiePayload.rawValue)
        }
    }

    /// Authentication
    public var cookieSignature: String? {
        get {
            let defaults = UserDefaults.standard
            return defaults.string(forKey: UserDefaultKeys.cookieSignature.rawValue)
        }
        set (newValue) {
            let defaults = UserDefaults.standard
            defaults.set(newValue, forKey: UserDefaultKeys.cookieSignature.rawValue)
        }
    }
    
    // MARK: - Public Methods
    
    /// Checks if the user is login.
    public func cleanAfterSuccesfulLogout() {
        cookiePayload = nil
        cookieSignature = nil
    }
}

