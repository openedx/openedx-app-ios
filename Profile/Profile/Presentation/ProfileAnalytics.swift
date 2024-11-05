//
//  ProfileAnalytics.swift
//  Profile
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation
import Core
import OEXFoundation

//sourcery: AutoMockable
public protocol ProfileAnalytics {
    func profileEditClicked()
    func profileSwitch(action: String)
    func profileEditDoneClicked()
    func profileDeleteAccountClicked()
    func profileVideoSettingsClicked()
    func privacyPolicyClicked()
    func cookiePolicyClicked()
    func emailSupportClicked()
    func faqClicked()
    func tosClicked()
    func dataSellClicked()
    func userLogout(force: Bool)
    func profileWifiToggle(action: String)
    func profileUserDeleteAccountClicked()
    func profileDeleteAccountSuccess(success: Bool)
    func profileTrackEvent(_ event: AnalyticsEvent, biValue: EventBIValue)
    func profileScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue)
}

#if DEBUG
class ProfileAnalyticsMock: ProfileAnalytics {
    public func profileEditClicked() {}
    public func profileSwitch(action: String) {}
    public func profileEditDoneClicked() {}
    public func profileDeleteAccountClicked() {}
    public func profileVideoSettingsClicked() {}
    public func privacyPolicyClicked() {}
    public func cookiePolicyClicked() {}
    public func emailSupportClicked() {}
    public func faqClicked() {}
    public func tosClicked() {}
    public func dataSellClicked() {}
    public func userLogout(force: Bool) {}
    public func profileWifiToggle(action: String) {}
    public func profileUserDeleteAccountClicked() {}
    public func profileDeleteAccountSuccess(success: Bool) {}
    public func profileTrackEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {}
    public func profileScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {}
}
#endif
