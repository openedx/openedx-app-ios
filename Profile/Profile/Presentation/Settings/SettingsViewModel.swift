//
//  SettingsViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
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
    
    private let interactor: ProfileInteractorProtocol
    private let downloadManager: DownloadManagerProtocol
    let router: ProfileRouter
    let analytics: ProfileAnalytics
    let coreAnalytics: CoreAnalytics
    let config: ConfigProtocol
    let corePersistence: CorePersistenceProtocol
    let connectivity: ConnectivityProtocol
    var storage: ProfileStorage
    
    public init(
        interactor: ProfileInteractorProtocol,
        downloadManager: DownloadManagerProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        coreAnalytics: CoreAnalytics,
        config: ConfigProtocol,
        corePersistence: CorePersistenceProtocol,
        connectivity: ConnectivityProtocol,
        storage: ProfileStorage
    ) {
        self.interactor = interactor
        self.downloadManager = downloadManager
        self.router = router
        self.analytics = analytics
        self.coreAnalytics = coreAnalytics
        self.config = config
        self.corePersistence = corePersistence
        self.connectivity = connectivity
        self.storage = storage
        
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
        
        guard !storage.updateRequired else {
            self.versionState = .updateRequired
            return
        }
        
        if let latestVersion = storage.latestVersion {
            self.latestVersion = latestVersion
            
            if isVersion(latestVersion, greaterThan: currentVersion) {
                self.versionState = .updateNeeded
            }
        }
    }
    
    func isVersion(_ version1: String, greaterThan version2: String) -> Bool {
        let components1 = version1.split(separator: ".").compactMap { Int($0) }
        let components2 = version2.split(separator: ".").compactMap { Int($0) }

        let maxCount = max(components1.count, components2.count)
        let padded1 = components1 + Array(repeating: 0, count: maxCount - components1.count)
        let padded2 = components2 + Array(repeating: 0, count: maxCount - components2.count)

        for (v1, v2) in zip(padded1, padded2) {
            if v1 > v2 { return true }
            if v1 < v2 { return false }
        }
        return false
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
