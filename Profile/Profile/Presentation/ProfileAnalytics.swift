//
//  ProfileAnalytics.swift
//  Profile
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol ProfileAnalytics {
    func profileEditClicked()
    func profileEditDoneClicked()
    func profileDeleteAccountClicked()
    func profileVideoSettingsClicked()
    func privacyPolicyClicked()
    func cookiePolicyClicked()
    func emailSupportClicked()
    func userLogout(force: Bool)
}

#if DEBUG
class ProfileAnalyticsMock: ProfileAnalytics {
    public func profileEditClicked() {}
    public func profileEditDoneClicked() {}
    public func profileDeleteAccountClicked() {}
    public func profileVideoSettingsClicked() {}
    public func privacyPolicyClicked() {}
    public func cookiePolicyClicked() {}
    public func emailSupportClicked() {}
    public func userLogout(force: Bool) {}
}
#endif
