//
//  CompletedBlocks.swift
//  Course
//
//  Created by Ivan Stepanok on 09.12.2024.
//

import SwiftUI
import Core
import Theme

struct CompletedBlocks: View {
    @Binding var isExpanded: Bool
    let courseDateBlockDict: [Date: [CourseDateBlock]]
    let viewModel: CourseDatesViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // Toggle button to expand/collapse the cell
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    VStack(alignment: .leading) {
                        Text(CompletionStatus.completed.localized)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                        
                        if !isExpanded {
                            let totalCount = courseDateBlockDict.values.reduce(0) { $0 + $1.count }
                            let itemsHidden = totalCount == 1 ?
                            CourseLocalization.CourseDates.itemHidden :
                            CourseLocalization.CourseDates.itemsHidden
                            Text("\(totalCount) \(itemsHidden)")
                                .font(Theme.Fonts.labelMedium)
                                .foregroundColor(Theme.Colors.textPrimary)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                    .padding(.vertical, 8)
                    
                    Image(systemName: "chevron.down")
                        .labelStyle(.iconOnly)
                        .dropdownArrowRotationAnimation(value: isExpanded)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .padding()
                }
            }
            
            // Your expandable content goes here
            if isExpanded {
                VStack(alignment: .leading) {
                    ForEach(courseDateBlockDict.keys.sorted(), id: \.self) { date in
                        let blocks = courseDateBlockDict[date]!
                        let block = blocks[0]
                        
                        Spacer()
                        Text(block.formattedDate)
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        
                        ForEach(blocks) { block in
                            HStack(alignment: .top) {
                                block.blockImage?.swiftUIImage
                                    .foregroundColor(Theme.Colors.textPrimary)
                                CourseDateStyleBlock(block: block, viewModel: viewModel)
                                    .padding(.bottom, 15)
                                Spacer()
                                if block.canShowLink && !block.firstComponentBlockID.isEmpty {
                                    Image(systemName: "chevron.right")
                                        .resizable()
                                        .flipsForRightToLeftLayoutDirection(true)
                                        .scaledToFit()
                                        .frame(width: 6.55, height: 11.15)
                                        .labelStyle(.iconOnly)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                }
                            }
                            .padding(.trailing, 15)
                        }
                    }
                }
                .padding(.bottom, 15)
                .padding(.leading, 16)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
    }
}
