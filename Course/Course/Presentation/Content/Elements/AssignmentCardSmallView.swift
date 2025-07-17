//
//  AssignmentCardSmallView.swift
//  Course
//
//  Created by Ivan Stepanok on 12.07.2025.
//

import SwiftUI
import Core
import Theme

struct AssignmentCardSmallView: View {
    
    let subsection: CourseProgressSubsection
    let index: Int
    let sectionName: String
    @Binding var isSelected: Bool
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
        if let shortLabel = viewModel.getAssignmentShortLabel(for: assignmentType), shortLabel != "" {
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
        return String(sectionName.prefix(3)).uppercased()
            .filter { !$0.isNumber && !$0.isWhitespace } + String(index+1)
    }
    
    private var isPastDue: Bool {
        guard let dueDate = viewModel.getAssignmentDeadline(for: subsection)?.date else { return false }
        return dueDate < Date() && subsection.numPointsEarned < subsection.numPointsPossible
    }
    
    private var strokeColor: Color {
        if isSelected {
            return Theme.Colors.accentColor
        } else if subsection.numPointsEarned >= subsection.numPointsPossible && subsection.numPointsPossible > 0 {
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
    
    init(
        subsection: CourseProgressSubsection,
        index: Int,
        sectionName: String,
        isSelected: Binding<Bool>,
        onTap: @escaping () -> Void,
        viewModel: CourseContainerViewModel
    ) {
        self.subsection = subsection
        self.index = index
        self.sectionName = sectionName
        self._isSelected = isSelected
        self.onTap = onTap
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 2) {
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
                RoundedRectangle(cornerRadius: 4)
                    .stroke(
                        strokeColor,
                        lineWidth: isSelected ? 2 : 1
                    )
            )
            .cornerRadius(4)
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
        .id("\(index)-\(isSelected)")
            
            // MARK: Selection pointer
            CoreAssets.pointer.swiftUIImage
                .opacity(isSelected ? 1 : 0)
        }
    }
}

#if DEBUG
#Preview {
    HStack {
        AssignmentCardSmallView(
            subsection: CourseProgressSubsection(
                assignmentType: "1",
                blockKey: "block1",
                displayName: "Test Assignment",
                hasGradedAssignment: true,
                override: nil,
                learnerHasAccess: true,
                numPointsEarned: 0.0,
                numPointsPossible: 1.0,
                percentGraded: 0.0,
                problemScores: [],
                showCorrectness: "always",
                showGrades: true,
                url: "https://example.com"
            ),
            index: 0,
            sectionName: "Labs",
            isSelected: .constant(false),
            onTap: {},
            viewModel: CourseContainerViewModel.mock
        )
        
        AssignmentCardSmallView(
            subsection: CourseProgressSubsection(
                assignmentType: "1",
                blockKey: "block2",
                displayName: "Test Assignment 2",
                hasGradedAssignment: true,
                override: nil,
                learnerHasAccess: true,
                numPointsEarned: 0.0,
                numPointsPossible: 1.0,
                percentGraded: 0.0,
                problemScores: [],
                showCorrectness: "always",
                showGrades: true,
                url: "https://example.com"
            ),
            index: 1,
            sectionName: "Labs",
            isSelected: .constant(true),
            onTap: {},
            viewModel: CourseContainerViewModel.mock
        )
    }
    .padding()
    .previewLayout(.sizeThatFits)
}
#endif
