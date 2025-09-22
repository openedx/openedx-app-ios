//
//  CourseDateStyleBlock.swift
//  Course
//
//  Created by Ivan Stepanok on 09.12.2024.
//

import SwiftUI
import Core
import Theme

struct CourseDateStyleBlock: View {
    let block: CourseDateBlock
    let viewModel: CourseDatesViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            styleBlock(block: block)
            if !block.description.isEmpty {
                Text(block.description)
                    .font(Theme.Fonts.labelMedium)
                    .foregroundStyle(Theme.Colors.thisWeekTimelineColor)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
    
    func styleBlock(block: CourseDateBlock) -> some View {
        var attributedString = AttributedString("")
        
        if let prefix = block.assignmentType, !prefix.isEmpty {
            attributedString += AttributedString("\(prefix): ")
        }
        
        attributedString += styleTitle(block: block)
        
        return Text(attributedString)
            .font(Theme.Fonts.titleSmall)
            .lineLimit(1)
            .foregroundStyle({
                if block.isAssignment {
                    return block.isAvailable ? Theme.Colors.textPrimary : Color.gray.opacity(0.6)
                } else {
                    return Theme.Colors.textPrimary
                }
            }())
            .onTapGesture {
                if block.canShowLink && !block.firstComponentBlockID.isEmpty {
                    Task {
                        await viewModel.showCourseDetails(
                            componentID: block.firstComponentBlockID,
                            blockLink: block.link
                        )
                    }
                    viewModel.logdateComponentTapped(block: block, supported: true)
                } else {
                    viewModel.logdateComponentTapped(block: block, supported: false)
                }
            }
    }
    
    func styleTitle(block: CourseDateBlock) -> AttributedString {
        var attributedString = AttributedString(block.title)
        attributedString.font = Theme.Fonts.titleSmall
        return attributedString
    }
}
