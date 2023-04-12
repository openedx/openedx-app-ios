//
//  VideoPlayerViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 12.04.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

final class VideoPlayerViewModelTests: XCTestCase {
    
    let subtitlesString = """
0
00:00:00,350 --> 00:00:05,230
GREGORY NAGY: In hour zero, where I try to introduce Homeric poetry to
1
00:00:05,230 --> 00:00:11,060
people who may never have been exposed to the Iliad and the Odyssey even in
2
00:00:11,060 --> 00:00:20,290
translation, my idea was to get a sense of the medium, which is not a
3
00:00:20,290 --> 00:00:25,690
readable medium because Homeric poetry, in its historical context, was
4
00:00:25,690 --> 00:00:30,210
meant to be heard, not read.
5
00:00:30,210 --> 00:00:34,760
And there are various ways of describing it-- call it oral poetry or
"""

    func testGetSubtitlesSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
                
        Given(interactor, .getSubtitles(url: .any, willReturn: subtitlesString))
        
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        
        Verify(interactor, .getSubtitles(url: .any))
        
        XCTAssertEqual(viewModel.subtitles.first!.text, viewModel.parseSubtitles(from: subtitlesString).first!.text)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetSubtitlesOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        
                
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getSubtitles(url: .any, willReturn: subtitlesString))
        
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        
        Verify(interactor, .getSubtitles(url: .any))
        
        XCTAssertEqual(viewModel.subtitles.first!.text, viewModel.parseSubtitles(from: subtitlesString).first!.text)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGenerates() async {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        viewModel.languages = [
        SubtitleUrl(language: "en", url: "url"),
        SubtitleUrl(language: "uk", url: "url2")
        ]
        
        Given(interactor, .getSubtitles(url: .any, willReturn: subtitlesString))
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        
        viewModel.generateSelectedLanguage()
        viewModel.generateLanguageItems()
        let language = viewModel.generateLanguageName(code: "en")
        viewModel.loadSelectedSubtitles()
        
        XCTAssertEqual(language, "English")
    }
    
    func testBlockCompletionRequest() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willProduce: {_ in}))
        
        await viewModel.blockCompletionRequest(blockID: "123", courseID: "123")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
    }
    
    func testBlockCompletionRequestUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
                
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willThrow: NSError()))
        
        await viewModel.blockCompletionRequest(blockID: "123", courseID: "123")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testBlockCompletionRequestNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
                
        let viewModel = VideoPlayerViewModel(interactor: interactor,
                                             router: router,
                                             connectivity: connectivity)
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willThrow: noInternetError))
        
        await viewModel.blockCompletionRequest(blockID: "123", courseID: "123")
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
}
