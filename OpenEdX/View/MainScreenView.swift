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

struct MainScreenView: View {
    
    @State private var selection: MainTab = .discovery
    @State private var settingsTapped: Bool = false
    @State private var disableAllTabs: Bool = false
    @State private var updateAvaliable: Bool = false
    
    enum MainTab {
        case discovery
        case dashboard
        case programs
        case profile
    }
    
    @ObservedObject private var viewModel: MainScreenViewModel
 
    init(viewModel: MainScreenViewModel) {
        self.viewModel = viewModel
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.Colors.textSecondary)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            ZStack {
                DiscoveryView(viewModel: Container.shared.resolve(DiscoveryViewModel.self)!, router: Container.shared.resolve(DiscoveryRouter.self)!)
                if updateAvaliable {
                    UpdateNotificationView(config: viewModel.config)
                }
            }
            .tabItem {
                CoreAssets.discovery.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.discovery)
            }
            .tag(MainTab.discovery)
            
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
            
            ZStack {
                Text(CoreLocalization.Mainscreen.inDeveloping)
                if updateAvaliable {
                    UpdateNotificationView(config: viewModel.config)
                }
            }
            .tabItem {
                CoreAssets.programs.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.programs)
            }
            .tag(MainTab.programs)
            
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
        }
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(titleBar())
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                if selection == .profile {
                    Button(action: {
                        settingsTapped.toggle()
                    }, label: {
                        CoreAssets.edit.swiftUIImage
                            .foregroundColor(Theme.Colors.textPrimary)
                    })
                } else {
                    VStack {}
                }
            })
        }
        .onReceive(NotificationCenter.default.publisher(for: .onAppUpgradeAccountSettingsTapped)) { _ in
            selection = .profile
            disableAllTabs = true
        }
        .onReceive(NotificationCenter.default.publisher(for: .onNewVersionAvaliable)) { _ in
            updateAvaliable = true
        }
        .onChange(of: selection) { _ in
            if disableAllTabs {
                selection = .profile
            }
        }
        .onChange(of: selection, perform: { selection in
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
    }
    
    private func titleBar() -> String {
        switch selection {
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
