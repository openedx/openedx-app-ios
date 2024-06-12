//
//  PaymentSnakbarView.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

public struct PaymentSnakbarView: View {
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(CoreLocalization.CourseUpgrade.Snackbar.title)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
            
            Text(CoreLocalization.CourseUpgrade.Snackbar.successMessage)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(20)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
        .clipShape(
            RoundedRectangle(cornerRadius: 8)
        )
        .padding(16)
    }
}

#if DEBUG
#Preview {
    PaymentSnakbarView()
}
#endif
