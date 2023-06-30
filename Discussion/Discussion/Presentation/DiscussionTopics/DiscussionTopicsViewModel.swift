//
//  DiscussionViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 13.10.2022.
//

import Foundation
import SwiftUI
import Core
import FirebaseCrashlytics

public class DiscussionTopicsViewModel: ObservableObject {
    
    @Published var topics: Topics?
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var discussionTopics: [DiscussionTopic]?
    @Published var courseID: String = ""
    private var title: String
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    let interactor: DiscussionInteractorProtocol
    let router: DiscussionRouter
    let analyticsManager: DiscussionAnalytics
    let config: Config
    
    public init(title: String,
                interactor: DiscussionInteractorProtocol,
                router: DiscussionRouter,
                analyticsManager: DiscussionAnalytics,
                config: Config) {
        self.title = title
        self.interactor = interactor
        self.router = router
        self.analyticsManager = analyticsManager
        self.config = config
    }
    
    func generateTopics(topics: Topics?) -> [DiscussionTopic] {
        var result = [
            DiscussionTopic(
                name: DiscussionLocalization.Topics.allPosts,
                action: {
                    self.analyticsManager.discussionAllPostsClicked(courseId: self.courseID,
                                                               courseName: "")
                    self.router.showThreads(
                        courseID: self.courseID,
                        topics: topics ?? Topics(coursewareTopics: [], nonCoursewareTopics: []),
                        title: DiscussionLocalization.Topics.allPosts,
                        type: .allPosts)
                },
                style: .basic
            ),
            DiscussionTopic(
                name: DiscussionLocalization.Topics.postImFollowing, action: {
                    self.router.showThreads(
                        courseID: self.courseID,
                        topics: topics ?? Topics(coursewareTopics: [], nonCoursewareTopics: []),
                        title: DiscussionLocalization.Topics.postImFollowing,
                        type: .followingPosts
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
                            self.router.showThreads(
                                courseID: self.courseID,
                                topics: topics,
                                title: t.name,
                                type: .nonCourseTopics)
                            
                        },
                        style: .basic)
                )
                for children in t.children {
                    result.append(
                        DiscussionTopic(
                            name: children.name,
                            action: {
                                self.router.showThreads(
                                    courseID: self.courseID,
                                    topics: topics,
                                    title: t.name,
                                    type: .nonCourseTopics
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
                                self.router.showThreads(
                                    courseID: self.courseID,
                                    topics: topics,
                                    title: child.name,
                                    type: .courseTopics(topicID: child.id)
                                )
                            },
                            style: .subTopic)
                    )
                }
            }
        }
        return result
    }
    
    @MainActor
    public func getTopics(courseID: String, withProgress: Bool = true) async {
        self.courseID = courseID
        isShowProgress = withProgress
        do {
            topics = try await interactor.getTopics(courseID: courseID)
            discussionTopics = generateTopics(topics: topics)
            isShowProgress = false
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}
