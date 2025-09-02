//
//  NoContentAvailable.swift
//  Course
//
//  Created by Ivan Stepanok on 05.07.2025.
//

import SwiftUI
import Core
import Theme

enum NoContentType {
    case video
    case assignments
}

struct NoContentAvailable: View {
    
    private let type: NoContentType
    private let action: () -> Void
    private var showButton: Bool = true

    init(
        type: NoContentType,
        action: @escaping () -> Void,
        showButton: Bool = true
    ) {
        self.type = type
        self.action = action
        self.showButton = showButton
    }
    
    var body: some View {
        
        VStack(spacing: 16) {
            Spacer()

            CoreAssets.iconWarning.swiftUIImage

            Text(type == .video
                 ? CourseLocalization.Error.videosUnavailable
                 :CourseLocalization.Error.assignmentsUnavailable
            )
            .font(Theme.Fonts.titleMedium)
            .foregroundColor(Theme.Colors.textPrimary)
            .multilineTextAlignment(.center)

            if showButton {
                StyledButton(
                    CourseLocalization.Course.returnToHome,
                    action: action,
                    iconImage: CoreAssets.arrowLeft.swiftUIImage,
                    iconPosition: .left
                )
            }

            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        
    }
}
