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

    private var dots: some View {
        HStack(spacing: 8) {
            ForEach(0 ..< numberOfPages) { page in
                RoundedRectangle(cornerRadius: 4)
                    .frame(width: page == currentPage ? 24 : 8, height: 8)
                    .foregroundColor(page == currentPage ? Theme.Colors.accentXColor : Theme.Colors.textInputStroke)
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
