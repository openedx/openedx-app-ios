//
//  TenantViewModel.swift
//  Authorization
//
//  Created by Rawan Matar on 02/03/2025.
//

import Foundation
import SwiftUI
import Core
import Alamofire
import AuthenticationServices
import FacebookLogin
import GoogleSignIn
import MSAL
import Theme

public class TenantViewModel: TenantProvider, ObservableObject {
    public var ssoButtonTitle: String {
        selectedTenant?.ssoButtonTitle ?? "SSO Sign in"
    }
    
    public var feedbackEmail: String {
        selectedTenant?.feedbackEmail ?? "support@example.com"
    }
    
    public var oAuthClientId: String {
        selectedTenant?.oAuthClientId ?? ""
    }
    
    public var name: String {
        selectedTenant?.name ??  "Unknown"
    }
    
    public var tenantName: String {
        selectedTenant?.tenantName ??  "Unknown"
    }
    
    public var color: String {
        selectedTenant?.color ?? "#007aff"
    }
    
    public var baseURL: URL {
        selectedTenant?.baseURL ?? URL(string: "http://localhost:8000")!
    }
    
    public var baseURLHiddenLogin: URL {
        selectedTenant?.baseURLHiddenLogin ?? URL(string: "http://localhost:8000")!
    }
    
    public var baseSSOURL: URL {
        selectedTenant?.baseSSOURL ?? URL(string: "test.com")!
    }
    
    public var successfulSSOLoginURL: URL {
        selectedTenant?.successfulSSOLoginURL ?? URL(string: "test.com")!
    }
    
    public var environmentDisplayName: String {
        selectedTenant?.environmentDisplayName ??  "Unknown"
    }
    
    public var uiComponents: Core.UIComponentsConfig {
        selectedTenant?.uiComponents ?? config.uiComponents
    }
    
    @Published public var selectedTenant: Tenant? {
        didSet {
            saveToUserDefaults()
            let name = selectedTenant?.name ?? ""
            let localized = selectedTenant?.tenantName ?? "-"
            Task {
                @MainActor in
                print("selectedTenant: \(name), \(localized)")
                ThemeManager.shared.applyTheme(
                    for: name,
                    localizedName: localized
                )
            }
        }
    }
    @Published public var isSwitchedTenant: Bool = false
    @Published var shouldNavigateBack = false

    private func saveToUserDefaults() {
        UserDefaults.standard.removeObject(forKey: "selectedTenant")
        print("saveToUserDefaults")
        if let tenant = selectedTenant {
            print("tenant: \(tenant)")
            do {
                let data = try JSONEncoder().encode(tenant)
                UserDefaults.standard.set(data, forKey: "selectedTenant")
            } catch {
                print("ERROR ENCOIDNG TENTANT")
            }
        }
    }

    public func loadFromUserDefaults() {
        guard let data = UserDefaults.standard.data(forKey: "selectedTenant"),
              let tenant = try? JSONDecoder().decode(Tenant.self, from: data) else { return }
        self.selectedTenant = tenant
    }
    
    public func resetSelectedTenant() {
        UserDefaults.standard.removeObject(forKey: "selectedTenant")
        self.selectedTenant = nil
        self.shouldNavigateBack = true
    }
    
    let sourceScreen: LogistrationSourceScreen = .default
    let router: AuthorizationRouter
    public let config: ConfigProtocol
    private let analytics: AuthorizationAnalytics
    let storage: CoreStorage

    public init(
        router: AuthorizationRouter,
        config: ConfigProtocol,
        analytics: AuthorizationAnalytics,
        storage: CoreStorage
    ) {
        self.router = router
        self.config = config
        self.analytics = analytics
        self.storage = storage
        self.loadFromUserDefaults()
    }
}
