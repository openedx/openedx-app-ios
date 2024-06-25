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
    @State private var updateAvailable: Bool = false
    
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
            switch viewModel.config.dashboard.type {
            case .list:
                ZStack {
                    ListDashboardView(
                        viewModel: Container.shared.resolve(ListDashboardViewModel.self)!,
                        router: Container.shared.resolve(DashboardRouter.self)!
                    )
                    
                    if updateAvailable {
                        UpdateNotificationView(config: viewModel.config)
                    }
                }
                .tabItem {
                    CoreAssets.dashboard.swiftUIImage.renderingMode(.template)
                    Text(CoreLocalization.Mainscreen.dashboard)
                }
                .tag(MainTab.dashboard)
                .accessibilityIdentifier("dashboard_tabitem")
                if viewModel.config.program.enabled {
                    ZStack {
                        if viewModel.config.program.type == .webview {
                            ProgramWebviewView(
                                viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
                                router: Container.shared.resolve(DiscoveryRouter.self)!
                            )
                        } else if viewModel.config.program.type == .native {
                            Text(CoreLocalization.Mainscreen.inDeveloping)
                        }
                        
                        if updateAvailable {
                            UpdateNotificationView(config: viewModel.config)
                        }
                    }
                    .tabItem {
                        CoreAssets.programs.swiftUIImage.renderingMode(.template)
                        Text(CoreLocalization.Mainscreen.programs)
                    }
                    .tag(MainTab.programs)
                }
            case .gallery:
                ZStack {
                    PrimaryCourseDashboardView(
                        viewModel: Container.shared.resolve(PrimaryCourseDashboardViewModel.self)!,
                        router: Container.shared.resolve(DashboardRouter.self)!,
                        programView: ProgramWebviewView(
                            viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!
                        ),
                        openDiscoveryPage: { viewModel.selection = .discovery }
                    )
                    if updateAvailable {
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
            
            if viewModel.config.discovery.enabled {
                ZStack {
                    if viewModel.config.discovery.type == .native {
                        DiscoveryView(
                            viewModel: Container.shared.resolve(DiscoveryViewModel.self)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!,
                            sourceScreen: viewModel.sourceScreen
                        )
                    } else if viewModel.config.discovery.type == .webview {
                        DiscoveryWebview(
                            viewModel: Container.shared.resolve(
                                DiscoveryWebviewViewModel.self,
                                argument: viewModel.sourceScreen)!,
                            router: Container.shared.resolve(DiscoveryRouter.self)!
                        )
                    }
                    
                    if updateAvailable {
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
        .navigationBarHidden(viewModel.selection == .dashboard)
        .navigationBarBackButtonHidden(viewModel.selection == .dashboard)
        .navigationTitle(titleBar())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Button(action: {
                    let router = Container.shared.resolve(ProfileRouter.self)!
                    router.showSettings()
                }, label: {
                    CoreAssets.settings.swiftUIImage.renderingMode(.template)
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
            updateAvailable = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .showDownloadFailed)) { downloads in
            if let downloads = downloads.object as? [DownloadDataTask] {
                Task {
                   await viewModel.showDownloadFailed(downloads: downloads)
                }
            }
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
            return viewModel.config.dashboard.type == .list
            ? DashboardLocalization.title
            : DashboardLocalization.Learn.title
        case .programs:
            return CoreLocalization.Mainscreen.programs
        case .profile:
            return ProfileLocalization.title
        }
    }
}
