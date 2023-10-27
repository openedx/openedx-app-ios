//
//  AuthWelcomeBackView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

public struct AuthWelcomeBackView: View {

    let title: String
    let text: String

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(Theme.Fonts.displaySmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.bottom, 4)
            Text(text)
                .font(Theme.Fonts.titleSmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.bottom, 20)
        }
    }
    
}
