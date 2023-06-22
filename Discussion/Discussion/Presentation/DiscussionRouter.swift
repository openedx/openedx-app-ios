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
    
    func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType)
    
    func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>)
    
    func showDiscussionsSearch(courseID: String)
    
    func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
    )
    
    func createNewThread(courseID: String, selectedTopic: String, onPostCreated: @escaping () -> Void)
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DiscussionRouterMock: BaseRouterMock, DiscussionRouter {
    
    public override init() {}
    
    public func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType) {}
    
    public func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>) {}
    
    public func showDiscussionsSearch(courseID: String) {}
    
    public func showComments(
        commentID: String,
        parentComment: Post,
        threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>
    ) {}

    public func createNewThread(
        courseID: String,
        selectedTopic: String,
        onPostCreated: @escaping () -> Void
    ) {}
}
#endif
