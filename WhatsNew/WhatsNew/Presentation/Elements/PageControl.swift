//
//  PageControl.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 18.10.2023.
//

import SwiftUI
import Core
import Theme

struct PageControl: View {
    let numberOfPages: Int
    var currentPage: Int
    @EnvironmentObject var themeManager: ThemeManager
    
    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< numberOfPages) { page in
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: page == currentPage ? 24 : 8, height: 8)
                    .foregroundColor(page == currentPage ? themeManager.theme.colors.accentXColor : themeManager.theme.colors.textSecondaryLight)
            }
        }
    }

    var body: some View {
        VStack {
            Spacer()
            dots
            Spacer()
        }
    }
}
