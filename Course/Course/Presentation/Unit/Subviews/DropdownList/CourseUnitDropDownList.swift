//
//  CourseUnitDropDownList.swift
//  Course
//
//  Created by Vadim Kuznetsov on 4.12.23.
//

import Core
import SwiftUI
import Theme

struct CourseUnitDropDownList<Content>: View where Content: View {
    @ViewBuilder var content: () -> Content
    
    @State var height: CGFloat = 0
    
    var scrollViewHeight: CGFloat {
        height > 400 ? 400 : height
    }
    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 0) {
                    content()
                }
                .background(
                    GeometryReader { proxy in
                        Color.clear
                            .onAppear {
                                height = proxy.size.height
                            }
                    }
                )
            }
        }
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .frame(height: scrollViewHeight)
        .shadow(radius: 4)
    }
}

#if DEBUG
struct CourseUnitDropDownList_Previews: PreviewProvider {
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
                fallback: nil,
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
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
                fallback: nil,
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
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
                fallback: nil,
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
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
                fallback: nil,
                youtube: nil,
                desktopMP4: nil,
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
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
        
        CourseUnitDropDownList(content: {
            ForEach(verticals, id: \.id) { vertical in
                let isLast = verticals.last?.id == vertical.id
                CourseUnitDropDownCell(
                    vertical: vertical,
                    isLast: isLast,
                    isSelected: false
                ) {}
            }
        })
        .padding(10)
    }
}
#endif
