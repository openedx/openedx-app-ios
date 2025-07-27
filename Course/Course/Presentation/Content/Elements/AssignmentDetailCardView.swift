//
//  AssignmentDetailCardView.swift
//  Course
//
//  Created by Ivan Stepanok on 12.07.2025.
//

import SwiftUI
import Core
import Theme

struct AssignmentDetailCardView: View, Equatable {
    nonisolated static func == (lhs: AssignmentDetailCardView, rhs: AssignmentDetailCardView) -> Bool {
        lhs.sectionName == rhs.sectionName &&
        lhs.subsectionUI.subsection.blockKey == rhs.subsectionUI.subsection.blockKey
    }
    
    let subsectionUI: CourseProgressSubsectionUI
    let sectionName: String
    let viewModel: CourseContainerViewModel
    
    private var status: AssignmentCardStatus {
        return subsectionUI.status
    }
    
    private var statusText: String {
        return subsectionUI.statusText
    }
    
    private var cardBackgroundColor: Color {
        switch status {
        case .completed:
            return Theme.Colors.success.opacity(0.1)
        case .pastDue:
            return Theme.Colors.warning.opacity(0.1)
        case .notAvailable:
            return Theme.Colors.textSecondary.opacity(0.1)
        default:
            return Theme.Colors.background
        }
    }
    
    private var cardBorderColor: Color {
        switch status {
        case .completed:
            return Theme.Colors.success
        case .pastDue:
            return Theme.Colors.warning
        case .notAvailable:
            return Theme.Colors.textSecondary
        default:
            return Theme.Colors.cardViewStroke
        }
    }
    
    var body: some View {
        Button(action: {
            viewModel.navigateToAssignment(for: subsectionUI.subsection)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(subsectionUI.sequenceName)
                        .font(Theme.Fonts.bodyLarge)
                        .foregroundColor(Theme.Colors.textPrimary)
                    HStack {
                        Text(statusText)
                            .font(Theme.Fonts.bodySmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right")
                            .foregroundColor(Theme.Colors.accentColor)
                            .font(.title2)
                    }
                }
            }
            .padding(.all, 16)
            .background(cardBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 4)
                    .stroke(cardBorderColor, lineWidth: 2)
                    .overlay {
                        CustomProgressShape(cornerRadius: 4)
                            .fill(cardBorderColor)
                            .frame(height: 5)
                            .frame(maxHeight: .infinity, alignment: .top)
                    }
            )
            .cornerRadius(4)
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 24)
        .id(viewModel.assignmentProgressUpdateTrigger)
    }
}
