//
//  CourseContainerViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 20.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

final class CourseContainerViewModelTests: XCTestCase {
    
    func testGetCourseBlocksSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
                
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let block = CourseBlock(
            blockId: "",
            id: "",
            topicId: "",
            graded: true,
            completion: 0,
            type: .problem,
            displayName: "",
            studentUrl: "",
            videoUrl: nil,
            youTubeUrl: nil
        )
        let vertical = CourseVertical(
            blockId: "",
            id: "",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block]
        )
        let sequential = CourseSequential(
            blockId: "",
            id: "",
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical]
        )
        let chapter = CourseChapter(
            blockId: "",
            id: "",
            displayName: "",
            type: .chapter,
            childs: [sequential]
        )
        
        let childs = [chapter]
        
        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: childs,
            media: DataLayer.CourseMedia(image: DataLayer.Image(raw: "",
                                                                small: "",
                                                                large: "")),
            certificate: nil
        )
        
        let resumeBlock = ResumeBlock(blockID: "123")
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willReturn: courseStructure))
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willReturn: courseStructure))
        Given(interactor, .resumeBlock(courseID: "123",
                                       willReturn: resumeBlock))
        Given(interactor, .getCourseVideoBlocks(fullStructure: .any,
                                                willReturn: courseStructure))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        Verify(interactor, .getCourseVideoBlocks(fullStructure: .any))
        Verify(interactor, .resumeBlock(courseID: "123"))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.courseStructure, courseStructure)
    }
    
    func testGetCourseBlocksOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let courseStructure = CourseStructure(id: "123",
                                              graded: true,
                                              completion: 0,
                                              viewYouTubeUrl: "",
                                              encodedVideo: "",
                                              displayName: "",
                                              topicID: nil,
                                              childs: [],
                                              media: DataLayer.CourseMedia(image: DataLayer.Image(raw: "",
                                                                                                  small: "",
                                                                                                  large: "")),
                                              certificate: nil)
        
        Given(interactor, .getCourseBlocksOffline(courseID: .any, willReturn: courseStructure))
        Given(interactor, .getCourseVideoBlocks(fullStructure: .any,
                                                willReturn: courseStructure))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocksOffline(courseID: .any))
        Verify(interactor, .getCourseVideoBlocks(fullStructure: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.courseStructure, courseStructure)
    }
    
    func testGetCourseBlocksNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: noInternetError))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertNil(viewModel.courseStructure)
    }
    
    func testGetCourseBlocksNoCacheError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: NoCachedDataError()))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertNil(viewModel.courseStructure)
    }
    
    func testGetCourseBlocksUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: NSError()))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertNil(viewModel.courseStructure)
    }
}
