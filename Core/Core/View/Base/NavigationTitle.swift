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
    
    public init(title: String, backAction: @escaping () -> Void) {
        self.title = title
        self.backAction = backAction
    }
    
    public var body: some View {
        // MARK: - Navigation and Title
        ZStack {
            HStack {
                Text(title)
                    .titleSettings(color: Theme.Colors.loginNavigationText)
                    .accessibilityIdentifier("\(title)_text")
            }
            VStack {
                BackNavigationButton(
                    color: Theme.Colors.loginNavigationText,
                    action: {
                        backAction()
                    }
                )
                .backViewStyle()
                .foregroundColor(Theme.Colors.styledButtonText)
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
