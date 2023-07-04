//
//  MainScreenView.swift
//  NewEdX
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import SwiftUI
import Discovery
import Core
import Swinject
import Dashboard
import Profile
import SwiftUIIntrospect

struct MainScreenView: View {
    
    @State private var selection: MainTab = .discovery
    
    enum MainTab {
        case discovery
        case dashboard
        case programs
        case profile
    }
    
    let analytics = Container.shared.resolve(MainScreenAnalytics.self)!
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = CoreAssets.textInputUnfocusedBackground.color
        UITabBar.appearance().backgroundColor = CoreAssets.textInputUnfocusedBackground.color
        UITabBar.appearance().unselectedItemTintColor = CoreAssets.textSecondary.color
    }
    
    var body: some View {
        TabView(selection: $selection) {
            DiscoveryView(
                viewModel: Container.shared.resolve(DiscoveryViewModel.self)!,
                router: Container.shared.resolve(DiscoveryRouter.self)!
            )
            .tabItem {
                CoreAssets.discovery.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.discovery)
            }
            .tag(MainTab.discovery)
            .hideNavigationBar()

            VStack {
                DashboardView(
                    viewModel: Container.shared.resolve(DashboardViewModel.self)!,
                    router: Container.shared.resolve(DashboardRouter.self)!
                )
            }
            .tabItem {
                CoreAssets.dashboard.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.dashboard)
            }
            .tag(MainTab.dashboard)
            .hideNavigationBar()
            
            VStack {
                Text(CoreLocalization.Mainscreen.inDeveloping)
            }
            .tabItem {
                CoreAssets.programs.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.programs)
            }
            .tag(MainTab.programs)
            .hideNavigationBar()

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
            .hideNavigationBar()
        }
            .onChange(of: selection, perform: { selection in
                switch selection {
                case .discovery:
                    analytics.mainDiscoveryTabClicked()
                case .dashboard:
                    analytics.mainDashboardTabClicked()
                case .programs:
                    analytics.mainProgramsTabClicked()
                case .profile:
                    analytics.mainProfileTabClicked()
                }
            })
    }
    
    struct MainScreenView_Previews: PreviewProvider {
        static var previews: some View {
            MainScreenView()
        }
    }
}
