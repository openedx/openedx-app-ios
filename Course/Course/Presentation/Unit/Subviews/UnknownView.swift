//
//  UnknownView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Theme

struct UnknownView: View {
    let url: String
    let viewModel: CourseUnitViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            CoreAssets.notAvaliable.swiftUIImage
            Text(CourseLocalization.NotAvaliable.title)
                .font(Theme.Fonts.titleLarge)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            Text(CourseLocalization.NotAvaliable.description)
                .font(Theme.Fonts.bodyLarge)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
            StyledButton(CourseLocalization.NotAvaliable.button, action: {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            })
            .frame(width: 215)
            .padding(.top, 40)
        }
        .padding(24)
    }
}
