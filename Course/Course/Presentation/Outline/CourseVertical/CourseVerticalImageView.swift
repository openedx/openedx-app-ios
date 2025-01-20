//
//  CourseVerticalImageView.swift
//  Course
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import Core
import SwiftUI

struct CourseVerticalImageView: View {
    var blocks: [CourseBlock]

    var body: some View {
        if blocks.contains(where: { $0.type == .problem }) {
            return CoreAssets.pen.swiftUIImage.renderingMode(.template)
        } else if blocks.contains(where: { $0.type == .video }) {
            return CoreAssets.video.swiftUIImage.renderingMode(.template)
        } else if blocks.contains(where: { $0.type == .discussion }) {
            return CoreAssets.discussion.swiftUIImage.renderingMode(.template)
        } else if blocks.contains(where: { $0.type == .html }) {
            return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        } else {
            return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        }
    }
}
#if DEBUG
struct CourseVerticalImageView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks1 = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 1,
                type: .video,
                displayName: "Block 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: true,
                offlineDownload: nil
            )
        ]
        
        let blocks2 = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 1,
                type: .problem,
                displayName: "Block 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: false,
                offlineDownload: nil
            )
        ]
        let blocks3 = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 1,
                type: .discussion,
                displayName: "Block 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: true,
                offlineDownload: nil
            )
        ]
        let blocks4 = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 1,
                type: .html,
                displayName: "Block 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: false,
                offlineDownload: nil
            )
        ]
        let blocks5 = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 1,
                type: .unknown,
                displayName: "Block 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: true,
                offlineDownload: nil
            )
        ]
        HStack {
            CourseVerticalImageView(blocks: blocks1)
            CourseVerticalImageView(blocks: blocks2)
            CourseVerticalImageView(blocks: blocks3)
            CourseVerticalImageView(blocks: blocks4)
            CourseVerticalImageView(blocks: blocks5)
        }
    }
}
#endif
