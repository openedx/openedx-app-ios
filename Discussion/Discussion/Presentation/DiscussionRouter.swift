//
//  DiscussionRouter.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation
import Core
import Combine

//sourcery: AutoMockable
@MainActor
public protocol DiscussionRouter: BaseRouter {
    
    func showUserDetails(username: String)
    
    func showThreads(
        courseID: String,
        topics: Topics,
        title: String,
        type: ThreadType,
        isBlackedOut: Bool,
        animated: Bool
    )

    func showThread(
        thread: UserThread,
        postStateSubject: CurrentValueSubject<PostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    )

    func showDiscussionsSearch(courseID: String, isBlackedOut: Bool)

    func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    )
    
    func createNewThread(courseID: String, selectedTopic: String, onPostCreated: @escaping () -> Void)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DiscussionRouterMock: BaseRouterMock, DiscussionRouter {
    
    public override init() {}
    
    public func showUserDetails(username: String) {}
    
    public func showThreads(
        courseID: String,
        topics: Topics,
        title: String,
        type: ThreadType,
        isBlackedOut: Bool,
        animated: Bool
    ) {}
    
    public func showThread(
        thread: UserThread,
        postStateSubject: CurrentValueSubject<PostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    ) {}

    public func showDiscussionsSearch(courseID: String, isBlackedOut: Bool) {}
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        isBlackedOut: Bool,
        animated: Bool
    ) {}

    public func createNewThread(
        courseID: String,
        selectedTopic: String,
        onPostCreated: @escaping () -> Void
    ) {}
}
#endif
