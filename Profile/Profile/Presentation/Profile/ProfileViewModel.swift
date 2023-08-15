//
//  ProfileViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Foundation
import Core
import SwiftUI

public class ProfileViewModel: ObservableObject {
    
    @Published public var userModel: UserProfile?
    @Published public var updatedAvatar: UIImage?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    
    let router: ProfileRouter
    let config: Config
    let connectivity: ConnectivityProtocol
    
    private let interactor: ProfileInteractorProtocol
    private let analytics: ProfileAnalytics
    
    public init(
        interactor: ProfileInteractorProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        config: Config,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
        self.connectivity = connectivity
    }
    
    func contactSupport() -> URL? {
        let osVersion = UIDevice.current.systemVersion
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let deviceModel = UIDevice.current.model
        let feedbackDetails = "OS version: \(osVersion)\nApp version: \(appVersion)\nDevice model: \(deviceModel)"
        
        let recipientAddress = config.feedbackEmail
        let emailSubject = "Feedback"
        let emailBody = "\n\n\(feedbackDetails)\n".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let emailURL = URL(string: "mailto:\(recipientAddress)?subject=\(emailSubject)&body=\(emailBody)")
        return emailURL
    }
    
    @MainActor
    func getMyProfile(withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            if connectivity.isInternetAvaliable {
                userModel = try await interactor.getMyProfile()
                isShowProgress = false
            } else {
                userModel = try interactor.getMyProfileOffline()
                isShowProgress = false
            }
        } catch let error {
            isShowProgress = false
            if error.isInternetError || error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            
        }
    }
    
    @MainActor
    func logOut() async {
        do {
            try await interactor.logOut()
            router.showLoginScreen()
            analytics.userLogout(force: false)
        } catch let error {
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func trackProfileVideoSettingsClicked() {
        analytics.profileVideoSettingsClicked()
    }
    
    func trackEmailSupportClicked() {
        analytics.emailSupportClicked()
    }
    
    func trackCookiePolicyClicked() {
        analytics.cookiePolicyClicked()
    }
    
    func trackPrivacyPolicyClicked() {
        analytics.privacyPolicyClicked()
    }
    
    func trackProfileEditClicked() {
        analytics.profileEditClicked()
    }
}
