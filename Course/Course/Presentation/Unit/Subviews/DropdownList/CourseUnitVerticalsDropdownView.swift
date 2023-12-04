//
//  CourseUnitVerticalsDropdownView.swift
//  Course
//
//  Created by Vadim Kuznetsov on 4.12.23.
//

import Core
import SwiftUI

struct CourseUnitVerticalsDropdownView: View {
    var verticals: [CourseVertical]
    var currentIndex: Int
    var offsetY: CGFloat
    @Binding var showDropdown: Bool
    var action: (CourseVertical) -> Void
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.clear
                .contentShape(Rectangle())
                .onTapGesture {
                    showDropdown.toggle()
                }
            CourseUnitDropDownList(content: {
                ForEach(verticals, id: \.id) { vertical in
                    let isLast = verticals.last?.id == vertical.id
                    let isSelected = vertical.id == verticals[currentIndex].id
                    CourseUnitDropDownCell(
                        vertical: vertical,
                        isLast: isLast,
                        isSelected: isSelected
                    ) {
                        action(vertical)
                    }
                }
            })
            .offset(y: offsetY)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .transition(.opacity)
    }
}
