//
//  DiscussionAnalytics.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 29.06.2023.
//

import Foundation

//sourcery: AutoMockable
public protocol DiscussionAnalytics {
    func discussionAllPostsClicked(courseId: String, courseName: String)
    func discussionFollowingClicked(courseId: String, courseName: String)
    func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String)
}

#if DEBUG
class DiscussionAnalyticsMock: DiscussionAnalytics {
    public func discussionAllPostsClicked(courseId: String, courseName: String) {}
    public func discussionFollowingClicked(courseId: String, courseName: String) {}
    public func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {}
}
#endif
