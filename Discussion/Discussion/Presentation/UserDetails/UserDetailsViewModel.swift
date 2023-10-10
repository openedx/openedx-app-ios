//
//  UserDetailsViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 10.10.2023.
//

import Core
import SwiftUI

public class UserDetailsViewModel: ObservableObject {
    
    @Published public var userModel: UserProfile?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let username: String
        
    private let interactor: DiscussionInteractorProtocol
    private let analytics: DiscussionAnalytics
    
    public init(
        interactor: DiscussionInteractorProtocol,
        analytics: DiscussionAnalytics,
        username: String
    ) {
        self.interactor = interactor
        self.analytics = analytics
        self.username = username
    }
    
    @MainActor
    func getUserProfile(withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            userModel = try await interactor.getUserProfile(username: username)
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            
        }
    }
    
//    @MainActor
//    func logOut() async {
//        do {
//            try await interactor.logOut()
//            router.showLoginScreen()
//            analytics.userLogout(force: false)
//        } catch let error {
//            if error.isInternetError {
//                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
//            } else {
//                errorMessage = CoreLocalization.Error.unknownError
//            }
//        }
//    }
//    
//    func trackProfileVideoSettingsClicked() {
//        analytics.profileVideoSettingsClicked()
//    }
//    
//    func trackEmailSupportClicked() {
//        analytics.emailSupportClicked()
//    }
//    
//    func trackCookiePolicyClicked() {
//        analytics.cookiePolicyClicked()
//    }
//    
//    func trackPrivacyPolicyClicked() {
//        analytics.privacyPolicyClicked()
//    }
//    
//    func trackProfileEditClicked() {
//        analytics.profileEditClicked()
//    }
}
