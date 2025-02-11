//
//  CourseDetailBlock.swift
//  Core
//
//  Created by Vladimir Chekyrta on 12.10.2022.
//

import Foundation
import SwiftUI

public protocol CourseDetailBlock {
    var id: String { get set }
    var graded: Bool { get set }
    var isCompleted: Bool { get set }
    var viewHTMLUrl: String { get set }
    var viewYouTubeUrl: String? { get set }
    var encodedVideo: String? { get set }
    var displayName: String { get set }
    var moduleName: String { get set }
    var type: BlockType { get }
    var topicID: String? { get }
    var blocks: [CourseDetailBlock]? { get set }
}

public struct StudentViewData {
    public let topicID: String
    
    public enum CodingKeys: String, CodingKey {
        case topicID = "topic_id"
    }
}

public enum BlockType: String, Sendable {
    case course
    case sequential
    case vertical
    case html
    case discussion
    case chapter
    case video
    case problem
    case survey
    case unknown
    case dragAndDropV2 = "drag-and-drop-v2"
    case openassessment
    case peerInstructionTool = "ubcpi"
    
    public var image: Image {
        switch self {
        case .problem: return CoreAssets.pen.swiftUIImage.renderingMode(.template)
        case .video: return CoreAssets.video.swiftUIImage.renderingMode(.template)
        case .html: return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        case .discussion: return CoreAssets.discussion.swiftUIImage.renderingMode(.template)
        case .course: return CoreAssets.pen.swiftUIImage.renderingMode(.template)
        case .chapter: return CoreAssets.pen.swiftUIImage.renderingMode(.template)
        case .sequential: return CoreAssets.chapter.swiftUIImage.renderingMode(.template)
        case .vertical: return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        default: return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        }
    }
}

#if DEBUG
public struct DemoLesson: CourseDetailBlock {
    public var id: String
    public var graded: Bool
    public var isCompleted: Bool
    public var viewHTMLUrl: String
    public var viewYouTubeUrl: String?
    public var encodedVideo: String?
    public var displayName: String
    public var moduleName: String
    public var type: BlockType
    public var topicID: String?
    public var blocks: [CourseDetailBlock]?
    
    public init(id: String,
                graded: Bool,
                isCompleted: Bool,
                viewHTMLUrl: String,
                viewYouTubeUrl: String? = nil,
                encodedVideo: String? = nil,
                displayName: String,
                moduleName: String,
                type: BlockType,
                topicID: String? = nil,
                blocks: [CourseDetailBlock]? = nil) {
        self.id = id
        self.graded = graded
        self.isCompleted = isCompleted
        self.viewHTMLUrl = viewHTMLUrl
        self.viewYouTubeUrl = viewYouTubeUrl
        self.encodedVideo = encodedVideo
        self.displayName = displayName
        self.moduleName = moduleName
        self.type = type
        self.topicID = topicID
        self.blocks = blocks
    }
}
#endif
