//
//  MessageSectionView.swift
//  Course
//
//  Created by  Stepanok Ivan on 03.04.2024.
//

import SwiftUI
import Core
import Theme

public struct MessageSectionView: View {
    
    private let title: String
    private let actionTitle: String
    private var action: (() -> Void) = {}
    
    public init(
        title: String,
        actionTitle: String,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.actionTitle = actionTitle
        self.action = action
    }
    
    public var body: some View {
        HStack(alignment: .top, spacing: 8) {
            CoreAssets.badge.swiftUIImage
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(Theme.Colors.textPrimary)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(Theme.Fonts.bodyMicro)
                    .foregroundColor(Theme.Colors.textPrimary)
                
                Button(action: {
                    action()
                }, label: {
                    Text(actionTitle)
                        .font(Theme.Fonts.bodyMicro)
                        .underline()
                        .foregroundColor(Theme.Colors.textPrimary)
                })
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        .padding(.all, 12)
        .background(RoundedRectangle(cornerRadius: 8)
            .stroke(lineWidth: 1)
            .fill(Theme.Colors.textInputStroke)
        )
    }
}

#Preview {
    MessageSectionView(
        title: "Congratulations, you have earned this course certificate in “Course Title.”",
        actionTitle: "View Certificate",
        action: {
        }
    )
    .loadFonts()
}
