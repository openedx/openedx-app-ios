//
//  SSOHelper.swift
//  Authorization
//
//  Created by Rawan Matar on 02/06/2024.
//

import Foundation
import KeychainSwift

// https://developer.apple.com/documentation/ios-ipados-release-notes/foundation-release-notes

/**
    A Helper for some of the SSO preferences.
    Keeps data under the UserDefaults.
 */
public final class SSOHelper: NSObject {

    private let keychain: KeychainSwift
    public enum SSOHelperKeys: String, CaseIterable {
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
    
    public init(keychain: KeychainSwift) {
        self.keychain = keychain
    }
    // MARK: - Public Properties
    
    /// Authentication
    public var cookiePayload: String? {
        get {
            let defaults = UserDefaults.standard
            return keychain.get(SSOHelperKeys.cookiePayload.rawValue)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: SSOHelperKeys.cookiePayload.rawValue)
            } else {
                keychain.delete(SSOHelperKeys.cookiePayload.rawValue)
            }
        }
    }

    /// Authentication
    public var cookieSignature: String? {
        get {
            let defaults = UserDefaults.standard
            return keychain.get(SSOHelperKeys.cookieSignature.rawValue)
        }
        set(newValue) {
            if let newValue {
                keychain.set(newValue, forKey: SSOHelperKeys.cookieSignature.rawValue)
            } else {
                keychain.delete(SSOHelperKeys.cookieSignature.rawValue)
            }
        }
    }
    
    // MARK: - Public Methods
    
    /// Checks if the user is login.
    public func cleanAfterSuccesfulLogout() {
        cookiePayload = nil
        cookieSignature = nil
    }
}
