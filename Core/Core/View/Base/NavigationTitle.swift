//
//  NavigationTitle.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.05.2024.
//

import SwiftUI
import Theme

public struct NavigationTitle: View {
    
    private let title: String
    private let backAction: () -> Void
    
    @Environment(\.isHorizontal) private var isHorizontal
    @EnvironmentObject var themeManager: ThemeManager
    
    public init(title: String, backAction: @escaping () -> Void) {
        self.title = title
        self.backAction = backAction
    }
    
    public var body: some View {
        // MARK: - Navigation and Title
        ZStack {
            HStack {
                Text(title)
                    .titleSettings(color: themeManager.theme.colors.loginNavigationText)
                    .accessibilityIdentifier("\(title)_text")
            }
            VStack {
                BackNavigationButton(
                    color: themeManager.theme.colors.loginNavigationText,
                    action: {
                        backAction()
                    }
                )
                .backViewStyle()
                .foregroundColor(themeManager.theme.colors.styledButtonText)
                .padding(.leading, isHorizontal ? 48 : 0)
                .accessibilityIdentifier("back_button")
                
            }.frame(minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .topLeading)
        }
    }
}

#Preview {
    NavigationTitle(title: "Title", backAction: {})
}
