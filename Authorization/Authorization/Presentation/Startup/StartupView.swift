//
//  StartupView.swift
//  Authorization
//
//  Created by SaeedBashir on 10/23/23.
//

import Foundation
import SwiftUI
import Core
import Theme

public struct StartupView: View {
    
    @State private var searchQuery: String = ""
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    @ObservedObject
    private var viewModel: StartupViewModel
    
    public init(viewModel: StartupViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                ThemeAssets.appLogo.swiftUIImage
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: 189, maxHeight: 89)
                    .padding(.top, isHorizontal ? 20 : 40)
                    .padding(.bottom, isHorizontal ? 0 : 20)
                    .padding(.horizontal, isHorizontal ? 10 : 24)
                    .colorMultiply(Theme.Colors.accentColor)
                    .accessibilityIdentifier("logo_image")
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(AuthLocalization.Startup.infoMessage)
                            .font(Theme.Fonts.titleLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.bottom, isHorizontal ? 10 : 20 )
                            .accessibilityIdentifier("heading_text")
                        
                        Text(AuthLocalization.Startup.searchTitle)
                            .font(Theme.Fonts.bodyLarge)
                            .bold()
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top, isHorizontal ? 0 : 24)
                            .accessibilityIdentifier("search_title_text")
                        
                        HStack(spacing: 11) {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 16)
                                .padding(.top, 1)
                                .foregroundColor(Theme.Colors.textInputTextColor)
                            TextField("", text: $searchQuery, onCommit: {
                                if searchQuery.isEmpty { return }
                                viewModel.router.showDiscoveryScreen(
                                    searchQuery: searchQuery,
                                    sourceScreen: .startup
                                )
                            })
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .frame(minHeight: 50)
                            .submitLabel(.search)
                            .font(Theme.Fonts.bodyLarge)
                            .foregroundColor(Theme.Colors.textInputTextColor)
                            .accessibilityIdentifier("explore_courses_textfield")
                            
                        }.overlay(
                            Theme.Shapes.textInputShape
                                .stroke(lineWidth: 1)
                                .fill(Theme.Colors.textInputStroke)
                        )
                        .background(
                            Theme.InputFieldBackground(
                                placeHolder: AuthLocalization.Startup.searchPlaceholder,
                                text: searchQuery,
                                padding: 48
                            )
                        )
                        
                        Button {
                            viewModel.router.showDiscoveryScreen(
                                searchQuery: searchQuery,
                                sourceScreen: .startup
                            )
                        } label: {
                            Text(AuthLocalization.Startup.exploreAllCourses)
                                .underline()
                                .foregroundColor(Theme.Colors.infoColor)
                                .font(Theme.Fonts.bodyLarge)
                        }
                        .padding(.top, isHorizontal ? 0 : 5)
                        .accessibilityIdentifier("explore_courses_button")
                        Spacer()
                    }
                    .padding(.horizontal, isHorizontal ? 10 : 24)
                    
                    LogistrationBottomView(
                        ssoEnabled: viewModel.config.uiComponents.samlSSOLoginEnabled
                    ) { buttonAction in
                        switch buttonAction {
                        case .signIn:
                            viewModel.router.showLoginScreen(sourceScreen: .startup)
                        case .signInWithSSO:
                            viewModel.router.showLoginScreen(sourceScreen: .startup)
                        case .register:
                            viewModel.router.showRegisterScreen(sourceScreen: .startup)
                        }
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 2)
            }
            .onDisappear {
                searchQuery = ""
            }
            .frameLimit()
        }
        .navigationTitle(AuthLocalization.Startup.title)
        .navigationBarHidden(true)
        .padding(.all, isHorizontal ? 1 : 0)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onFirstAppear {
            viewModel.trackScreenEvent()
        }
    }
}

#if DEBUG
struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = StartupViewModel(
            router: AuthorizationRouterMock(),
            analytics: CoreAnalyticsMock(),
            config: ConfigMock()
        )
        
        StartupView(viewModel: vm)
            .preferredColorScheme(.light)
            .previewDisplayName("StartupView Light")
            .loadFonts()
        
        StartupView(viewModel: vm)
            .preferredColorScheme(.dark)
            .previewDisplayName("StartupView Dark")
            .loadFonts()
    }
}
#endif
