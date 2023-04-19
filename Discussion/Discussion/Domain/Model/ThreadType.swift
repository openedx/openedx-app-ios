//
//  ThreadType.swift
//  Discussion
//
//  Created by Vladimir Chekyrta on 13.02.2023.
//

import Foundation

public enum ThreadType {
    case allPosts
    case followingPosts
    case nonCourseTopics
    case courseTopics(topicID: String)
}

public enum ThreadsFilter {
    case allThreads
    case unread
    case unanswered
}

public enum SortType {
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
