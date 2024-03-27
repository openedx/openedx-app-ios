//
//  SettingsViewModel.swift
//  Profile
//
//  Created by  Stepanok Ivan on 16.03.2023.
//

import Foundation
import Core
import SwiftUI

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

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    @Published private(set) var userSettings: UserSettings

    private let interactor: ProfileInteractorProtocol
    let router: ProfileRouter
    let analytics: CoreAnalytics
    
    public init(interactor: ProfileInteractorProtocol, router: ProfileRouter, analytics: CoreAnalytics) {
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        
        let userSettings = interactor.getSettings()
        self.userSettings = userSettings
        self.wifiOnly = userSettings.wifiOnly
        self.selectedQuality = userSettings.streamingQuality
    }

    func update(downloadQuality: DownloadQuality) {
        self.userSettings.downloadQuality = downloadQuality
        interactor.saveSettings(userSettings)
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
