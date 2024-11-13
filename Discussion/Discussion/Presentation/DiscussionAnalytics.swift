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
    
    func discussionCreateNewPost(
        courseID: String,
        topicID: String,
        postType: String,
        followPost: Bool,
        author: String
    )
    
    func discussionResponseAdded(
        courseID: String,
        threadID: String,
        responseID: String,
        author: String
    )
    
    func discussionCommentAdded(
        courseID: String,
        threadID: String,
        responseID: String,
        commentID: String,
        author: String
    )
    
    func discussionFollowToggle(
        courseID: String,
        threadID: String,
        author: String,
        follow: Bool
    )
    
    func discussionLikeToggle(
        courseID: String,
        threadID: String,
        responseID: String?,
        commentID: String?,
        author: String,
        discussionType: String,
        like: Bool
    )
    
    func discussionReportToggle(
        courseID: String,
        threadID: String,
        responseID: String?,
        commentID: String?,
        author: String,
        discussionType: String,
        report: Bool
    )
    
}

#if DEBUG
class DiscussionAnalyticsMock: DiscussionAnalytics {
    public func discussionAllPostsClicked(courseId: String, courseName: String) {}
    public func discussionFollowingClicked(courseId: String, courseName: String) {}
    public func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {}
    
    public func discussionCreateNewPost(
        courseID: String,
        topicID: String,
        postType: String,
        followPost: Bool,
        author: String
    ) {}
    
    public func discussionResponseAdded(
        courseID: String,
        threadID: String,
        responseID: String,
        author: String
    ) {}
    
    public func discussionCommentAdded(
        courseID: String,
        threadID: String,
        responseID: String,
        commentID: String,
        author: String
    ) {}
    
    public func discussionFollowToggle(
        courseID: String,
        threadID: String,
        author: String,
        follow: Bool
    ) {}
    
    public func discussionLikeToggle(
        courseID: String,
        threadID: String,
        responseID: String? = nil,
        commentID: String? = nil,
        author: String,
        discussionType: String,
        like: Bool
    ) {}
    
    public func discussionReportToggle(
        courseID: String,
        threadID: String,
        responseID: String? = nil,
        commentID: String? = nil,
        author: String,
        discussionType: String,
        report: Bool
    ) {}
}
#endif
