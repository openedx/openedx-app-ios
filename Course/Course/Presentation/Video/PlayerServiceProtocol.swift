//
//  PlayerServiceProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import SwiftUI

public protocol PlayerServiceProtocol {
    var router: CourseRouter { get }

    init(courseID: String, blockID: String, interactor: CourseInteractorProtocol, router: CourseRouter)
    func blockCompletionRequest() async throws
    func presentAppReview()
    func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View)
    func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle]
}

public class PlayerService: PlayerServiceProtocol {
    private let courseID: String
    private let blockID: String
    private let interactor: CourseInteractorProtocol
    public let router: CourseRouter
    
    public required init(
        courseID: String,
        blockID: String,
        interactor: CourseInteractorProtocol,
        router: CourseRouter
    ) {
        self.courseID = courseID
        self.blockID = blockID
        self.interactor = interactor
        self.router = router
    }
    
    @MainActor
    public func blockCompletionRequest() async throws {
        try await interactor.blockCompletionRequest(courseID: courseID, blockID: blockID)
        NotificationCenter.default.post(
            name: NSNotification.blockCompletion,
            object: nil
        )
    }

    @MainActor
    public func presentAppReview() {
        router.presentAppReview()
    }
    
    @MainActor
    public func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {
        router.presentView(transitionStyle: transitionStyle, animated: animated, content: content)
    }

    public func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle] {
        try await interactor.getSubtitles(
            url: url,
            selectedLanguage: selectedLanguage
        )
    }
}
