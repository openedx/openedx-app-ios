//
//  ContinueWithView.swift
//  Course
//
//  Created by  Stepanok Ivan on 29.05.2023.
//

import SwiftUI
import Core
import Theme

struct ContinueWith {
    let chapterIndex: Int
    let sequentialIndex: Int
    let verticalIndex: Int
    let lastVisitedBlockId: String
}

struct ContinueWithView: View {
    private let data: ContinueWith
    private let action: () -> Void
    private let courseContinueUnit: CourseVertical
    
    init(data: ContinueWith, courseContinueUnit: CourseVertical, action: @escaping () -> Void) {
        self.data = data
        self.action = action
        self.courseContinueUnit = courseContinueUnit
    }
    
    var body: some View {
        // MARK: - New Continue Button Design
        Button(action: action) {
            HStack {
                Text(courseContinueUnit.displayName)
                    .font(Theme.Fonts.titleMedium)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                
                Spacer()
                
                HStack(spacing: 8) {
                    Text(CoreLocalization.Courseware.continue)
                        .font(Theme.Fonts.labelLarge)
                        .foregroundColor(.white)
                    
                    CoreAssets.arrowLeft.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .rotationEffect(Angle.degrees(180))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(Theme.Colors.accentColor)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 24)
    }
}

#if DEBUG
#Preview {
    let blocks = [
        CourseBlock(
            blockId: "1",
            id: "1",
            courseId: "123",
            graded: true,
            due: Date(),
            completion: 0,
            type: .html,
            displayName: "Continue lesson",
            studentUrl: "",
            webUrl: "",
            encodedVideo: nil,
            multiDevice: true,
            offlineDownload: nil
        ),
        CourseBlock(
            blockId: "2",
            id: "2",
            courseId: "123",
            graded: true,
            due: Date(),
            completion: 0,
            type: .html,
            displayName: "Continue lesson",
            studentUrl: "",
            webUrl: "",
            encodedVideo: nil,
            multiDevice: false,
            offlineDownload: nil
            
        )
    ]
    
    ContinueWithView(
        data: ContinueWith(
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            lastVisitedBlockId: "test_block_id"
        ),
        courseContinueUnit: CourseVertical(
            blockId: "2",
            id: "2",
            courseId: "123",
            displayName: "Second Unit",
            type: .vertical,
            completion: 1,
            childs: blocks,
            webUrl: ""
        )
    ) { }
        .loadFonts()
}
#endif
