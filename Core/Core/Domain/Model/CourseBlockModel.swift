//
//  CourseBlockModel.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.03.2023.
//

import Foundation

public struct CourseStructure: Equatable {
    public static func == (lhs: CourseStructure, rhs: CourseStructure) -> Bool {
        return lhs.id == rhs.id
    }

    public let id: String
    public let graded: Bool
    public let completion: Double
    public let viewYouTubeUrl: String
    public let encodedVideo: String
    public let displayName: String
    public let topicID: String?
    public let childs: [CourseChapter]
    public let media: DataLayer.CourseMedia //FIXME Domain model
    public let certificate: Certificate?
    
    public init(
        id: String,
        graded: Bool,
        completion: Double,
        viewYouTubeUrl: String,
        encodedVideo: String,
        displayName: String,
        topicID: String? = nil,
        childs: [CourseChapter],
        media: DataLayer.CourseMedia,
        certificate: Certificate?
    ) {
        self.id = id
        self.graded = graded
        self.completion = completion
        self.viewYouTubeUrl = viewYouTubeUrl
        self.encodedVideo = encodedVideo
        self.displayName = displayName
        self.topicID = topicID
        self.childs = childs
        self.media = media
        self.certificate = certificate
    }

    public var blocksTotalSizeInBytes: Int {
        childs.flatMap {
            $0.childs.flatMap { $0.childs.flatMap { $0.childs.compactMap { $0 } } }
        }
        .filter { $0.isDownloadable }
        .compactMap { $0.video?.fileSize }
        .reduce(.zero) { $0 + $1 }
    }

    public var blocksTotalSizeInMb: Double {
        Double(blocksTotalSizeInBytes) / 1024.0 / 1024.0
    }

    public var blocksTotalSizeInGb: Double {
        Double(blocksTotalSizeInBytes) / 1024.0 / 1024.0 / 1024.0
    }

}

public struct CourseChapter: Identifiable {

    public let blockId: String
    public let id: String
    public let displayName: String
    public let type: BlockType
    public let childs: [CourseSequential]
    
    public init(
        blockId: String,
        id: String,
        displayName: String,
        type: BlockType,
        childs: [CourseSequential]
    ) {
        self.blockId = blockId
        self.id = id
        self.displayName = displayName
        self.type = type
        self.childs = childs
    }
}

public struct CourseSequential: Identifiable {

    public let blockId: String
    public let id: String
    public let displayName: String
    public let type: BlockType
    public let completion: Double
    public let childs: [CourseVertical]
    
    public var isDownloadable: Bool {
        return childs.first(where: { $0.isDownloadable }) != nil
    }
    
    public init(
        blockId: String,
        id: String,
        displayName: String,
        type: BlockType,
        completion: Double,
        childs: [CourseVertical]
    ) {
        self.blockId = blockId
        self.id = id
        self.displayName = displayName
        self.type = type
        self.completion = completion
        self.childs = childs
    }
}

public struct CourseVertical: Identifiable {
    public let blockId: String
    public let id: String
    public let courseId: String
    public let displayName: String
    public let type: BlockType
    public let completion: Double
    public let childs: [CourseBlock]
    
    public var isDownloadable: Bool {
        return childs.first(where: { $0.isDownloadable }) != nil
    }

    public var blocksTotalSizeInGb: Double {
        let total = childs.reduce(0) { $0 + Double($1.video?.fileSize ?? 0) }
        return total / 1024 / 1024 / 1024
    }

    public init(
        blockId: String,
        id: String,
        courseId: String,
        displayName: String,
        type: BlockType,
        completion: Double,
        childs: [CourseBlock]
    ) {
        self.blockId = blockId
        self.id = id
        self.courseId = courseId
        self.displayName = displayName
        self.type = type
        self.completion = completion
        self.childs = childs
    }
}

public struct SubtitleUrl: Equatable {
    public let language: String
    public let url: String
    
    public init(language: String, url: String) {
        self.language = language
        self.url = url
    }
}

public struct CourseBlock: Equatable {
    public let blockId: String
    public let id: String
    public let courseId: String
    public let topicId: String?
    public let graded: Bool
    public let completion: Double
    public let type: BlockType
    public let displayName: String
    public let studentUrl: String
    public let subtitles: [SubtitleUrl]?
    public let fallback: CourseBlockVideo?
    public let desktopMP4: CourseBlockVideo?
    public let mobileHigh: CourseBlockVideo?
    public let mobileLow: CourseBlockVideo?
    public let hls: CourseBlockVideo?
    public let youTube: CourseBlockVideo?

    public var isDownloadable: Bool {
        return video?.url != nil
    }

    public var video: CourseBlockVideo? {
        fallback ?? hls ?? desktopMP4 ?? mobileHigh ?? mobileLow
    }

    public var youTubeUrl: String? {
        youTube?.url
    }

    public init(
        blockId: String,
        id: String,
        courseId: String,
        topicId: String? = nil,
        graded: Bool,
        completion: Double,
        type: BlockType,
        displayName: String,
        studentUrl: String,
        subtitles: [SubtitleUrl]? = nil,
        fallback: CourseBlockVideo?,
        youTube: CourseBlockVideo?,
        desktopMP4: CourseBlockVideo?,
        mobileHigh: CourseBlockVideo?,
        mobileLow: CourseBlockVideo?,
        hls: CourseBlockVideo?
    ) {
        self.blockId = blockId
        self.id = id
        self.courseId = courseId
        self.topicId = topicId
        self.graded = graded
        self.completion = completion
        self.type = type
        self.displayName = displayName
        self.studentUrl = studentUrl
        self.subtitles = subtitles
        self.fallback = fallback
        self.youTube = youTube
        self.desktopMP4 = desktopMP4
        self.mobileHigh = mobileHigh
        self.mobileLow = mobileLow
        self.hls = hls
    }
}

public struct CourseBlockVideo: Equatable {
    public let url: String?
    public let fileSize: Int?
    public let streamPriority: Int?

    public init(url: String?, fileSize: Int?, streamPriority: Int?) {
        self.url = url
        self.fileSize = fileSize
        self.streamPriority = streamPriority
    }
}
