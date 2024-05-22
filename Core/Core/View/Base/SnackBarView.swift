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
    var bgColor: Color
    var textColor: Color
    
    private var safeArea: CGFloat {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.safeAreaInsets.bottom ?? 0
    }
    
    private let minHeight: CGFloat = 50
    
    public init(message: String?, textColor: Color = Theme.Colors.snackbarTextColor, bgColor: Color = Theme.Colors.snackbarErrorColor, action: (() -> Void)? = nil) {
        self.message = message ?? ""
        self.action = action
        self.textColor = textColor
        self.bgColor = bgColor
    }
    
    public var body: some View {
        HStack {
            Text(message)
                .font(Theme.Fonts.titleSmall)
                .foregroundColor(textColor)
                .accessibilityIdentifier("snackbar_text")
            Spacer()
            
            if let action = action {
                Button(CoreLocalization.View.Snackbar.tryAgainBtn) {
                    action()
                }
                .font(Theme.Fonts.titleSmall)
                .accessibilityIdentifier("snackbar_button")
            }
            
        }.shadowCardStyle(bgColor: bgColor,
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
