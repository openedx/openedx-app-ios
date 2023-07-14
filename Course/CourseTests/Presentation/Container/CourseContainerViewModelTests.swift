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
import Combine

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
            courseId: "123",
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
            courseId: "123",
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
        
        let courseStructure = CourseStructure(
            id: "123",
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
            certificate: nil
        )
        
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
    
    func testTabSelectedAnalytics() {
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
        
        viewModel.trackSelectedTab(selection: .course, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineCourseTabClicked(courseId: .value("1"), courseName: .value("name")))
        
        viewModel.trackSelectedTab(selection: .videos, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineVideosTabClicked(courseId: .value("1"), courseName: .value("name")))
        
        viewModel.trackSelectedTab(selection: .discussion, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineDiscussionTabClicked(courseId: .value("1"), courseName: .value("name")))
        
        viewModel.trackSelectedTab(selection: .handounds, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineHandoutsTabClicked(courseId: .value("1"), courseName: .value("name")))
    }
    
    func testOnDownloadViewAvailableTap() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        Given(downloadManager, .publisher(willReturn: Empty().eraseToAnyPublisher()))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let blockId = "chapter:block:1"
        
        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: []
        )
        
        viewModel.onDownloadViewTap(
            chapter: chapter,
            blockId: blockId,
            state: .available
        )
        
        XCTAssertEqual(viewModel.downloadState[blockId], .downloading)
    }
    
    func testOnDownloadViewDownloadingTap() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        Given(downloadManager, .publisher(willReturn: Empty().eraseToAnyPublisher()))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let blockId = "chapter:block:1"
        
        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: []
        )
        
        viewModel.onDownloadViewTap(
            chapter: chapter,
            blockId: blockId,
            state: .downloading
        )
        
        XCTAssertEqual(viewModel.downloadState[blockId], .available)
    }
    
    func testOnDownloadViewFinishedTap() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        Given(downloadManager, .publisher(willReturn: Empty().eraseToAnyPublisher()))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        
        let blockId = "chapter:block:1"
        
        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: []
        )
        
        viewModel.onDownloadViewTap(
            chapter: chapter,
            blockId: blockId,
            state: .finished
        )
        
        XCTAssertEqual(viewModel.downloadState[blockId], .available)
    }
    
    func testSetDownloadsStatesAvailable() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        let block = CourseBlock(
            blockId: "block:1",
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            videoUrl: "https://example.com/file.mp4",
            youTubeUrl: nil
        )
        let vertical = CourseVertical(
            blockId: "block:vertical1",
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block]
        )
        let sequential = CourseSequential(
            blockId: "block:sequential1",
            id: "sequential1",
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
            media: DataLayer.CourseMedia(image: DataLayer.Image(
                raw: "",
                small: "",
                large: ""
            )),
            certificate: nil
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        
        Given(downloadManager, .publisher(willReturn: Just(1).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadsForCourse(.any, willReturn: []))
        
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        viewModel.courseStructure = courseStructure
        
        let exp = expectation(description: "DispatchQueue.main.async Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }
                
        wait(for: [exp], timeout: 1)
        
        XCTAssertEqual(viewModel.downloadState[sequential.id], .available)
    }
    
    func testSetDownloadsStatesDownloading() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let block = CourseBlock(
            blockId: "block:1",
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            videoUrl: "https://example.com/file.mp4",
            youTubeUrl: nil
        )
        let vertical = CourseVertical(
            blockId: "block:vertical1",
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block]
        )
        let sequential = CourseSequential(
            blockId: "block:sequential1",
            id: "sequential1",
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
            media: DataLayer.CourseMedia(image: DataLayer.Image(
                raw: "",
                small: "",
                large: ""
            )),
            certificate: nil
        )

        let downloadData = DownloadData(
            id: "1",
            courseId: "course123",
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .waiting,
            type: .video
        )

        Given(connectivity, .isInternetAvaliable(getter: true))

        Given(downloadManager, .publisher(willReturn: Just(1).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadsForCourse(.any, willReturn: [downloadData]))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        viewModel.courseStructure = courseStructure

        let exp = expectation(description: "DispatchQueue.main.async Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(viewModel.downloadState[sequential.id], .downloading)
    }
    
    func testSetDownloadsStatesFinished() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let block = CourseBlock(
            blockId: "block:1",
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            videoUrl: "https://example.com/file.mp4",
            youTubeUrl: nil
        )
        let vertical = CourseVertical(
            blockId: "block:vertical1",
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block]
        )
        let sequential = CourseSequential(
            blockId: "block:sequential1",
            id: "sequential1",
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
            media: DataLayer.CourseMedia(image: DataLayer.Image(
                raw: "",
                small: "",
                large: ""
            )),
            certificate: nil
        )

        let downloadData = DownloadData(
            id: "1",
            courseId: "course123",
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .finished,
            type: .video
        )

        Given(connectivity, .isInternetAvaliable(getter: true))

        Given(downloadManager, .publisher(willReturn: Just(1).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadsForCourse(.any, willReturn: [downloadData]))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        viewModel.courseStructure = courseStructure

        let exp = expectation(description: "DispatchQueue.main.async Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(viewModel.downloadState[sequential.id], .finished)
    }
    
    func testSetDownloadsStatesPartiallyFinished() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let block1 = CourseBlock(
            blockId: "block:1",
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            videoUrl: "https://example.com/file.mp4",
            youTubeUrl: nil
        )
        let block2 = CourseBlock(
            blockId: "block:2",
            id: "2",
            courseId: "123",
            topicId: "",
            graded: false,
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            videoUrl: "https://example.com/file2.mp4",
            youTubeUrl: nil
        )
        let vertical = CourseVertical(
            blockId: "block:vertical1",
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block1, block2]
        )
        let sequential = CourseSequential(
            blockId: "block:sequential1",
            id: "sequential1",
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
            media: DataLayer.CourseMedia(image: DataLayer.Image(
                raw: "",
                small: "",
                large: ""
            )),
            certificate: nil
        )

        let downloadData = DownloadData(
            id: "1",
            courseId: "course123",
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .finished,
            type: .video
        )

        Given(connectivity, .isInternetAvaliable(getter: true))

        Given(downloadManager, .publisher(willReturn: Just(1).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadsForCourse(.any, willReturn: [downloadData]))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        viewModel.courseStructure = courseStructure

        let exp = expectation(description: "DispatchQueue.main.async Starting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(viewModel.downloadState[sequential.id], .available)
    }
}
