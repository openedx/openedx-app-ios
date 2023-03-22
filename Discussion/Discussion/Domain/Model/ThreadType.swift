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
