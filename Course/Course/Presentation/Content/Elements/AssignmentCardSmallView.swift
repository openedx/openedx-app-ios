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
    
    let subsectionUI: CourseProgressSubsectionUI
    let index: Int
    let sectionName: String
    @Binding var isSelected: Bool
    let onTap: () -> Void
    let assignmentTypeColors: [String: String]
    
    private let cardWidth: CGFloat = 60
    private let cardHeight: CGFloat = 48
    
    private var status: AssignmentCardStatus {
        return subsectionUI.status
    }
    
    private var cardID: String {
        "\(index)-\(isSelected)"
    }
    
    private var assignmentShortName: String {
        if !subsectionUI.shortLabel.isEmpty {
            return clearShortLabel(subsectionUI.shortLabel)
        }
        
        guard let assignmentType = subsectionUI.subsection.assignmentType else {
            return clearShortLabel(subsectionUI.subsection.displayName)
        }

        return clearShortLabel(assignmentType)
    }
    
    private var isPastDue: Bool {
        return status == .pastDue
    }
    
    private var strokeColor: Color {
        if isSelected {
            return Theme.Colors.accentColor
        } else if subsectionUI.status == .completed {
            return Theme.Colors.success
        } else if isPastDue {
            return Theme.Colors.warning
        } else {
            return Theme.Colors.assignmentColor
        }
    }
    
    private var completionBackgroundColor: Color {
        if subsectionUI.subsection.numPointsEarned >= subsectionUI.subsection.numPointsPossible
            && subsectionUI.subsection.numPointsPossible > 0 {
            return Theme.Colors.success.opacity(0.1)
        } else if isPastDue {
            return Theme.Colors.warning.opacity(0.1)
        } else {
            return Theme.Colors.cardViewBackground
        }
    }
    
    init(
        subsectionUI: CourseProgressSubsectionUI,
        index: Int,
        sectionName: String,
        isSelected: Binding<Bool>,
        onTap: @escaping () -> Void,
        assignmentTypeColors: [String: String]
    ) {
        self.subsectionUI = subsectionUI
        self.index = index
        self.sectionName = sectionName
        self._isSelected = isSelected
        self.onTap = onTap
        self.assignmentTypeColors = assignmentTypeColors
    }
    
    func clearShortLabel(_ text: String) -> String {
        let words = text.split(separator: " ")

        guard let last = words.last, last.allSatisfy(\.isNumber) else {
            let letters = text.filter { !$0.isNumber }
            return String(letters.prefix(3)).uppercased()
        }

        let rightRaw = String(last)
        let leftRaw  = words.dropLast().joined(separator: " ")
        let leftShort = String(leftRaw.filter { !$0.isNumber }.prefix(3)).uppercased()
        let rightClean = String(Int(rightRaw) ?? 0)

        return leftShort + rightClean
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
                    if subsectionUI.subsection.numPointsEarned >= subsectionUI.subsection.numPointsPossible
                        && subsectionUI.subsection.numPointsPossible > 0 {
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
        .id(cardID)
            
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
            subsectionUI: CourseProgressSubsectionUI(
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
                statusText: "Not Started",
                sequenceName: "Test Assignment",
                status: .incomplete,
                shortLabel: "HW1 01"
            ),
            index: 0,
            sectionName: "Labs",
            isSelected: .constant(false),
            onTap: {},
            assignmentTypeColors: [:]
        )
        
        AssignmentCardSmallView(
            subsectionUI: CourseProgressSubsectionUI(
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
                statusText: "Not Started",
                sequenceName: "Test Assignment 2",
                status: .incomplete,
                shortLabel: "HW1 02"
            ),
            index: 1,
            sectionName: "Labs",
            isSelected: .constant(true),
            onTap: {},
            assignmentTypeColors: [:]
        )
    }
    .padding()
}
#endif
