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
    @State private var settingsTapped: Bool = false
    @State private var block: Bool = false
    
    enum MainTab {
        case discovery
        case dashboard
        case programs
        case profile
    }
    
    private let analytics = Container.shared.resolve(MainScreenAnalytics.self)!
    
    init() {
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().backgroundColor = UIColor(Theme.Colors.textInputUnfocusedBackground)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Theme.Colors.textSecondary)
//        NotificationCenter.default.publisher(for: .blockAppBeforeUpdate)
//            .sink { self _ in
//                self?.selection = .profile
//            }
//            .store(in: &cancellables)
    }
    
    var body: some View {
        TabView(selection: $selection) {
            DiscoveryView(viewModel: Container.shared.resolve(DiscoveryViewModel.self)!)
            .tabItem {
                CoreAssets.discovery.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.discovery)
            }.disabled(block)
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
            }.disabled(block)
            .tag(MainTab.dashboard)
            
            VStack {
                Text(CoreLocalization.Mainscreen.inDeveloping)
            }
            .tabItem {
                CoreAssets.programs.swiftUIImage.renderingMode(.template)
                Text(CoreLocalization.Mainscreen.programs)
            }.disabled(block)
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
        .onChange(of: NotificationCenter.default.publisher(for: .blockAppBeforeUpdate), perform: { _ in
            self.selection = .profile
            self.block = true
        })
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
    
    struct MainScreenView_Previews: PreviewProvider {
        static var previews: some View {
            MainScreenView()
        }
    }
}
