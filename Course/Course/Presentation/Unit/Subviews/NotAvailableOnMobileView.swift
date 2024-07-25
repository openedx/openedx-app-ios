//
//  NotAvailableOnMobileView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Theme

public struct NotAvailableOnMobileView: View {
    let url: String
    
    public init(url: String) {
        self.url = url
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 10) {
                Spacer()
                CoreAssets.notAvaliable.swiftUIImage
                Text(CourseLocalization.NotAvaliable.title)
                    .font(Theme.Fonts.titleLarge)
                    .multilineTextAlignment(.center)
                    .padding(.top, 40)
                Text(CourseLocalization.NotAvaliable.description)
                    .font(Theme.Fonts.bodyLarge)
                    .multilineTextAlignment(.center)
                    .padding(.top, 12)
                StyledButton(CourseLocalization.NotAvaliable.button, action: {
                    if let url = URL(string: url), UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                })
                .frame(width: 215)
                .padding(.top, 40)
                Spacer()
            }
            .padding(24)
        }
        .navigationBarHidden(false)
    }
}
