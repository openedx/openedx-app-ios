//
//  LogistrationBottomView.swift
//  Authorization
//
//  Created by SaeedBashir on 10/26/23.
//

import Foundation
import SwiftUI
import Theme

public enum LogistrationSourceScreen: Equatable {
    case `default`
    case startup
    case discovery
    case courseDetail(String, String)
    case programDetails(String)
}

public enum LogistrationAction {
    case signIn
    case signInWithSSO
    case register
}

public struct LogistrationBottomView: View {
    private let action: (LogistrationAction) -> Void
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(_ action: @escaping (LogistrationAction) -> Void) {
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 24) {
                StyledButton(CoreLocalization.SignIn.registerBtn) {
                    action(.register)
                }
                .accessibilityIdentifier("logistration_register_button")
                
                StyledButton(
                    CoreLocalization.SignIn.logInBtn,
                    action: {
                        action(.signIn)
                    },
                    color: Theme.Colors.secondaryButtonBGColor,
                    textColor: Theme.Colors.secondaryButtonTextColor,
                    borderColor: Theme.Colors.secondaryButtonBorderColor
                )
                .frame(width: 100)
                .accessibilityIdentifier("logistration_signin_button")
                
                StyledButton(
                    CoreLocalization.SignIn.logInWithSsoBtn,
                    action: {
                        action(.signInWithSSO)
                    },
                    color: Theme.Colors.white,
                    textColor: Theme.Colors.secondaryButtonTextColor,
                    borderColor: Theme.Colors.secondaryButtonBorderColor
                )
                .frame(width: 100)
                .accessibilityIdentifier("logistration_signin_withsso_button")
            }
            .padding(.horizontal, isHorizontal ? 0 :  0)
        }
        .padding(.horizontal, isHorizontal ? 10 : 24)
    }
}

#if DEBUG
struct LogistrationBottomView_Previews: PreviewProvider {
    static var previews: some View {
        LogistrationBottomView {_ in }
            .preferredColorScheme(.light)
            .previewDisplayName("StartupView Light")
            .loadFonts()
        
        LogistrationBottomView {_ in }
            .preferredColorScheme(.dark)
            .previewDisplayName("StartupView Dark")
            .loadFonts()
    }
}
#endif
