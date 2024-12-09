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

@MainActor
final class VideoPlayerViewModelTests: XCTestCase {
    
    let subtitles = [
    Subtitle(id: 0,
             fromTo: DateInterval(start: Date(), end: Date()) ,
             text: "GREGORY NAGY: In hour zero, where I try to introduce Homeric poetry to"),
    Subtitle(id: 1,
             fromTo: DateInterval(start: Date(), end: Date()) ,
             text: "people who may never have been exposed to the Iliad and the Odyssey even in"),
    Subtitle(id: 2,
             fromTo: DateInterval(start: Date(), end: Date()) ,
             text: "translation, my idea was to get a sense of the medium, which is not a"),
    ]

    func testGetSubtitlesSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
                
        Given(interactor, .getSubtitles(url: .any, selectedLanguage: .any, willReturn: subtitles))
        
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(url: nil, blockID: "", courseID: "", selectedCourseTab: 0, pipManager: PipManagerProtocolMock(), playerTracker: tracker, playerDelegate: nil, playerService: service, appStorage: CoreStorageMock())
        let viewModel = VideoPlayerViewModel(languages: [], connectivity: connectivity, playerHolder: playerHolder)
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        
        Verify(interactor, .getSubtitles(url: .any, selectedLanguage: .any))
        
        XCTAssertEqual(viewModel.subtitles.first!.text, subtitles.first!.text)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetSubtitlesOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        
                
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getSubtitles(url: .any, selectedLanguage: .any, willReturn: subtitles))
        
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(url: nil, blockID: "", courseID: "", selectedCourseTab: 0, pipManager: PipManagerProtocolMock(), playerTracker: tracker, playerDelegate: nil, playerService: service, appStorage: CoreStorageMock())
        let viewModel = VideoPlayerViewModel(languages: [], connectivity: connectivity, playerHolder: playerHolder)
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        
        Verify(interactor, .getSubtitles(url: .any, selectedLanguage: .any))
        
        XCTAssertEqual(viewModel.subtitles.first!.text, subtitles.first!.text)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGenerates() async {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(url: nil, blockID: "", courseID: "", selectedCourseTab: 0, pipManager: PipManagerProtocolMock(), playerTracker: tracker, playerDelegate: nil, playerService: service, appStorage: CoreStorageMock())
        let viewModel = VideoPlayerViewModel(languages: [], connectivity: connectivity, playerHolder: playerHolder)

        viewModel.languages = [
        SubtitleUrl(language: "en", url: "url"),
        SubtitleUrl(language: "uk", url: "url2")
        ]
        
        Given(interactor, .getSubtitles(url: .any, selectedLanguage: .any, willReturn: subtitles))
        
        await viewModel.getSubtitles(subtitlesUrl: "url")
        viewModel.prepareLanguages()

        let language = viewModel.generateLanguageName(code: "en")
        
        XCTAssertEqual(language, "English")
    }
    
    func testBlockCompletionRequest() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(
            url: nil,
            blockID: "",
            courseID: "",
            selectedCourseTab: 0,
            pipManager: PipManagerProtocolMock(),
            playerTracker: tracker,
            playerDelegate: nil,
            playerService: service,
            appStorage: CoreStorageMock()
        )
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willProduce: {_ in}))
        
        await playerHolder.sendCompletion()
        
        await Task.yield()
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
    }
    
    func testBlockCompletionRequestUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
                
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(url: nil, blockID: "", courseID: "", selectedCourseTab: 0, pipManager: PipManagerProtocolMock(), playerTracker: tracker, playerDelegate: nil, playerService: service, appStorage: CoreStorageMock())
        let viewModel = VideoPlayerViewModel(languages: [], connectivity: connectivity, playerHolder: playerHolder)
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willThrow: NSError()))
        
        await playerHolder.sendCompletion()
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        await Task.yield()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testBlockCompletionRequestNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
                
        let tracker = PlayerTrackerProtocolMock(url: nil)
        let service = PlayerService(courseID: "", blockID: "", interactor: interactor, router: router)
        let playerHolder = PlayerViewControllerHolder(url: nil, blockID: "", courseID: "", selectedCourseTab: 0, pipManager: PipManagerProtocolMock(), playerTracker: tracker, playerDelegate: nil, playerService: service, appStorage: CoreStorageMock())
        let viewModel = VideoPlayerViewModel(languages: [], connectivity: connectivity, playerHolder: playerHolder)
        
        Given(interactor, .blockCompletionRequest(courseID: .any, blockID: .any, willThrow: noInternetError))
        
        await playerHolder.sendCompletion()
        
        await Task.yield()
        
        Verify(interactor, .blockCompletionRequest(courseID: .any, blockID: .any))
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
}
