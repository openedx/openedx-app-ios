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
        if let shortLabel = subsection.shortLabel, !shortLabel.isEmpty {
            return clearLabel(shortLabel)
        }
        
        guard let assignmentType = subsection.assignmentType else {
            return clearLabel(subsection.displayName)
        }

        return clearLabel(assignmentType)
    }
    
    private func clearLabel(_ text: String) -> String {
        let words = text.split(separator: " ")
        if let last = words.last, last.allSatisfy({ $0.isNumber }) {
            let rightRaw = String(last)
            let leftRaw = words.dropLast().joined(separator: " ")
            let leftLetters = leftRaw.filter { !$0.isNumber }
            let leftShort = String(leftLetters.prefix(3)).uppercased()
            
            let trimmed = rightRaw.trimmingCharacters(in: CharacterSet(charactersIn: "0"))
            let rightClean = trimmed.isEmpty ? "0" : trimmed
            
            return leftShort + rightClean
        } else {
            let leftLetters = text.filter { !$0.isNumber }
            return String(leftLetters.prefix(3)).uppercased()
        }
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
                url: "https://example.com",
                shortLabel: "HW1 01"
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
                url: "https://example.com",
                shortLabel: "HW1 02"
            ),
            index: 1,
            sectionName: "Labs",
            isSelected: .constant(true),
            onTap: {},
            viewModel: CourseContainerViewModel.mock
        )
    }
    .padding()
}
#endif
