//
//  DiscussionTopicsViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 31.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class DiscussionTopicsViewModelTests: XCTestCase {
    
    let topics = Topics(coursewareTopics: [
        CoursewareTopics(id: "1", name: "1", threadListURL: "1", children: [
            CoursewareTopics(id: "11", name: "11", threadListURL: "11", children: [])
        ]),
        CoursewareTopics(id: "2", name: "2", threadListURL: "2", children: [
            CoursewareTopics(id: "22", name: "22", threadListURL: "22", children: [])
        ]),
        CoursewareTopics(id: "3", name: "3", threadListURL: "3", children: [
            CoursewareTopics(id: "33", name: "33", threadListURL: "33", children: [])
        ])
    ], nonCoursewareTopics: [
        CoursewareTopics(id: "4", name: "4", threadListURL: "4", children: [
            CoursewareTopics(id: "44", name: "44", threadListURL: "44", children: [])
        ]),
        CoursewareTopics(id: "5", name: "5", threadListURL: "5", children: [
            CoursewareTopics(id: "55", name: "55", threadListURL: "55", children: [])
        ]),
        CoursewareTopics(id: "6", name: "6", threadListURL: "6", children: [
            CoursewareTopics(id: "66", name: "66", threadListURL: "66", children: [])
        ])
    ])

    let discussionInfo = DiscussionInfo(discussionID: "1", blackouts: [])

    func testGetTopicsSuccess() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let analytics = DiscussionAnalyticsMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(title: "",
                                                  interactor: interactor,
                                                  router: router,
                                                  analytics: analytics,
                                                  config: config)

        Given(interactor, .getTopics(courseID: .any, willReturn: topics))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willReturn: discussionInfo))

        await viewModel.getTopics(courseID: "1")

        Verify(interactor, .getTopics(courseID: .any))
        Verify(interactor, .getCourseDiscussionInfo(courseID: .any))

        XCTAssertNotNil(viewModel.topics)
        XCTAssertNotNil(viewModel.discussionTopics)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetTopicsNoInternetError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let analytics = DiscussionAnalyticsMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(title: "",
                                                  interactor: interactor,
                                                  router: router,
                                                  analytics: analytics,
                                                  config: config)

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getTopics(courseID: .any, willThrow: noInternetError))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willReturn: discussionInfo))

        await viewModel.getTopics(courseID: "1")
        
        Verify(interactor, .getCourseDiscussionInfo(courseID: .any))
        Verify(interactor, .getTopics(courseID: .any))

        XCTAssertNil(viewModel.topics)
        XCTAssertNil(viewModel.discussionTopics)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.isShowRefresh)
    }
    
    func testGetTopicsUnknownError() async throws {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let analytics = DiscussionAnalyticsMock()
        let config = ConfigMock()
        let viewModel = DiscussionTopicsViewModel(title: "",
                                                  interactor: interactor,
                                                  router: router,
                                                  analytics: analytics,
                                                  config: config)
        
        Given(interactor, .getTopics(courseID: .any, willThrow: NSError()))
        Given(interactor, .getCourseDiscussionInfo(courseID: .any, willReturn: discussionInfo))

        await viewModel.getTopics(courseID: "1")
        
        Verify(interactor, .getCourseDiscussionInfo(courseID: .any))
        Verify(interactor, .getTopics(courseID: .any))

        XCTAssertNil(viewModel.topics)
        XCTAssertNil(viewModel.discussionTopics)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.isShowRefresh)
    }
}
