//
//  PlayerServiceProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import SwiftUI

@MainActor
public protocol PlayerServiceProtocol: Sendable {
    var router: CourseRouter { get }

    init(courseID: String, blockID: String, interactor: CourseInteractorProtocol, router: CourseRouter)
    func blockCompletionRequest() async throws
    func presentAppReview()
    func presentView(
        transitionStyle: UIModalTransitionStyle,
        animated: Bool,
        content: @MainActor () -> any View
    )
    func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle]
}

public final class PlayerService: PlayerServiceProtocol {
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
    
    public func blockCompletionRequest() async throws {
        NotificationCenter.default.post(name: .onblockCompletionRequested, object: courseID)
        try await interactor.blockCompletionRequest(courseID: courseID, blockID: blockID)
        NotificationCenter.default.post(
            name: NSNotification.blockCompletion,
            object: nil
        )
    }

    public func presentAppReview() {
        router.presentAppReview()
    }
    
    public func presentView(
        transitionStyle: UIModalTransitionStyle,
        animated: Bool,
        content: @MainActor () -> any View
    ) {
        router.presentView(transitionStyle: transitionStyle, animated: animated, content: content)
    }

    public func getSubtitles(url: String, selectedLanguage: String) async throws -> [Subtitle] {
        try await interactor.getSubtitles(
            url: url,
            selectedLanguage: selectedLanguage
        )
    }
}
