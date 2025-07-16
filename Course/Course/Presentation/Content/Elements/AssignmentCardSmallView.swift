//
//  AssignmentCardSmallView.swift
//  Course
//
//  Created by Ivan Stepanok on 12.07.2025.
//

import SwiftUI
import Core
import Theme

struct AssignmentCardSmallView: View, Equatable {
    nonisolated static func == (lhs: AssignmentCardSmallView, rhs: AssignmentCardSmallView) -> Bool {
        lhs.index == rhs.index
    }
    
    let subsection: CourseProgressSubsection
    let index: Int
    let sectionName: String
    let isSelected: Bool
    let onTap: () -> Void
    let viewModel: CourseContainerViewModel
    
    private let cardWidth: CGFloat = 60
    private let cardHeight: CGFloat = 48
    
    private var status: AssignmentCardStatus {
        return viewModel.getAssignmentStatus(for: subsection)
    }
    
    private var assignmentShortName: String {
        return String(subsection.displayName.prefix(3)).uppercased()
    }
    
    private var isPastDue: Bool {
        guard let dueDate = viewModel.getAssignmentDeadline(for: subsection)?.date else { return false }
        return dueDate < Date() && subsection.numPointsEarned < subsection.numPointsPossible
    }
    
    var strokeColor: Color {
        if subsection.numPointsEarned >= subsection.numPointsPossible && subsection.numPointsPossible > 0 {
            return Theme.Colors.success
        } else if isPastDue {
            return Theme.Colors.alert
        } else {
            return Theme.Colors.assignmentColor
        }
    }
    
    private var completionBackgroundColor: Color {
        if subsection.numPointsEarned >= subsection.numPointsPossible && subsection.numPointsPossible > 0 {
            return Theme.Colors.success.opacity(0.1)
        } else {
            return Theme.Colors.cardViewBackground
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 8) {
                Text(assignmentShortName)
                    .font(Theme.Fonts.bodyMedium)
                    .foregroundColor(Theme.Colors.textPrimary)
                    .lineLimit(1)
            }
            .frame(width: cardWidth, height: cardHeight)
            .background(completionBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(
                        isSelected ? Theme.Colors.accentColor : strokeColor,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .cornerRadius(8)
            .overlay {
                ZStack(alignment: .center) {
                    if subsection.numPointsEarned >= subsection.numPointsPossible && subsection.numPointsPossible > 0 {
                        CoreAssets.assignmentsCheckbox.swiftUIImage
                            .frame(width: 20, height: 20)
                    } else if isPastDue {
                        CoreAssets.assignmentsClock.swiftUIImage
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .offset(y: -10)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
