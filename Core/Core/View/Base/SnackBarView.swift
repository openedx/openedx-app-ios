//
//  SnackBarView.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import SwiftUI
import Theme

public struct SnackBarView: View {
    
    var message: String
    var action: (() -> Void)?
    
    private var safeArea: CGFloat {
        UIApplication.shared.oexKeyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    private let minHeight: CGFloat = 50
    
    public init(message: String?, action: (() -> Void)? = nil) {
        self.message = message ?? ""
        self.action = action
    }
    
    public var body: some View {
        HStack {
            Text(message)
                .font(Theme.Fonts.titleSmall)
                .foregroundColor(Theme.Colors.snackbarTextColor)
                .accessibilityIdentifier("snackbar_text")
            Spacer()
            
            if let action = action {
                Button(CoreLocalization.View.Snackbar.tryAgainBtn) {
                    action()
                }
                .font(Theme.Fonts.titleSmall)
                .accessibilityIdentifier("snackbar_button")
            }
            
        }.shadowCardStyle(bgColor: Theme.Colors.snackbarErrorColor,
                          textColor: Theme.Colors.white)
        .padding(.bottom, 10)
    }
}

struct SnackBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SnackBarView(message: "Text message", action: nil)
                .previewLayout(PreviewLayout.sizeThatFits)
                .previewDisplayName("Just text")
            
            SnackBarView(message: "Text message", action: {
                
            })
             .previewLayout(PreviewLayout.sizeThatFits)
            .previewDisplayName("With action button")
        }
    }
}
