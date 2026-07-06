import Core
import Foundation

struct LMSSelectionSnapshot: Codable, Sendable {
    let detail: LMSDetailDTO
    let appliedAt: Date
}

protocol LMSOverridesStoreProtocol: Sendable {
    func save(detail: LMSDetail, payload: Data, storage: CoreStorage?) throws
    func currentSelection() -> LMSDetail?
    func clear(storage: CoreStorage?) throws
}

final class LMSOverridesStore: LMSOverridesStoreProtocol {
    enum Keys {
        static let selectionPayload = "lmsDirectory.selected_lms_payload"
        static let feedbackEmail = "lmsDirectory.selected_feedback_email"
        static let oauthClientId = "lmsDirectory.selected_oauth_client_id"
        static let accentColor = "lmsDirectory.selected_accent_color"
        static let accentColorDark = "lmsDirectory.selected_accent_color_dark"
        static let unknownUnitsMode = "lmsDirectory.selected_unknown_units_mode"
        static let loginBackgroundURL = "lmsDirectory.selected_login_background_url"
        static let logoUploadURL = "lmsDirectory.selected_logo_upload_url"
        static let courseUnitProgress = "lmsDirectory.selected_course_unit_progress"
        static let courseDropdownNav = "lmsDirectory.selected_course_dropdown_nav"
        static let preLoginExperience = "lmsDirectory.selected_pre_login_experience"
        static let dashboardType = "lmsDirectory.selected_dashboard_type"
    }

    private nonisolated(unsafe) let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func save(detail: LMSDetail, payload: Data, storage: CoreStorage?) throws {
        if var storage = storage {
            storage.selectedLMSBaseURL = detail.api.hostURL.absoluteString
        }
        userDefaults.set(payload, forKey: Keys.selectionPayload)
        userDefaults.set(detail.api.feedbackEmail, forKey: Keys.feedbackEmail)
        userDefaults.set(detail.api.oauthClientId, forKey: Keys.oauthClientId)
        userDefaults.set(detail.accentColorHex, forKey: Keys.accentColor)
        userDefaults.set(detail.theme?.accentColorDark, forKey: Keys.accentColorDark)
        userDefaults.set(detail.featureFlags.unknownUnitsMode ?? "block", forKey: Keys.unknownUnitsMode)
        userDefaults.set(detail.theme?.loginBackgroundURL?.absoluteString, forKey: Keys.loginBackgroundURL)
        userDefaults.set(detail.effectiveLogoURL?.absoluteString, forKey: Keys.logoUploadURL)
        userDefaults.set(detail.uiComponents?.courseUnitProgressEnabled ?? true, forKey: Keys.courseUnitProgress)
        userDefaults.set(detail.uiComponents?.courseDropdownNavigationEnabled ?? true, forKey: Keys.courseDropdownNav)
        userDefaults.set(detail.uiComponents?.preLoginExperienceEnabled ?? true, forKey: Keys.preLoginExperience)
        userDefaults.set(detail.dashboard?.type ?? "gallery", forKey: Keys.dashboardType)
    }

    func currentSelection() -> LMSDetail? {
        guard
            let payload = userDefaults.data(forKey: Keys.selectionPayload),
            let dto = try? JSONDecoder().decode(LMSDetailDTO.self, from: payload)
        else {
            return nil
        }
        return dto.domainModel
    }

    func clear(storage: CoreStorage?) throws {
        if var storage = storage {
            storage.selectedLMSBaseURL = nil
        }
        for key in [
            Keys.selectionPayload, Keys.feedbackEmail, Keys.oauthClientId,
            Keys.accentColor, Keys.accentColorDark, Keys.unknownUnitsMode,
            Keys.loginBackgroundURL, Keys.logoUploadURL,
            Keys.courseUnitProgress, Keys.courseDropdownNav,
            Keys.preLoginExperience, Keys.dashboardType
        ] {
            userDefaults.removeObject(forKey: key)
        }
    }
}
