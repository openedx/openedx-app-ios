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
    @EnvironmentObject var themeManager: ThemeManager
    
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
                    }.foregroundColor(themeManager.theme.colors.textPrimary)
                    Spacer()
                    UnitButtonView(type: .continueLesson, action: action)
                        .frame(width: 200)
                        .environmentObject(themeManager)
                }
                .padding(.horizontal, 24)
            } else {
                VStack(alignment: .leading) {
                    ContinueTitle(vertical: courseContinueUnit)
                        .foregroundColor(themeManager.theme.colors.textPrimary)
                }
                UnitButtonView(type: .continueLesson, action: action)
                    .environmentObject(themeManager)
            }
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
}

private struct ContinueTitle: View {
    @EnvironmentObject var themeManager: ThemeManager
    let vertical: CourseVertical
    
    var body: some View {
        Text(CoreLocalization.Courseware.resumeWith)
            .font(Theme.Fonts.labelMedium)
            .foregroundColor(themeManager.theme.colors.textSecondary)
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
    }
}
#endif
