//
//  SettingsViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import Foundation
import Core
import SwiftUI
import Combine

@MainActor
public final class SettingsViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var wifiOnly: Bool {
        willSet {
            if newValue != wifiOnly {
                userSettings.wifiOnly = newValue
                Task {
                    await interactor.saveSettings(userSettings)
                }
            }
        }
    }
    
    @Published var selectedQuality: StreamingQuality {
        willSet {
            if newValue != selectedQuality {
                userSettings.streamingQuality = newValue
                Task {
                    await interactor.saveSettings(userSettings)
                }
            }
        }
    }

    let quality = Array(
        [
            StreamingQuality.auto,
            StreamingQuality.low,
            StreamingQuality.medium,
            StreamingQuality.high
        ]
        .enumerated()
    )
    
    enum VersionState {
        case actual
        case updateNeeded
        case updateRequired
    }
    
    @Published var versionState: VersionState = .actual
    @Published var currentVersion: String = ""
    @Published var latestVersion: String = ""

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    @Published private(set) var userSettings: UserSettings
    
    private var cancellables = Set<AnyCancellable>()

    private let interactor: ProfileInteractorProtocol
    private let downloadManager: DownloadManagerProtocol
    let router: ProfileRouter
    let analytics: ProfileAnalytics
    let coreAnalytics: CoreAnalytics
    let config: ConfigProtocol
    let corePersistence: CorePersistenceProtocol
    let connectivity: ConnectivityProtocol
    
    public init(
        interactor: ProfileInteractorProtocol,
        downloadManager: DownloadManagerProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        coreAnalytics: CoreAnalytics,
        config: ConfigProtocol,
        corePersistence: CorePersistenceProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.interactor = interactor
        self.downloadManager = downloadManager
        self.router = router
        self.analytics = analytics
        self.coreAnalytics = coreAnalytics
        self.config = config
        self.corePersistence = corePersistence
        self.connectivity = connectivity
        
        let userSettings = interactor.getSettings()
        self.userSettings = userSettings
        self.wifiOnly = userSettings.wifiOnly
        self.selectedQuality = userSettings.streamingQuality
        generateVersionState()
    }
    
    func generateVersionState() {
        guard let info = Bundle.main.infoDictionary else { return }
        guard let currentVersion = info["CFBundleShortVersionString"] as? String else { return }
        self.currentVersion = currentVersion
        NotificationCenter.default.publisher(for: .onActualVersionReceived)
            .sink { [weak self] notification in
                guard let latestVersion = notification.object as? String else { return }
                Task {
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

    func update(downloadQuality: DownloadQuality) async {
        self.userSettings.downloadQuality = downloadQuality
        await interactor.saveSettings(userSettings)
    }
    
    func openAppStore() {
        guard let appStoreURL = URL(string: config.appStoreLink) else { return }
        UIApplication.shared.open(appStoreURL)
    }
    
    func logOut() async {
        try? await interactor.logOut()
        try? await downloadManager.cancelAllDownloading()
        await corePersistence.deleteAllProgress()
        router.showStartupScreen()
        analytics.userLogout(force: false)
        NotificationCenter.default.post(
            name: .userLoggedOut,
            object: nil,
            userInfo: [Notification.UserInfoKey.isForced: false]
        )
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
    
    func trackTOSClicked() {
        analytics.tosClicked()
    }
    
    func trackFAQClicked() {
        analytics.faqClicked()
    }
    
    func trackDataSellClicked() {
        analytics.dataSellClicked()
    }
    
    func trackPrivacyPolicyClicked() {
        analytics.privacyPolicyClicked()
    }
    
    func trackProfileEditClicked() {
        analytics.profileEditClicked()
    }
    
    func trackLogoutClickedClicked() {
        analytics.profileTrackEvent(.userLogoutClicked, biValue: .userLogoutClicked)
    }
    
}

public extension StreamingQuality {
    
    func title() -> String {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.qualityAutoTitle
        case .low:
            return ProfileLocalization.Settings.quality360Title
        case .medium:
            return ProfileLocalization.Settings.quality540Title
        case .high:
            return ProfileLocalization.Settings.quality720Title
        }
    }
    
    func description() -> String? {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.qualityAutoDescription
        case .low:
            return ProfileLocalization.Settings.quality360Description
        case .medium:
            return nil
        case .high:
            return ProfileLocalization.Settings.quality720Description
        }
    }
    
    func settingsDescription() -> String {
        switch self {
        case .auto:
            return ProfileLocalization.Settings.qualityAutoTitle + " ("
            + ProfileLocalization.Settings.qualityAutoDescription + ")"
        case .low:
            return ProfileLocalization.Settings.quality360Title + " ("
            + ProfileLocalization.Settings.quality360Description + ")"
        case .medium:
            return ProfileLocalization.Settings.quality540Title
        case .high:
            return ProfileLocalization.Settings.quality720Title + " ("
            + ProfileLocalization.Settings.quality720Description + ")"
        }
    }
}
