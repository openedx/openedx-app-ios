//
//  VideoContentData.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.07.2025.
//

import SwiftUI
import Core

struct VideoContentData {
    let courseVideosStructure: CourseStructure?
    let courseProgress: CourseProgress?
    let sequentialsDownloadState: [String: DownloadViewState]
    let isShowProgress: Bool
    let showError: Bool
    let errorMessage: String?
    
    func clearError() -> VideoContentData {
        return VideoContentData(
            courseVideosStructure: courseVideosStructure,
            courseProgress: courseProgress,
            sequentialsDownloadState: sequentialsDownloadState,
            isShowProgress: isShowProgress,
            showError: false,
            errorMessage: nil
        )
    }
}

struct VideoSectionData {
    let chapter: CourseChapter
    let sequentialsDownloadState: [String: DownloadViewState]
}

struct VideoThumbnailData {
    let video: CourseBlock
    let chapter: CourseChapter
    let courseStructure: CourseStructure?
    let onVideoTap: (CourseBlock, CourseChapter) -> Void
}
