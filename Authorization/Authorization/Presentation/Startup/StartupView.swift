//
//  StartupView.swift
//  Authorization
//
//  Created by SaeedBashir on 10/23/23.
//

import Foundation
import SwiftUI
import Core

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
                CoreAssets.appLogo.swiftUIImage
                    .resizable()
                    .frame(maxWidth: 189, maxHeight: 54)
                    .padding(.top, isHorizontal ? 20 : 40)
                    .padding(.bottom, isHorizontal ? 0 : 20)
                    .padding(.horizontal, isHorizontal ? 10 : 24)
                    .colorMultiply(Theme.Colors.accentColor)
                
                VStack {
                    VStack(alignment: .leading) {
                        Text(AuthLocalization.Startup.infoMessage)
                            .font(Theme.Fonts.titleLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.bottom, isHorizontal ? 10 : 20 )
                        
                        Text(AuthLocalization.Startup.searchTitle)
                            .font(Theme.Fonts.bodyLarge)
                            .bold()
                            .foregroundColor(Theme.Colors.textPrimary)
                            .padding(.top, isHorizontal ? 0 : 24)
                        
                        HStack(spacing: 11) {
                            Image(systemName: "magnifyingglass")
                                .padding(.leading, 16)
                                .padding(.top, 1)
                            TextField(AuthLocalization.Startup.searchPlaceholder, text: $searchQuery, onCommit: {
                                if searchQuery.isEmpty { return }
                                viewModel.router.showDiscoveryScreen(searchQuery: searchQuery, fromStartupScreen: true)
                            })
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .frame(minHeight: 50)
                            .submitLabel(.search)
                            
                        }.overlay(
                            Theme.Shapes.textInputShape
                                .stroke(lineWidth: 1)
                                .fill(Theme.Colors.textInputStroke)
                        )
                        .background(
                            Theme.Shapes.textInputShape
                                .fill(Theme.Colors.textInputBackground)
                        )
                        
                        Button {
                            viewModel.router.showDiscoveryScreen(searchQuery: searchQuery, fromStartupScreen: true)
                        } label: {
                            Text(AuthLocalization.Startup.exploreAllCourses)
                                .underline()
                                .foregroundColor(Theme.Colors.accentColor)
                                .font(Theme.Fonts.bodyLarge)
                        }
                        .padding(.top, isHorizontal ? 0 : 5)
                        Spacer()
                    }
                    .padding(.horizontal, isHorizontal ? 10 : 24)
                    
                    LogistrationBottomView(viewModel: viewModel)
                }
                .padding(.top, 10)
                .padding(.bottom, 2)
            }
            .onDisappear {
                searchQuery = ""
            }
        }
        .hideNavigationBar()
        .padding(.all, isHorizontal ? 1 : 0)
        .background(Theme.Colors.background.ignoresSafeArea(.all))
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}

#if DEBUG
struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = StartupViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            analytics: AuthorizationAnalyticsMock()
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
