//
//  DiscussionTopic.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation

public enum DiscussionTopicStyle: Sendable {
    case title
    case basic
    case followed
    case subTopic
}

public struct DiscussionTopic {
   public let name: String
   public let action: (() -> Void)
   public let style: DiscussionTopicStyle
    
    public init(name: String, action: @escaping () -> Void, style: DiscussionTopicStyle) {
        self.name = name
        self.action = action
        self.style = style
    }
}

public struct Topics: Sendable {
    public let coursewareTopics: [CoursewareTopics]
    public let nonCoursewareTopics: [CoursewareTopics]
    
    public init(coursewareTopics: [CoursewareTopics], nonCoursewareTopics: [CoursewareTopics]) {
        self.coursewareTopics = coursewareTopics
        self.nonCoursewareTopics = nonCoursewareTopics
    }
}

public struct CoursewareTopics: Hashable, Identifiable, Sendable {
    public let id: String
    public let name: String
    public let threadListURL: String
    public let children: [CoursewareTopics]
    
    public init(id: String, name: String, threadListURL: String, children: [CoursewareTopics]) {
        self.id = id
        self.name = name.isEmpty ? DiscussionLocalization.Topics.unnamed : name
        self.threadListURL = threadListURL
        self.children = children
    }
}
