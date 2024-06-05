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

public class SettingsViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var wifiOnly: Bool {
        willSet {
            if newValue != wifiOnly {
                userSettings.wifiOnly = newValue
                interactor.saveSettings(userSettings)
            }
        }
    }
    
    @Published var selectedQuality: StreamingQuality {
        willSet {
            if newValue != selectedQuality {
                userSettings.streamingQuality = newValue
                interactor.saveSettings(userSettings)
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
    let serverConfig: ServerConfigProtocol
    let upgradeHandler: CourseUpgradeHandlerProtocol
    let upgradeHelper: CourseUpgradeHelperProtocol?
    
    public init(
        interactor: ProfileInteractorProtocol,
        downloadManager: DownloadManagerProtocol,
        router: ProfileRouter,
        analytics: ProfileAnalytics,
        coreAnalytics: CoreAnalytics,
        config: ConfigProtocol,
        serverConfig: ServerConfigProtocol,
        upgradeHandler: CourseUpgradeHandlerProtocol,
        upgradeHelper: CourseUpgradeHelperProtocol? = nil
    ) {
        self.interactor = interactor
        self.downloadManager = downloadManager
        self.router = router
        self.analytics = analytics
        self.coreAnalytics = coreAnalytics
        self.config = config
        self.serverConfig = serverConfig
        self.upgradeHandler = upgradeHandler
        self.upgradeHelper = upgradeHelper
        
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
                DispatchQueue.main.async { [weak self] in
                    self?.latestVersion = latestVersion
                    
                    if latestVersion != currentVersion {
                        self?.versionState = .updateNeeded
                    }
                }
            }.store(in: &cancellables)
    }
    
    func contactSupport() -> URL? {
        return EmailTemplates.contactSupport(
            email: config.feedbackEmail,
            emailSubject: CoreLocalization.feedbackEmailSubject
        )
    }

    func update(downloadQuality: DownloadQuality) {
        self.userSettings.downloadQuality = downloadQuality
        interactor.saveSettings(userSettings)
    }
    
    func openAppStore() {
        guard let appStoreURL = URL(string: config.appStoreLink) else { return }
        UIApplication.shared.open(appStoreURL)
    }
    
    @MainActor
    func logOut() async {
        try? await interactor.logOut()
        try? await downloadManager.cancelAllDownloading()
        router.showStartupScreen()
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
        analytics.profileEvent(.userLogoutClicked, biValue: .userLogoutClicked)
    }
    
    @MainActor
    func restorePurchases() async {
        coreAnalytics.trackRestorePurchaseClicked()
        router.showRestoreProgressView()
        
        guard let inprogressIAP = CourseUpgradeHelper.getInProgressIAP() else {
            hideRestoreProgressView(showAlert: true, delay: 3)
            return
        }
        
        do {
            let product = try await upgradeHandler.fetchProduct(sku: inprogressIAP.sku)
            await fulfillPurchase(inprogressIAP: inprogressIAP, product: product)
        } catch _ {
            hideRestoreProgressView(showAlert: true)
        }
    }
    
    private func fulfillPurchase(inprogressIAP: InProgressIAP, product: StoreProductInfo) async {
        coreAnalytics.trackCourseUnfulfilledPurchaseInitiated(
            courseID: inprogressIAP.courseID,
            pacing: inprogressIAP.pacing,
            screen: .dashboard,
            flowType: .restore)

        await upgradeHandler.upgradeCourse(
            sku: inprogressIAP.sku,
            mode: .silent,
            productInfo: product,
            pacing: inprogressIAP.pacing,
            courseID: inprogressIAP.courseID,
            componentID: nil,
            screen: .dashboard,
            completion: {[weak self] state in
                print("Saeed: \(state)")
                guard let self else { return }
                switch state {
                
                case .error:
                        self.hideRestoreProgressView()
                case .complete:
                    self.hideRestoreProgressView()
                default:
                   debugPrint("Upgrade state changed: \(state)")
                }
            }
        )
    }
    
    private func hideRestoreProgressView(showAlert: Bool = false, delay: TimeInterval = 0) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            Task {
                self?.router.hideRestoreProgressView()
                if showAlert {
                    self?.upgradeHelper?.showRestorePurchasesAlert()
                }
            }
        }
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
