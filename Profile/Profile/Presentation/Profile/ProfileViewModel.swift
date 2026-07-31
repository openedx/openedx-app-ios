//
//  ProfileViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Combine
import Core
import SwiftUI

@MainActor
@Observable
public final class ProfileViewModel {

    public var userModel: UserProfile?
    public var updatedAvatar: UIImage?
    private(set) var isShowProgress = false
    var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let router: ProfileRouter
    let config: ConfigProtocol
    let connectivity: ConnectivityProtocol
    
    private let interactor: ProfileInteractorProtocol
    private let analytics: ProfileAnalytics
    
    public init(
        interactor: ProfileInteractorProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        config: ConfigProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
        self.connectivity = connectivity
    }
      
    @MainActor
    public func getMyProfile(withProgress: Bool = true) async {
        do {
            let userModel = await interactor.getMyProfileOffline()
            if userModel == nil && connectivity.isInternetAvaliable {
                isShowProgress = withProgress
            } else {
                self.userModel = userModel
            }
            if connectivity.isInternetAvaliable {
                self.userModel = try await interactor.getMyProfile()
            }
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else if error.isUpdateRequeiredError {
                return
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func trackProfileEditClicked() {
        analytics.profileEditClicked()
    }
}
