//
//  ContinueWithView.swift
//  Course
//
//  Created by  Stepanok Ivan on 29.05.2023.
//

import SwiftUI
import Core

struct ContinueWith {
    let chapterIndex: Int
    let sequentialIndex: Int
    let verticalIndex: Int
}

struct ContinueWithView: View {
    private let data: ContinueWith
    private let courseStructure: CourseStructure
    private let action: () -> Void
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(data: ContinueWith, courseStructure: CourseStructure, action: @escaping () -> Void) {
        self.data = data
        self.courseStructure = courseStructure
        self.action = action
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            let chapter = courseStructure.childs[data.chapterIndex]
            if let vertical = chapter.childs[data.sequentialIndex].childs.first {
                if idiom == .pad {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            ContinueTitle(vertical: vertical)
                        }.foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                        Spacer()
                        UnitButtonView(type: .continueLesson, action: action)
                            .frame(width: 200)
                    } .padding(.horizontal, 24)
                        .padding(.top, 32)
                } else {
                    VStack(alignment: .leading) {
                        ContinueTitle(vertical: vertical)
                            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                    }
                    UnitButtonView(type: .continueLesson, action: action)
                }
                
            }
        }.padding(.horizontal, 24)
            .padding(.top, 32)
    }
}

private struct ContinueTitle: View {
    
    let vertical: CourseVertical
    
    var body: some View {
        Text(CoreLocalization.Courseware.continueWith)
            .font(Theme.Fonts.labelMedium)
            .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
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
        
        let childs = [
            CourseChapter(
                blockId: "123",
                id: "123",
                displayName: "Continue lesson",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "1",
                        id: "1",
                        displayName: "Name",
                        type: .sequential,
                        completion: 0,
                        childs: [
                            CourseVertical(
                                blockId: "1",
                                id: "1",
                                courseId: "123",
                                displayName: "Vertical",
                                type: .vertical,
                                completion: 0,
                                childs: [
                                    CourseBlock(
                                        blockId: "2",
                                        id: "2",
                                        courseId: "123",
                                        graded: true,
                                        completion: 0,
                                        type: .html,
                                        displayName: "Continue lesson",
                                        studentUrl: "")
                                ])])])
        ]
        
        ContinueWithView(
            data: ContinueWith(chapterIndex: 0, sequentialIndex: 0, verticalIndex: 0),
            courseStructure: CourseStructure(
                id: "123",
                graded: true,
                completion: 0,
                viewYouTubeUrl: "",
                encodedVideo: "",
                displayName: "Namaste",
                childs: childs,
                media: DataLayer.CourseMedia(
                    image: .init(raw: "", small: "", large: "")
                ),
                certificate: nil)
        ) {
        }
    }
}
#endif
