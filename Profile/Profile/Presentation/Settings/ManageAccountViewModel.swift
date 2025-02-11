//
//  ManageAccountViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 10.04.2024.
//

import Foundation
import Core
import SwiftUI

@MainActor
public final class ManageAccountViewModel: ObservableObject {
    
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
    let analytics: ProfileAnalytics
    let config: ConfigProtocol
    let connectivity: ConnectivityProtocol
    private let interactor: ProfileInteractorProtocol
    
    public init(
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        config: ConfigProtocol,
        connectivity: ConnectivityProtocol,
        interactor: ProfileInteractorProtocol
    ) {
        self.router = router
        self.analytics = analytics
        self.config = config
        self.connectivity = connectivity
        self.interactor = interactor
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
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    func trackProfileDeleteAccountClicked() {
        analytics.profileDeleteAccountClicked()
    }
    
    func trackProfileEditClicked() {
        analytics.profileEditClicked()
    }
}
