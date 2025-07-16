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
        guard let assignmentType = subsection.assignmentType else {
            return String(subsection.displayName.prefix(3)).uppercased()
                .filter { !$0.isNumber && !$0.isWhitespace } + String(index+1)
        }
        
        // Get shortLabel from assignment policy
        if let shortLabel = viewModel.getAssignmentShortLabel(for: assignmentType) {
            // If shortLabel is 3-4 characters, use it as is
            if shortLabel.count <= 4 {
                return shortLabel.filter { !$0.isNumber && !$0.isWhitespace }.uppercased() + String(index+1)
            } else {
                // If longer, take first 3 characters
                return shortLabel.filter { !$0.isNumber && !$0.isWhitespace }
                    .prefix(3)
                    .uppercased()
                + String(index+1)
            }
        }
        
        // Fallback to first 3 characters of displayName
        return String(subsection.displayName.prefix(3)).uppercased()
            .filter { !$0.isNumber && !$0.isWhitespace } + String(index+1)
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
