//
//  AppReviewButton.swift
//  Core
//
//  Created by  Stepanok Ivan on 31.10.2023.
//

import SwiftUI
import Theme

struct AppReviewButton: View {
    let type: ButtonType
    let action: () -> Void
    @Binding var isActive: Bool
    
    enum ButtonType {
        case submit, shareFeedback, rateUs
    }
    
    var body: some View {
        Button(
            action: {
                if isActive { action() }
            },
            label: {
                Group {
                    HStack(spacing: 4) {
                        Text(
                            type == .submit
                            ? CoreLocalization.Review.Button.submit
                            : (
                                type == .shareFeedback
                                ? CoreLocalization.Review.Button.shareFeedback
                                : CoreLocalization.Review.Button.rateUs
                            )
                        )
                        .foregroundColor(isActive ? Color.white : Color.black.opacity(0.6))
                        .font(Theme.Fonts.labelLarge)
                        .padding(3)
                        
                    }.padding(.horizontal, 20)
                        .padding(.vertical, 9)
                }.fixedSize()
                    .background(
                        isActive
                        ? Theme.Colors.accentColor
                        : Theme.Colors.cardViewStroke
                    )
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(
                        type == .submit
                        ? CoreLocalization.Review.Button.submit
                        : (
                            type == .shareFeedback
                            ? CoreLocalization.Review.Button.shareFeedback
                            : CoreLocalization.Review.Button.rateUs
                        )
                    )
                    .cornerRadius(8)
            }
        )
    }
}
