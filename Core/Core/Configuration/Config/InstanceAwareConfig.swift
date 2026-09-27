//  InstanceAwareConfig.swift
//  Core
//
//  Created by Rawan Matar on 22/09/2026.
//

import Foundation

/// `ConfigProtocol` implementation that layers the currently selected `Instance` over the
/// app-level `Config`. Fields `Instance` carries win when an instance is selected; everything
/// else (and every field with no instance is selected) falls back to `appConfig`.
///
/// Not a `Config` subclass: `Config`'s `ConfigProtocol` conformance is spread across several
/// `extension Config { ... }` blocks, which Swift cannot override via subclassing.
///
/// Fields that stay app-level always (not per-instance in this project's model): firebase,
/// facebook, microsoft, google, appleSignIn, braze, branch, URIScheme, appStoreLink,
/// instancesCatalogURL.
public final class InstanceAwareConfig: ConfigProtocol {
    private let appConfig: ConfigProtocol
    private let instanceProvider: InstanceProvider

    public init(appConfig: ConfigProtocol, instanceProvider: InstanceProvider) {
        self.appConfig = appConfig
        self.instanceProvider = instanceProvider
    }

    private var instance: Instance? { instanceProvider.currentInstance }

    public var baseURL: URL { instance?.baseURL ?? appConfig.baseURL }
    public var baseSSOURL: URL { instance?.baseSSOURL ?? appConfig.baseSSOURL }
    public var ssoFinishedURL: URL { instance?.ssoFinishedURL ?? appConfig.ssoFinishedURL }
    public var oAuthClientId: String { instance?.oAuthClientId ?? appConfig.oAuthClientId }
    public var tokenType: TokenType { instance?.tokenType ?? appConfig.tokenType }
    public var feedbackEmail: String { instance?.feedbackEmail ?? appConfig.feedbackEmail }
    public var faq: URL? { instance?.faq ?? appConfig.faq }
    public var platformName: String { instance?.platformName ?? appConfig.platformName }
    public var agreement: AgreementConfig { instance?.agreement ?? appConfig.agreement }
    public var features: FeaturesConfig { instance?.features ?? appConfig.features }
    public var uiComponents: UIComponentsConfig { instance?.uiComponents ?? appConfig.uiComponents }
    public var discovery: DiscoveryConfig { instance?.discovery ?? appConfig.discovery }
    public var program: DiscoveryConfig { instance?.program ?? appConfig.program }
    public var dashboard: DashboardConfig { instance?.dashboard ?? appConfig.dashboard }

    public var ssoButtonTitle: [String: Any] {
        guard let title = instance?.ssoButtonTitle, !title.isEmpty else { return appConfig.ssoButtonTitle }
        return title
    }

    /// `isRoundedCorners`/`buttonCornersRadius` live directly on `Instance` (not optional --
    /// default `true`/`8.0` when the instance's THEME block omits them), so an instance always
    /// wins on theme once one is selected.
    public var theme: ThemeConfig {
        guard let instance else { return appConfig.theme }
        return ThemeConfig(
            isRoundedCorners: instance.isRoundedCorners,
            buttonCornersRadius: instance.buttonCornersRadius
        )
    }

    /// `Instance.appLevelDownloadsEnabled` is optional (nil when the instance's
    /// EXPERIMENTAL_FEATURES block omits it) -- falls back to app-level rather than assuming
    /// `false`.
    public var experimentalFeatures: ExperimentalFeaturesConfig {
        guard let enabled = instance?.appLevelDownloadsEnabled else { return appConfig.experimentalFeatures }
        return ExperimentalFeaturesConfig(appLevelDownloadsEnabled: enabled)
    }

    // MARK: - App-level only

    public var appStoreLink: String { appConfig.appStoreLink }
    public var firebase: FirebaseConfig { appConfig.firebase }
    public var facebook: FacebookConfig { appConfig.facebook }
    public var microsoft: MicrosoftConfig { appConfig.microsoft }
    public var google: GoogleConfig { appConfig.google }
    public var appleSignIn: AppleSignInConfig { appConfig.appleSignIn }
    public var braze: BrazeConfig { appConfig.braze }
    public var branch: BranchConfig { appConfig.branch }
    public var URIScheme: String { appConfig.URIScheme }
    public var instancesCatalogURL: URL? { appConfig.instancesCatalogURL }
}
