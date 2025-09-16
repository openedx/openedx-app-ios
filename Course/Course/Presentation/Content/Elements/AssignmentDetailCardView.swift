//
//  AssignmentDetailCardView.swift
//  Course
//
//  Created by Ivan Stepanok on 12.07.2025.
//

import SwiftUI
import Core
import Theme

struct AssignmentDetailCardView: View {
    
    let detailData: AssignmentDetailData
    
    private var subsectionUI: CourseProgressSubsectionUI {
        detailData.subsectionUI
    }
    
    private var sectionName: String {
        detailData.sectionName
    }
    
    private var status: AssignmentCardStatus {
        return subsectionUI.status
    }
    
    private var statusText: String {
        return subsectionUI.statusText
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
            detailData.onAssignmentTap(subsectionUI)
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    
                    Text(detailData.sectionName)
                                .font(Theme.Fonts.labelMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                    
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
                            .flipsForRightToLeftLayoutDirection(true)
                    }
                }
            }
            .padding(.all, 16)
            .background(ThemeAssets.tabbarBGColor.swiftUIColor)
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
    }
}
