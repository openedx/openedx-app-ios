//
//  DiscussionNewThread.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation

public struct DiscussionNewThread: Sendable {
    public let courseID: String
    public let topicID: String
    public let type: PostType
    public let title: String
    public let rawBody: String
    public let followPost: Bool
    
    public init(courseID: String, topicID: String, type: PostType, title: String, rawBody: String, followPost: Bool) {
        self.courseID = courseID
        self.topicID = topicID
        self.type = type
        self.title = title
        self.rawBody = rawBody
        self.followPost = followPost
    }
}
