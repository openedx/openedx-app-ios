//
//  DiscussionViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Core

// swiftlint:disable function_body_length
@MainActor
public final class DiscussionTopicsViewModel: ObservableObject {
    
    @Published var topics: Topics?
    @Published var isShowProgress = true
    @Published var isShowRefresh = false
    @Published var showError: Bool = false
    @Published var discussionTopics: [DiscussionTopic]?
    @Published var courseID: String = ""
    @Published  private(set) var isBlackedOut: Bool = false
    let title: String
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let interactor: DiscussionInteractorProtocol
    let router: DiscussionRouter
    let analytics: DiscussionAnalytics
    let config: ConfigProtocol

    public init(
        title: String,
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        analytics: DiscussionAnalytics,
        config: ConfigProtocol
    ) {
        self.title = title
        self.interactor = interactor
        self.router = router
        self.analytics = analytics
        self.config = config
    }

    func generateTopics(topics: Topics?) -> [DiscussionTopic] {
        var result = [
            DiscussionTopic(
                name: DiscussionLocalization.Topics.allPosts,
                action: {
                    self.analytics.discussionAllPostsClicked(
                        courseId: self.courseID,
                        courseName: self.title
                    )
                    self.router.showThreads(
                        courseID: self.courseID,
                        topics: topics ?? Topics(coursewareTopics: [], nonCoursewareTopics: []),
                        title: DiscussionLocalization.Topics.allPosts,
                        type: .allPosts,
                        isBlackedOut: self.isBlackedOut,
                        animated: true
                    )
                },
                style: .basic
            ),
            DiscussionTopic(
                name: DiscussionLocalization.Topics.postImFollowing,
                action: {
                    self.analytics.discussionFollowingClicked(
                        courseId: self.courseID,
                        courseName: self.title
                    )
                    self.router.showThreads(
                        courseID: self.courseID,
                        topics: topics ?? Topics(coursewareTopics: [], nonCoursewareTopics: []),
                        title: DiscussionLocalization.Topics.postImFollowing,
                        type: .followingPosts,
                        isBlackedOut: self.isBlackedOut,
                        animated: true
                    )
                },
                style: .followed)
        ]
        if let topics = topics {
            for t in topics.nonCoursewareTopics {
                result.append(
                    DiscussionTopic(
                        name: t.name,
                        action: {
                            self.analytics.discussionTopicClicked(
                                courseId: self.courseID,
                                courseName: self.title,
                                topicId: t.id,
                                topicName: t.name
                            )
                            self.router.showThreads(
                                courseID: self.courseID,
                                topics: topics,
                                title: t.name,
                                type: .nonCourseTopics,
                                isBlackedOut: self.isBlackedOut,
                                animated: true
                            )
                        },
                        style: .basic)
                )
                for children in t.children {
                    result.append(
                        DiscussionTopic(
                            name: children.name,
                            action: {
                                self.analytics.discussionTopicClicked(
                                    courseId: self.courseID,
                                    courseName: self.title,
                                    topicId: t.id,
                                    topicName: t.name
                                )
                                self.router.showThreads(
                                    courseID: self.courseID,
                                    topics: topics,
                                    title: t.name,
                                    type: .nonCourseTopics,
                                    isBlackedOut: self.isBlackedOut,
                                    animated: true
                                )
                            },
                            style: .subTopic)
                    )
                }
            }
            for t in topics.coursewareTopics {
                result.append(
                    DiscussionTopic(
                        name: t.name,
                        action: {},
                        style: .title)
                )
                for child in t.children {
                    result.append(
                        DiscussionTopic(
                            name: child.name,
                            action: {
                                self.analytics.discussionTopicClicked(
                                    courseId: self.courseID,
                                    courseName: self.title,
                                    topicId: child.id,
                                    topicName: child.name
                                )
                                self.router.showThreads(
                                    courseID: self.courseID,
                                    topics: topics,
                                    title: child.name,
                                    type: .courseTopics(topicID: child.id),
                                    isBlackedOut: self.isBlackedOut,
                                    animated: true
                                )
                            },
                            style: .subTopic)
                    )
                }
            }
        }
        return result
    }

    public func getTopics(courseID: String, withProgress: Bool = true) async {
        self.courseID = courseID
        isShowProgress = withProgress
        isShowRefresh = !withProgress
        do {
            let discussionInfo = try await interactor.getCourseDiscussionInfo(courseID: courseID)
            isBlackedOut = discussionInfo.isBlackedOut()
             
            topics = try await interactor.getTopics(courseID: courseID)
            discussionTopics = generateTopics(topics: topics)
            isShowProgress = false
            isShowRefresh = false
        } catch {
            isShowProgress = false
            isShowRefresh = false
            discussionTopics = nil
        }
    }
}
// swiftlint:enable function_body_length
