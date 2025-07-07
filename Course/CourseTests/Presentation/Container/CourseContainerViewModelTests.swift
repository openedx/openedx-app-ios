//
//  CourseContainerViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 20.01.2023.
//

import SwiftyMocky
import XCTest
import Core
@testable import Course
import Alamofire
import SwiftUI
import Combine

@MainActor
final class CourseContainerViewModelTests: XCTestCase {
    var courseHelperMock: CourseDownloadHelperProtocolMock!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        courseHelperMock = CourseDownloadHelperProtocolMock()
        Given(courseHelperMock, .publisher(willReturn: Just(.empty).eraseToAnyPublisher()))
    }
    
    func testGetCourseBlocksSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(), 
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        
        let block = CourseBlock(
            blockId: "",
            id: "",
            courseId: "123",
            topicId: "",
            graded: true, 
            due: Date(),
            completion: 0,
            type: .problem,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: nil,
            multiDevice: true, 
            offlineDownload: nil
        )
        let vertical = CourseVertical(
            blockId: "",
            id: "",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )
        let sequential = CourseSequential(
            blockId: "",
            id: "",
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical], 
            sequentialProgress: nil,
            due: Date()
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
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
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
        XCTAssertEqual(viewModel.courseHelper.courseStructure, courseStructure)
    }
    
    func testGetCourseBlocksOfflineSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(), 
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
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
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )
        
        Given(interactor, .getLoadedCourseBlocks(courseID: .any, willReturn: courseStructure))
        Given(interactor, .getCourseVideoBlocks(fullStructure: .any,
                                                willReturn: courseStructure))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getLoadedCourseBlocks(courseID: .any))
        Verify(interactor, .getCourseVideoBlocks(fullStructure: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.courseStructure, courseStructure)
        XCTAssertEqual(viewModel.courseHelper.courseStructure, courseStructure)
    }
    
    func testGetCourseBlocksNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(), 
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: noInternetError))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }
    
    func testGetCourseBlocksNoCacheError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(),
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: NoCachedDataError()))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }
    
    func testGetCourseBlocksUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(), 
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        
        Given(interactor, .getCourseBlocks(courseID: "123",
                                           willThrow: NSError(domain: "error", code: -1, userInfo: nil)))
        
        await viewModel.getCourseBlocks(courseID: "123")
        
        Verify(interactor, .getCourseBlocks(courseID: .any))
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.courseStructure)
        XCTAssertNil(viewModel.courseVideosStructure)
        XCTAssertNil(viewModel.courseHelper.courseStructure)
    }
    
    func testTabSelectedAnalytics() {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: DownloadManagerMock(), 
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        
        viewModel.trackSelectedTab(selection: .course, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineCourseTabClicked(courseId: .value("1"), courseName: .value("name")))
        
        viewModel.trackSelectedTab(selection: .discussion, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineDiscussionTabClicked(courseId: .value("1"), courseName: .value("name")))
        
        viewModel.trackSelectedTab(selection: .handounds, courseId: "1", courseName: "name")
        Verify(analytics, .courseOutlineHandoutsTabClicked(courseId: .value("1"), courseName: .value("name")))
    }
    
    func testOnDownloadViewAvailableTap() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type: .desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "course123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        let downloadData = DownloadDataTask(
            id: "1",
            blockId: "1",
            courseId: "course123",
            userId: 1,
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            displayName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .inProgress,
            type: .video,
            fileSize: 1000,
            lastModified: "",
            actualSize: 333
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(downloadManager, .isLargeVideosSize(blocks: .any, willReturn: false))
        Given(downloadManager, .getCurrentDownloadTask(willReturn: downloadData))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        viewModel.courseStructure = courseStructure
        await viewModel.onDownloadViewTap(
             chapter: chapter,
             state: .available
         )

        await Task.yield()

        Verify(
            analytics,
            1,
            .bulkDownloadVideosSection(
                courseID: .value(courseStructure.id),
                sectionID: .value(chapter.id),
                videos: .value(1)
            )
        )
        Verify(analytics, 0, .bulkDeleteVideosSection(courseID: .any, sectionId: .any, videos: .any))
        Verify(downloadManager, 1, .addToDownloadQueue(blocks: .value([block])))
    }

    
    func testOnDownloadViewDownloadingTap() async {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type: .desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        viewModel.courseStructure = courseStructure

        await viewModel.onDownloadViewTap(
             chapter: chapter,
             state: .downloading
         )

        await Task.yield()

        Verify(
            analytics,
            0,
            .bulkDownloadVideosSection(
                courseID: .any,
                sectionID: .any,
                videos: .any
            )
        )
        Verify(analytics, 0, .bulkDeleteVideosSection(courseID: .any, sectionId: .any, videos: .any))
        Verify(downloadManager, 1, .cancelDownloading(courseId: .value(courseStructure.id), blocks: .value([block])))
    }
    
    func testOnDownloadViewFinishedTap() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type: .desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(courseHelperMock, .sizeFor(sequentials: .any, willReturn: 1000))

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelperMock
        )
        viewModel.courseStructure = courseStructure

        await viewModel.onDownloadViewTap(
             chapter: chapter,
             state: .finished
         )

        await Task.yield()

        Verify(
            analytics,
            0,
            .bulkDownloadVideosSection(
                courseID: .any,
                sectionID: .any,
                videos: .any
            )
        )
        Verify(
            analytics,
            1,
            .bulkDeleteVideosSection(
                courseID: .value(courseStructure.id),
                sectionId: .value(chapter.id),
                videos: .value(1)
            )
        )
    }
    
    func testSetDownloadsStatesAvailable() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()
        
        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type:.desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadTasks(willReturn: []))
        let courseHelper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManager)

        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelper
        )
        viewModel.courseStructure = courseStructure
        viewModel.courseStructure = courseStructure
        viewModel.courseHelper.courseStructure = courseStructure
        await viewModel.courseHelper.refreshValue()

        await Task.yield()

        XCTAssertEqual(viewModel.sequentialsDownloadState[sequential.id], .available)
    }
    
    func testSetDownloadsStatesDownloading() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type:.desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(image: CourseImage(raw: "",
                                                  small: "",
                                                  large: "")),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        let downloadData = DownloadDataTask(
            id: "1",
            blockId: "1",
            courseId: "123",
            userId: 1,
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            displayName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .inProgress,
            type: .video,
            fileSize: 1000,
            lastModified: "",
            actualSize: 333
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadTasks(willReturn: [downloadData]))
        let courseHelper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManager)
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelper
        )
        viewModel.courseStructure = courseStructure
        viewModel.courseHelper.courseStructure = courseStructure
        await viewModel.courseHelper.refreshValue()

        await Task.yield()

        XCTAssertEqual(viewModel.sequentialsDownloadState[sequential.id], .downloading)
    }
    
    func testSetDownloadsStatesFinished() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type:.desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(image: CourseImage(raw: "",
                                                  small: "",
                                                  large: "")),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        let downloadData = DownloadDataTask(
            id: "1",
            blockId: "1",
            courseId: "123",
            userId: 1,
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            displayName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .finished,
            type: .video,
            fileSize: 1000,
            lastModified: "",
            actualSize: 333
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadTasks(willReturn: [downloadData]))
        let courseHelper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManager)
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelper
        )
        viewModel.courseStructure = courseStructure
        viewModel.courseHelper.courseStructure = courseStructure
        await viewModel.courseHelper.refreshValue()

        await Task.yield()
        
        XCTAssertEqual(viewModel.sequentialsDownloadState[sequential.id], .finished)
    }
    
    func testSetDownloadsStatesPartiallyFinished() async throws {
        let interactor = CourseInteractorProtocolMock()
        let authInteractor = AuthInteractorProtocolMock()
        let router = CourseRouterMock()
        let analytics = CourseAnalyticsMock()
        let config = ConfigMock()
        let connectivity = ConnectivityProtocolMock()
        let downloadManager = DownloadManagerProtocolMock()

        let blockId = "chapter:block:1"

        let block = CourseBlock(
            blockId: blockId,
            id: "1",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type:.desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )
        let block2 = CourseBlock(
            blockId: "123",
            id: "1213",
            courseId: "123",
            topicId: "",
            graded: false,
            due: Date(),
            completion: 0,
            type: .video,
            displayName: "",
            studentUrl: "",
            webUrl: "",
            encodedVideo: .init(
                fallback: nil,
                youtube: nil,
                desktopMP4: .init(url: "test.mp4", fileSize: 1000, streamPriority: 1, type:.desktopMP4),
                mobileHigh: nil,
                mobileLow: nil,
                hls: nil
            ),
            multiDevice: true,
            offlineDownload: nil
        )

        let vertical = CourseVertical(
            blockId: blockId,
            id: "vertical1",
            courseId: "123",
            displayName: "",
            type: .vertical,
            completion: 0,
            childs: [block, block2],
            webUrl: ""
        )

        let sequential = CourseSequential(
            blockId: blockId,
            id: blockId,
            displayName: "",
            type: .chapter,
            completion: 0,
            childs: [vertical],
            sequentialProgress: nil,
            due: Date()
        )

        let chapter = CourseChapter(
            blockId: blockId,
            id: "1",
            displayName: "Chapter 1",
            type: .chapter,
            childs: [sequential]
        )

        let courseStructure = CourseStructure(
            id: "123",
            graded: true,
            completion: 0,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "",
            topicID: nil,
            childs: [chapter],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "",
            isSelfPaced: true,
            courseProgress: nil
        )

        let downloadData = DownloadDataTask(
            id: "1",
            blockId: "1",
            courseId: "123",
            userId: 1,
            url: "https://example.com/file.mp4",
            fileName: "file.mp4",
            displayName: "file.mp4",
            progress: 0,
            resumeData: nil,
            state: .finished,
            type: .video,
            fileSize: 1000,
            lastModified: "",
            actualSize: 333
        )

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(connectivity, .internetReachableSubject(getter: .init(.reachable)))
        Given(connectivity, .isMobileData(getter: false))

        Given(downloadManager, .eventPublisher(willReturn: Just(.added).eraseToAnyPublisher()))
        Given(downloadManager, .getDownloadTasks(willReturn: [downloadData]))
        let courseHelper = CourseDownloadHelper(courseStructure: courseStructure, manager: downloadManager)
        let viewModel = CourseContainerViewModel(
            interactor: interactor,
            authInteractor: authInteractor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity,
            manager: downloadManager,
            storage: CourseStorageMock(),
            isActive: true,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            lastVisitedBlockID: nil,
            coreAnalytics: CoreAnalyticsMock(),
            courseHelper: courseHelper
        )
        viewModel.courseStructure = courseStructure
        viewModel.courseHelper.courseStructure = courseStructure
        await viewModel.courseHelper.refreshValue()
        await Task.yield()

        XCTAssertEqual(viewModel.sequentialsDownloadState[sequential.id], .available)
    }
}
