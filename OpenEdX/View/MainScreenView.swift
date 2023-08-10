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
import SwiftUIIntrospect

struct MainScreenView: View {
    
    @State private var selection: MainTab = .discovery
    
    func titleBar() -> String {
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
    
    enum MainTab {
        case discovery
        case dashboard
        case programs
        case profile
    }
    
    let analytics = Container.shared.resolve(MainScreenAnalytics.self)!
    
    init() {
        UINavigationBar.appearance().isTranslucent = false
        
        let coloredNavAppearance = UINavigationBarAppearance()
        coloredNavAppearance.configureWithTransparentBackground()
        coloredNavAppearance.setBackIndicatorImage(CoreAssets.arrowLeft.image,
                                                   transitionMaskImage: CoreAssets.arrowLeft.image)
        coloredNavAppearance.backgroundColor = CoreAssets.background.color
        UINavigationBar.appearance().standardAppearance = coloredNavAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredNavAppearance
        UINavigationBar.appearance().compactAppearance = coloredNavAppearance
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.Colors.textSecondary)
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
            
            VStack {
                Text(CoreLocalization.Mainscreen.inDeveloping)
            }
            .tabItem {
                CoreAssets.programs.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.programs)
            }
            .tag(MainTab.programs)

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
        }
        .navigationBarHidden(selection == .profile)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(titleBar())
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
