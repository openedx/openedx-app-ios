//
//  LogistrationBottomView.swift
//  Authorization
//
//  Created by SaeedBashir on 10/26/23.
//

import Foundation
import SwiftUI
import Core
import Theme

public struct LogistrationBottomView: View {
    @ObservedObject
    private var viewModel: StartupViewModel
    private var sourceScreen: LogistrationSourceScreen
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: StartupViewModel, sourceScreen: LogistrationSourceScreen) {
        self.viewModel = viewModel
        self.sourceScreen = sourceScreen
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 24) {
                StyledButton(AuthLocalization.SignIn.registerBtn) {
                    viewModel.router.showRegisterScreen(sourceScreen: sourceScreen)
                    viewModel.tracksignUpClicked()
                }
                .frame(maxWidth: .infinity)
                
                StyledButton(
                    AuthLocalization.SignIn.logInTitle,
                    action: { viewModel.router.showLoginScreen(sourceScreen: sourceScreen) },
                    color: .white,
                    textColor: Theme.Colors.accentColor,
                    borderColor: Theme.Colors.textInputStroke
                )
                .frame(width: 100)
            }
            .padding(.horizontal, isHorizontal ? 0 :  0)
        }
        .padding(.horizontal, isHorizontal ? 10 : 24)
    }
}

#if DEBUG
struct LogistrationBottomView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = StartupViewModel(
            interactor: AuthInteractor.mock,
            router: AuthorizationRouterMock(),
            analytics: AuthorizationAnalyticsMock()
        )
        LogistrationBottomView(viewModel: vm, sourceScreen: .startup)
            .preferredColorScheme(.light)
            .previewDisplayName("StartupView Light")
            .loadFonts()
        
        LogistrationBottomView(viewModel: vm, sourceScreen: .startup)
            .preferredColorScheme(.dark)
            .previewDisplayName("StartupView Dark")
            .loadFonts()
    }
}
#endif
