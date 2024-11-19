//
//  ThreadType.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation

public enum ThreadType: Sendable {
    case allPosts
    case followingPosts
    case nonCourseTopics
    case courseTopics(topicID: String)
}

public enum ThreadsFilter: Identifiable, Sendable {
    public var id: String {
        localizedValue
    }
    
    case allThreads
    case unread
    case unanswered

    var localizedValue: String {
        switch self {
        case .allThreads:
            return DiscussionLocalization.Posts.Filter.allPosts
        case .unread:
            return DiscussionLocalization.Posts.Filter.unread
        case .unanswered:
            return DiscussionLocalization.Posts.Filter.unanswered
        }
    }
}

public enum SortType: Identifiable, Sendable {
    public var id: String {
        localizedValue
    }
    
    case recentActivity
    case mostActivity
    case mostVotes

    var localizedValue: String {
        switch self {
        case .recentActivity:
            return DiscussionLocalization.Posts.Sort.recentActivity
        case .mostActivity:
            return DiscussionLocalization.Posts.Sort.mostActivity
        case .mostVotes:
            return DiscussionLocalization.Posts.Sort.mostVotes
        }
    }
}
