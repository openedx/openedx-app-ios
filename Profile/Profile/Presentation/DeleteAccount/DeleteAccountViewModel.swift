//
//  DeleteAccountViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import Foundation
import Core
import SwiftUI

@MainActor
public final class DeleteAccountViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    @Published var password = ""
    @Published var incorrectPassword: Bool = false
    
    private let interactor: ProfileInteractorProtocol
    public let router: ProfileRouter
    public let connectivity: ConnectivityProtocol
    let analytics: ProfileAnalytics
    
    public init(
        interactor: ProfileInteractorProtocol,
        router: ProfileRouter,
        connectivity: ConnectivityProtocol,
        analytics: ProfileAnalytics
    ) {
        self.interactor = interactor
        self.router = router
        self.connectivity = connectivity
        self.analytics = analytics
    }
    
    @MainActor
    func deleteAccount(password: String) async throws {
        isShowProgress = true
        analytics.profileUserDeleteAccountClicked()
        do {
            if try await interactor.deleteAccount(password: password) {
                isShowProgress = false
                router.showLoginScreen(sourceScreen: .default)
                analytics.profileDeleteAccountSuccess(success: true)
            } else {
                isShowProgress = false
                incorrectPassword = true
                analytics.profileDeleteAccountSuccess(success: false)
            }
        } catch {
            isShowProgress = false
            analytics.profileDeleteAccountSuccess(success: false)
            if error.validationError?.statusCode == 403 {
                incorrectPassword = true
            } else if let validationError = error.validationError,
               let value = validationError.data?["error_code"] as? String,
               value == "user_not_active" {
                errorMessage = CoreLocalization.Error.userNotActive
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}
