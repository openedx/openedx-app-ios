//
//  TenantSelectionView.swift
//  Authorization
//
//  Created by Rawan Matar on 02/03/2025.
//

import SwiftUI
import Core
import Theme
import Swinject

// Define a struct for tenant theme
public struct TenantTheme {
    let name: String
    let color: Color
    let baseURL: String?
    let baseURLHiddenLogin: String?
    let baseSSOURL: String?
    let successfulSSOLoginURL: String?
    let environmentDisplayName: String?
}

public struct TenantContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @ObservedObject var viewModel: TenantViewModel
//    var tenants: [Tenant] = []
    @Environment(\.isHorizontal) private var isHorizontal
    var isSwitchTenant: Bool
    public init(viewModel: TenantViewModel, isSwitchTenant: Bool = false) {
        self.viewModel = viewModel
        self.isSwitchTenant = isSwitchTenant
//        tenants = self.viewModel.config.tenantsConfig.tenants
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                if viewModel.storage.accessToken != nil, isSwitchTenant {
                    if viewModel.isSwitchedTenant {
                        ProgressView()
                            .onAppear {
                                viewModel.isSwitchedTenant = false
                                if viewModel.selectedTenant?.isSwitchTenantLoginEnabled ?? false {
                                    viewModel.router.showLoginScreen(sourceScreen: .startup)
                                } else {
                                    viewModel.router.showMainOrWhatsNewScreen(
                                        sourceScreen: .discovery,
                                        postLoginData: nil)
                                }
                                
                            }
                    } else {
                        BackNavigationButton(
                            color: themeManager.theme.colors.accentColor,
                            action: {
                               viewModel.router.back(animated: true)
                            }
                        )
                        .environmentObject(themeManager)
                        .backViewStyle()
                        .padding(.leading, isHorizontal ? 48 : 0)
                        .padding(.top, 11)
                        TenantSelectionView(viewModel: viewModel)
                            .environmentObject(themeManager)
                    }
                } else {
                    if viewModel.selectedTenant != nil {
                        ProgressView()
                            .onAppear {
                                viewModel.router.showLoginScreen(sourceScreen: .startup)
                            }
                    } else {
                        TenantSelectionView(viewModel: viewModel)
                            .environmentObject(themeManager)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            NavigationAppearanceManager.shared.updateAppearance(
                backgroundColor: themeManager.theme.colors.navigationBarColor.uiColor(),
                                titleColor: .white
                            )
        }
        .onReceive(viewModel.$shouldNavigateBack.removeDuplicates()) { shouldNavigate in
            if shouldNavigate {
                DispatchQueue.main.async {
                    viewModel.router.back()
                    viewModel.shouldNavigateBack = false
                }
            }
        }
    }
}

public struct TenantSelectionView: View {
    @ObservedObject var viewModel: TenantViewModel
    @State private var searchText: String = ""
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: TenantViewModel) {
        self.viewModel = viewModel
    }
    var tenants: [Tenant] {
        if searchText.isEmpty {
            return viewModel.config.tenantsConfig.tenants
        } else {
            return viewModel.config.tenantsConfig.tenants.filter {
                $0.name.lowercased().contains(searchText.lowercased()) ||
                $0.tenantName.lowercased().contains(searchText.lowercased())
            }
        }
    }

    public var body: some View {
        VStack {
            Text(AuthLocalization.TenantSelection.title)
                .font(.title)
                .padding()
            
            TextField(AuthLocalization.TenantSelection.searchTitle, text: $searchText)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding([.horizontal, .top])

            List(tenants) { tenant in
                Button(action: {
                    viewModel.selectedTenant = viewModel.config.tenantsConfig.tenants.first(
                        where: {
                            return $0.name == tenant.name
                        })
                    viewModel.isSwitchedTenant = true
                }) {
                    HStack {
                        getLogo(name: tenant.name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 40, maxHeight: 40)
                            .accessibilityIdentifier("logo_image")
                        
                        Spacer(minLength: 5)
                        
                        Text(tenant.tenantName)
                            .foregroundColor(ThemeManager.shared.theme.colors.textPrimary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText)
        }
        .navigationBarHidden(true)
    }
    
    func getLogo(name: String) -> Image {
        switch name.lowercased() {
        case "tenanta":
            return ThemeAssets.appLogo.swiftUIImage
        case "tenantb":
            return ThemeAssets.appLogo.swiftUIImage
        default:
            return ThemeAssets.appLogo.swiftUIImage
        }
    }
}

extension Color {
    init(_ colorString: String) {
        switch colorString.lowercased() {
        case "green":
            self = .green
        case "blue":
            self = .blue
        case "red":
            self = .red
        // Add more mappings if needed
        default:
            self = .gray
        }
    }
}
