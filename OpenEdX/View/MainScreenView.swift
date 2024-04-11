//
//  MainScreenView.swift
//  OpenEdX
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import SwiftUI
import Discovery
import Core
import Swinject
import Dashboard
import Profile
import WhatsNew
import SwiftUIIntrospect
import Theme

struct MainScreenView: View {
    
    @State private var disableAllTabs: Bool = false
    @State private var updateAvaliable: Bool = false
    
    @ObservedObject private(set) var viewModel: MainScreenViewModel

    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Theme.Colors.tabbarColor)
        UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.tabbarColor)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.Colors.textSecondaryLight)
        
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSAttributedString.Key.font: Theme.UIFonts.labelSmall()],
            for: .normal
        )
    }
        
    var body: some View {
        TabView(selection: $viewModel.selection) {
            let config = Container.shared.resolve(ConfigProtocol.self)
            if config?.discovery.enabled ?? false {
                ZStack {
                    if config?.discovery.type == .native {
                        DiscoveryView(
                            viewModel: Container.shared.resolve(DiscoveryViewModel.self)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!,
                            sourceScreen: viewModel.sourceScreen
                        )
                    } else if config?.discovery.type == .webview {
                        DiscoveryWebview(
                            viewModel: Container.shared.resolve(
                                DiscoveryWebviewViewModel.self,
                                argument: viewModel.sourceScreen)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!
                        )
                    }
                    
                    if updateAvaliable {
                        UpdateNotificationView(config: viewModel.config)
                    }
                }
                .tabItem {
                    CoreAssets.discovery.swiftUIImage.renderingMode(.template)
                    Text(CoreLocalization.Mainscreen.discovery)
                }
                .tag(MainTab.discovery)
                .accessibilityIdentifier("discovery_tabitem")
            }
            
            ZStack {
                DashboardView(
                    viewModel: Container.shared.resolve(DashboardViewModel.self)!,
                    router: Container.shared.resolve(DashboardRouter.self)!
                )
                if updateAvaliable {
                    UpdateNotificationView(config: viewModel.config)
                }
            }
            .tabItem {
                CoreAssets.dashboard.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.dashboard)
            }
            .tag(MainTab.dashboard)
            .accessibilityIdentifier("dashboard_tabitem")
            
            if config?.program.enabled ?? false {
                ZStack {
                    if config?.program.type == .webview {
                        ProgramWebviewView(
                            viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!
                        )
                    } else if config?.program.type == .native {
                        Text(CoreLocalization.Mainscreen.inDeveloping)
                            .accessibilityIdentifier("indevelopment_program_text")
                    }
                    
                    if updateAvaliable {
                        UpdateNotificationView(config: viewModel.config)
                    }
                }
                .tabItem {
                    CoreAssets.programs.swiftUIImage.renderingMode(.template)
                    Text(CoreLocalization.Mainscreen.programs)
                }
                .tag(MainTab.programs)
                .accessibilityIdentifier("programs_tabitem")
            }
            
            VStack {
                ProfileView(
                    viewModel: Container.shared.resolve(ProfileViewModel.self)!
                )
            }
            .tabItem {
                CoreAssets.profile.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.profile)
            }
            .tag(MainTab.profile)
            .accessibilityIdentifier("profile_tabitem")
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(titleBar())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button(action: {
                        let router = Container.shared.resolve(ProfileRouter.self)!
                        router.showSettings()
                    }, label: {
                        CoreAssets.settingsIcon.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                    .accessibilityIdentifier("edit_profile_button")
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: .onAppUpgradeAccountSettingsTapped)) { _ in
            viewModel.selection = .profile
            disableAllTabs = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .onNewVersionAvaliable)) { _ in
            updateAvaliable = true
        }
        .onChange(of: viewModel.selection) { _ in
            if disableAllTabs {
                viewModel.selection = .profile
            }
        }
        .onChange(of: viewModel.selection, perform: { selection in
            switch selection {
            case .discovery:
                viewModel.trackMainDiscoveryTabClicked()
            case .dashboard:
                viewModel.trackMainDashboardTabClicked()
            case .programs:
                viewModel.trackMainProgramsTabClicked()
            case .profile:
                viewModel.trackMainProfileTabClicked()
            }
        })
        .onFirstAppear {
            Task {
                await viewModel.prefetchDataForOffline()
            }
        }
        .accentColor(Theme.Colors.accentXColor)
    }
    
    private func titleBar() -> String {
        switch viewModel.selection {
        case .discovery:
            return DiscoveryLocalization.title
        case .dashboard:
            return DashboardLocalization.title
        case .programs:
            return CoreLocalization.Mainscreen.programs
        case .profile:
            return ProfileLocalization.title
        }
    }
}
