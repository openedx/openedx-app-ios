//
//  CourseUnitDropDownCell.swift
//  Course
//
//  Created by Vadim Kuznetsov on 4.12.23.
//

import Core
import SwiftUI
import Theme

struct CourseUnitDropDownCell: View {
    var vertical: CourseVertical
    var isLast: Bool = false
    var isSelected: Bool = false
    var action: () -> Void
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                action()
            }, label: {
                HStack {
                    Group {
                        VStack {
                            if vertical.completion == 1 {
                                CoreAssets.finished.swiftUIImage
                                    .renderingMode(.template)
                                    .foregroundColor(Theme.Colors.accentXColor)
                            }
                        }
                        .frame(width: 25)
                        Text(vertical.displayName)
                            .font(Theme.Fonts.titleSmall)
                            .lineLimit(1)
                            .frame(alignment: .leading)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        CourseVerticalImageView(blocks: vertical.childs)
                    }
                    .foregroundColor(Theme.Colors.textPrimary)
                }
            })
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            if !isLast {
                Divider()
                    .frame(height: 1)
                    .overlay(Theme.Colors.cardViewStroke)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 0)
            }
        }
        .padding(0)
        .background(
            isSelected ? Color.secondary.opacity(0.2) : Color.clear
        )

    }
}

#if DEBUG
struct CourseUnitDropDownCell_Previews: PreviewProvider {
    static var previews: some View {
        let vertical = CourseVertical(
            blockId: "1",
            id: "1",
            courseId: "123",
            displayName: "Lesson 1",
            type: .vertical,
            completion: 1,
            childs: [
                CourseBlock(
                    blockId: "1",
                    id: "1",
                    courseId: "123",
                    topicId: "1",
                    graded: false,
                    due: Date(),
                    completion: 1,
                    type: .video,
                    displayName: "Lesson 1",
                    studentUrl: "",
                    webUrl: "",
                    encodedVideo: nil,
                    multiDevice: true
                )
            ]
        )
               
        CourseUnitDropDownCell(
            vertical: vertical,
            isLast: false,
            isSelected: false,
            action: {}
        )
    }
}
#endif
