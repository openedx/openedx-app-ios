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
public protocol DiscussionRouter: BaseRouter {
    
    func showUserDetails(username: String)
    
    func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType, animated: Bool)

    func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>, animated: Bool)

    func showDiscussionsSearch(courseID: String)
    
    func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        animated: Bool
    )
    
    func createNewThread(courseID: String, selectedTopic: String, onPostCreated: @escaping () -> Void)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DiscussionRouterMock: BaseRouterMock, DiscussionRouter {
    
    public override init() {}
    
    public func showUserDetails(username: String) {}
    
    public func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType, animated: Bool) {}
    
    public func showThread(
        thread: UserThread,
        postStateSubject: CurrentValueSubject<PostState?, Never>,
        animated: Bool
    ) {}

    public func showDiscussionsSearch(courseID: String) {}
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>,
        animated: Bool
    ) {}

    public func createNewThread(
        courseID: String,
        selectedTopic: String,
        onPostCreated: @escaping () -> Void
    ) {}
}
#endif
