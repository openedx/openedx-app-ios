//
//  ProfileViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import Combine
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

    private var cancellables = Set<AnyCancellable>()
    
    enum VersionState {
        case actual
        case updateNeeded
        case updateRequired
    }
    
    @Published var versionState: VersionState = .actual
    @Published var currentVersion: String = ""
    @Published var latestVersion: String = ""
    
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
        generateVersionState()
    }
    
    func openAppStore() {
        guard let appStoreURL = URL(string: config.appStoreLink) else { return }
        UIApplication.shared.open(appStoreURL)
    }
    
    func generateVersionState() {
        guard let info = Bundle.main.infoDictionary else { return }
        guard let currentVersion = info["CFBundleShortVersionString"] as? String else { return }
        self.currentVersion = currentVersion
        NotificationCenter.default.publisher(for: .onActualVersionReceived)
            .sink { [weak self] notification in
                guard let latestVersion = notification.object as? String else { return }
                DispatchQueue.main.async { [weak self] in
                    self?.latestVersion = latestVersion
                    
                    if latestVersion != currentVersion {
                        self?.versionState = .updateNeeded
                    }
                }
            }.store(in: &cancellables)
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
        do {
            let userModel = interactor.getMyProfileOffline()
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
            if error.isUpdateRequeiredError {
                self.versionState = .updateRequired
            } else if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
    
    @MainActor
    func logOut() async {
        try? await interactor.logOut()
        router.showLoginScreen()
        analytics.userLogout(force: false)
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
