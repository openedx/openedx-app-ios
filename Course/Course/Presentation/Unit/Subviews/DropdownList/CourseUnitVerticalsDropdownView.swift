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
                .simultaneousGesture(
                    DragGesture()
                        .onChanged { _ in
                            if showDropdown { showDropdown.toggle() }
                        }
                )
            CourseUnitDropDownList(content: {
                ForEach(verticals, id: \.id) { vertical in
                    let isLast = verticals.last?.id == vertical.id
                    let isSelected = vertical.id == verticals[currentIndex].id
                    CourseUnitDropDownCell(
                        vertical: vertical,
                        isLast: isLast,
                        isSelected: isSelected
                    ) {
                        if isSelected {
                            showDropdown.toggle()
                            return
                        }
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

#if DEBUG
struct CourseUnitVerticalsDropdownView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                completion: 0,
                type: .video,
                displayName: "Lesson 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: true

            ),
            CourseBlock(
                blockId: "2",
                id: "2",
                courseId: "123",
                topicId: "2",
                graded: false,
                completion: 0,
                type: .video,
                displayName: "Lesson 2",
                studentUrl: "2",
                webUrl: "2",
                encodedVideo: nil,
                multiDevice: false

            ),
            CourseBlock(
                blockId: "3",
                id: "3",
                courseId: "123",
                topicId: "3",
                graded: false,
                completion: 0,
                type: .unknown,
                displayName: "Lesson 3",
                studentUrl: "3",
                webUrl: "3",
                encodedVideo: nil,
                multiDevice: true

            ),
            CourseBlock(
                blockId: "4",
                id: "4",
                courseId: "123",
                topicId: "4",
                graded: false,
                completion: 0,
                type: .unknown,
                displayName: "4",
                studentUrl: "4",
                webUrl: "4",
                encodedVideo: nil,
                multiDevice: false
            )
        ]
        
        let verticals = [
            CourseVertical(
                blockId: "1",
                id: "1",
                courseId: "123",
                displayName: "First Unit",
                type: .vertical,
                completion: 0,
                childs: blocks
            ),
            CourseVertical(
                blockId: "2",
                id: "2",
                courseId: "123",
                displayName: "Second Unit",
                type: .vertical,
                completion: 1,
                childs: blocks
            ),
            CourseVertical(
                blockId: "3",
                id: "3",
                courseId: "123",
                displayName: "Third Unit",
                type: .vertical,
                completion: 0,
                childs: blocks
            ),
            CourseVertical(
                blockId: "4",
                id: "4",
                courseId: "123",
                displayName: "Fourth Unit",
                type: .vertical,
                completion: 1,
                childs: blocks
            )
        ]
        
        CourseUnitVerticalsDropdownView(
            verticals: verticals,
            currentIndex: 0,
            offsetY: 0,
            showDropdown: .constant(true)
        ) {_ in }
        .padding(10)
    }
}
#endif
