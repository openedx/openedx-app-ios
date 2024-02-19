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
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(data: ContinueWith, courseContinueUnit: CourseVertical, action: @escaping () -> Void) {
        self.data = data
        self.action = action
        self.courseContinueUnit = courseContinueUnit
    }
    
    var body: some View {
        VStack(alignment: .leading) {
                if idiom == .pad {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ContinueTitle(vertical: courseContinueUnit)
                        }.foregroundColor(Theme.Colors.textPrimary)
                        Spacer()
                        UnitButtonView(type: .continueLesson, action: action)
                            .frame(width: 200)
                    } .padding(.horizontal, 24)
                        .padding(.top, 32)
                } else {
                    VStack(alignment: .leading) {
                        ContinueTitle(vertical: courseContinueUnit)
                            .foregroundColor(Theme.Colors.textPrimary)
                    }
                    UnitButtonView(type: .continueLesson, action: action)
                }
        }.padding(.horizontal, 24)
            .padding(.top, 32)
    }
}

private struct ContinueTitle: View {
    
    let vertical: CourseVertical
    
    var body: some View {
        Text(CoreLocalization.Courseware.resumeWith)
            .font(Theme.Fonts.labelMedium)
            .foregroundColor(Theme.Colors.textSecondary)
        HStack {
            vertical.type.image
            Text(vertical.displayName)
                .multilineTextAlignment(.leading)
                .font(Theme.Fonts.titleMedium)
                .multilineTextAlignment(.leading)
        }
    }
    
}

#if DEBUG
struct ContinueWithView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                graded: true,
                completion: 0,
                type: .html,
                displayName: "Continue lesson",
                studentUrl: "",
                encodedVideo: nil,
                multiDevice: true
            ),
            CourseBlock(
                blockId: "2",
                id: "2",
                courseId: "123",
                graded: true,
                completion: 0,
                type: .html,
                displayName: "Continue lesson",
                studentUrl: "",
                encodedVideo: nil,
                multiDevice: false

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
                childs: blocks
            )
        ) { }
    }
}
#endif
