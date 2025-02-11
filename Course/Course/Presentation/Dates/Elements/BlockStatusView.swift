//
//  BlockStatusView.swift
//  Course
//
//  Created by Ivan Stepanok on 09.12.2024.
//

import SwiftUI
import Core
import Theme

struct BlockStatusView: View {
    let viewModel: CourseDatesViewModel
    let block: CourseDateBlock
    let blocks: [CourseDateBlock]
    
    var body: some View {
        VStack(alignment: .leading) {
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
            .padding(.top, 0.2)
        }
    }
}
