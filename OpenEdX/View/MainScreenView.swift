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
    
    @State private var settingsTapped: Bool = false
    @State private var disableAllTabs: Bool = false
    @State private var updateAvaliable: Bool = false
    
    @ObservedObject private(set) var viewModel: MainScreenViewModel
    
    private let config = Container.shared.resolve(ConfigProtocol.self)

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
            if config?.dashboard.type == .learn {
                ZStack {
                    LearnView(
                        viewModel: Container.shared.resolve(LearnViewModel.self)!,
                        router: Container.shared.resolve(DashboardRouter.self)!,
                        programView: ProgramWebviewView(
                            viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!
                        ),
                        openDiscoveryPage: { viewModel.selection = .discovery }
                    )
                    if updateAvaliable {
                        UpdateNotificationView(config: viewModel.config)
                    }
                }
                .tabItem {
                    CoreAssets.learn.swiftUIImage.renderingMode(.template)
                    Text(CoreLocalization.Mainscreen.learn)
                }
                .tag(MainTab.dashboard)
                .accessibilityIdentifier("dashboard_tabitem")
            }

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
            
            if config?.dashboard.type == .dashboard {
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
            }
            
            VStack {
                ProfileView(
                    viewModel: Container.shared.resolve(ProfileViewModel.self)!, settingsTapped: $settingsTapped
                )
            }
            .tabItem {
                CoreAssets.profile.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.profile)
            }
            .tag(MainTab.profile)
            .accessibilityIdentifier("profile_tabitem")
        }
        .navigationBarHidden(viewModel.selection == .dashboard)
        .navigationBarBackButtonHidden(viewModel.selection == .dashboard)
        .navigationTitle(titleBar())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if viewModel.selection == .profile {
                    Button(action: {
                        settingsTapped.toggle()
                    }, label: {
                        CoreAssets.edit.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.navigationBarTintColor)
                    })
                    .accessibilityIdentifier("edit_profile_button")
                } else {
                    VStack {}
                }
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
            return config?.dashboard.type == .dashboard
            ? DashboardLocalization.title
            : DashboardLocalization.Learn.title
        case .programs:
            return CoreLocalization.Mainscreen.programs
        case .profile:
            return ProfileLocalization.title
        }
    }
}
