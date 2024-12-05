//
//  CreateNewThreadViewModel.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 03.11.2022.
//

import Core
import SwiftUI

@MainActor
public class CreateNewThreadViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var allTopics: [CoursewareTopics] = []
    @Published var selectedTopic: String = ""
    public var topics: Topics?

    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    public let interactor: DiscussionInteractorProtocol
    public let router: DiscussionRouter
    public let config: ConfigProtocol
    
    public init(
        interactor: DiscussionInteractorProtocol,
        router: DiscussionRouter,
        config: ConfigProtocol
    ) {
        self.interactor = interactor
        self.router = router
        self.config = config
    }
    
    @MainActor
    public func getTopics(courseID: String) async {
        guard allTopics.isEmpty else { return }
        isShowProgress = true
        do {
            topics = try await interactor.getTopics(courseID: courseID)
            if let topics {
                allTopics = topics.nonCoursewareTopics.map { $0 }
                allTopics.append(contentsOf: topics.coursewareTopics.flatMap { $0.children.map { $0 } })
                if selectedTopic == "" {
                    if let topic = allTopics.first {
                        selectedTopic = topic.id
                    }
                }
            }
        } catch {
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
        isShowProgress = false
    }
    
    @MainActor
    public func createNewThread(newThread: DiscussionNewThread) async -> Bool {
        isShowProgress = true
        do {
            try await interactor.createNewThread(newThread: newThread)
            isShowProgress = false
            router.back()
            return true
        } catch let error {
            isShowProgress = false
            if error.isInternetError {
                errorMessage = CoreLocalization.Error.slowOrNoInternetConnection
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
            return false
        }
    }
}
