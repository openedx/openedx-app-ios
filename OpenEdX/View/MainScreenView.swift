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
import Downloads
import Profile
import WhatsNew
import SwiftUIIntrospect
import Theme
import OEXFoundation

struct MainScreenView: View {
    
    @State private var disableAllTabs: Bool = false
    @State private var updateAvailable: Bool = false
    @ObservedObject private(set) var viewModel: MainScreenViewModel
    
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $viewModel.selection) {
                switch viewModel.config.dashboard.type {
                case .list:
                    ZStack {
                        ListDashboardView(
                            viewModel: Container.shared.resolve(ListDashboardViewModel.self)!,
                            router: Container.shared.resolve(DashboardRouter.self)!
                        )

                        registerBanner
                    }
                    .tabItem {
                        CoreAssets.dashboard.swiftUIImage.renderingMode(.template)
                        Text(CoreLocalization.Mainscreen.dashboard)
                    }
                    .tag(MainTab.dashboard)
                    .accessibilityIdentifier("dashboard_tabitem")
                    .animation(.easeInOut, value: viewModel.showRegisterBanner)
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
                            programView: ProgramWebviewView(
                                viewModel: Container.shared.resolve(ProgramWebviewViewModel.self)!,
                                router: Container.shared.resolve(DiscoveryRouter.self)!
                            ),
                            openDiscoveryPage: { viewModel.selection = .discovery }
                        )
                        registerBanner
                    }
                    .tabItem {
                        if viewModel.selection == .dashboard {
                            CoreAssets.learnActive.swiftUIImage.renderingMode(.template)
                        } else {
                            CoreAssets.learnInactive.swiftUIImage.renderingMode(.template)
                        }
                        Text(CoreLocalization.Mainscreen.learn)
                    }
                    .tag(MainTab.dashboard)
                    .accessibilityIdentifier("dashboard_tabitem")
                    .animation(.easeInOut, value: viewModel.showRegisterBanner)
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
                    }
                    .tabItem {
                        if viewModel.selection == .discovery {
                            CoreAssets.discoverActive.swiftUIImage.renderingMode(.template)
                        } else {
                            CoreAssets.discoverInactive.swiftUIImage.renderingMode(.template)
                        }
                        Text(CoreLocalization.Mainscreen.discovery)
                    }
                    .tag(MainTab.discovery)
                    .accessibilityIdentifier("discovery_tabitem")
                }
                
                if viewModel.config.experimentalFeatures.appLevelDownloadsEnabled {
                    AppDownloadsView(viewModel: Container.shared.resolve(AppDownloadsViewModel.self)!)
                        .tabItem {
                            if viewModel.selection == .downloads {
                                CoreAssets.downloadsActive.swiftUIImage.renderingMode(.template)
                            } else {
                                CoreAssets.downloadsInactive.swiftUIImage.renderingMode(.template)
                            }
                            Text(DownloadsLocalization.Downloads.title)
                        }
                        .tag(MainTab.downloads)
                        .accessibilityIdentifier("downloads_tabitem")
                }
                
                VStack {
                    ProfileView(
                        viewModel: Container.shared.resolve(ProfileViewModel.self)!
                    )
                }
                .tabItem {
                    if viewModel.selection == .profile {
                        CoreAssets.profileActive.swiftUIImage.renderingMode(.template)
                    } else {
                        CoreAssets.profileInactive.swiftUIImage.renderingMode(.template)
                    }
                    Text(CoreLocalization.Mainscreen.profile)
                }
                .tag(MainTab.profile)
                .accessibilityIdentifier("profile_tabitem")
            }
            .onAppear {
                UITabBar.appearance().isTranslucent = false
                UITabBar.appearance().barTintColor = UIColor(Theme.Colors.tabbarColor)
                UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.tabbarColor)
                UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.Colors.textSecondaryLight)
                
                UITabBarItem.appearance().setTitleTextAttributes(
                    [NSAttributedString.Key.font: Theme.UIFonts.labelSmall()],
                    for: .normal
                )
                NavigationAppearanceManager.shared.updateAppearance(
                    backgroundColor: Theme.Colors.navigationBarColor.uiColor(),
                                    titleColor: .white
                                )
            }
            .navigationBarHidden(viewModel.selection == .dashboard || viewModel.selection == .downloads)
            .navigationBarBackButtonHidden(viewModel.selection == .dashboard || viewModel.selection == .downloads)
            .navigationTitle(titleBar())
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    if viewModel.selection != .downloads {
                        Button(action: {
                            let router = Container.shared.resolve(ProfileRouter.self)!
                            router.showSettings()
                        }, label: {
                            CoreAssets.settings.swiftUIImage.renderingMode(.template)
                                .foregroundColor(Theme.Colors.accentColor)
                        })
                        .accessibilityIdentifier("edit_profile_button")
                    }
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
                    viewModel.trackMainDashboardLearnTabClicked()
                case .programs:
                    viewModel.trackMainProgramsTabClicked()
                case .profile:
                    viewModel.trackMainProfileTabClicked()
                case .downloads:
                    viewModel.trackMainDownloadsTabClicked()
                }
            })
            .onFirstAppear {
                Task {
                    await viewModel.prefetchDataForOffline()
                    await viewModel.loadCalendar()
                }
                viewModel.trackMainDashboardLearnTabClicked()
                viewModel.trackMainDashboardMyCoursesClicked()
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    viewModel.checkIfNeedToShowRegisterBanner()
                }
            }
            .accentColor(Theme.Colors.accentXColor)
            if updateAvailable {
                UpdateNotificationView(config: viewModel.config)
            }
        }
    }
    
    @ViewBuilder
    private var registerBanner: some View {
        if viewModel.showRegisterBanner {
            VStack {
                SnackBarView(message: viewModel.registerBannerText)
                Spacer()
            }.transition(.move(edge: .top))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.registerBannerWasShowed()
                    }
                }
        }
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
        case .downloads:
            return DownloadsLocalization.Downloads.title
        case .profile:
            return ProfileLocalization.title
        }
    }
}
