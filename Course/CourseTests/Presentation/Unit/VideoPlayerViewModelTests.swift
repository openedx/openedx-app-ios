//
//  VideoPlayerViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 12.04.2023.
//

import XCTest
@testable import Core
@testable import Course
import Combine

@MainActor
final class VideoPlayerViewModelTests: XCTestCase {

    private func makePlayerHolder(service: PlayerServiceProtocolMock) -> PlayerViewControllerHolderProtocolMock {
        let playerHolder = PlayerViewControllerHolderProtocolMock()
        playerHolder.getServiceHandler = { service }
        playerHolder.getTimePublisherHandler = { Empty().eraseToAnyPublisher() }
        playerHolder.getErrorPublisherHandler = { Empty().eraseToAnyPublisher() }
        playerHolder.getRatePublisherHandler = { Empty().eraseToAnyPublisher() }
        playerHolder.getReadyPublisherHandler = { Empty().eraseToAnyPublisher() }
        playerHolder.getFinishPublisherHandler = { Empty().eraseToAnyPublisher() }
        return playerHolder
    }

    func testGetSubtitlesSuccess() async throws {
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        let appStorage = CoreStorageMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)

        let subtitles = [
            Subtitle(
                id: 1,
                fromTo: DateInterval(start: Date(), duration: 5),
                text: "Hello World"
            )
        ]

        let playerService = PlayerServiceProtocolMock()
        playerService.getSubtitlesHandler = { _, _ in subtitles }

        let playerHolder = makePlayerHolder(service: playerService)

        let viewModel = VideoPlayerViewModel(
            languages: [],
            connectivity: connectivity,
            playerHolder: playerHolder,
            appStorage: appStorage,
            analytics: analytics
        )

        await viewModel.getSubtitles(subtitlesUrl: "https://example.com/subs.vtt")

        XCTAssertEqual(playerService.getSubtitlesCallCount, 1)
        XCTAssertFalse(viewModel.subtitles.isEmpty)
        XCTAssertEqual(viewModel.subtitles.first?.text, "Hello World")
    }

    func testGetSubtitlesError() async throws {
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        let appStorage = CoreStorageMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)

        let playerService = PlayerServiceProtocolMock()
        playerService.getSubtitlesHandler = { _, _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let playerHolder = makePlayerHolder(service: playerService)

        let viewModel = VideoPlayerViewModel(
            languages: [],
            connectivity: connectivity,
            playerHolder: playerHolder,
            appStorage: appStorage,
            analytics: analytics
        )

        await viewModel.getSubtitles(subtitlesUrl: "https://example.com/subs.vtt")

        XCTAssertEqual(playerService.getSubtitlesCallCount, 1)
        XCTAssertTrue(viewModel.subtitles.isEmpty)
    }

    func testGenerateLanguageName() async throws {
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        let appStorage = CoreStorageMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)

        let playerService = PlayerServiceProtocolMock()
        let playerHolder = makePlayerHolder(service: playerService)

        let viewModel = VideoPlayerViewModel(
            languages: [],
            connectivity: connectivity,
            playerHolder: playerHolder,
            appStorage: appStorage,
            analytics: analytics
        )

        let englishName = viewModel.generateLanguageName(code: "en")
        XCTAssertEqual(englishName, "English")

        let ukrainianName = viewModel.generateLanguageName(code: "uk")
        XCTAssertEqual(ukrainianName, "Українська")
    }

    func testGeneratePickerItems() async throws {
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        let appStorage = CoreStorageMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)

        let languages = [
            SubtitleUrl(language: "en", url: "https://example.com/subs_en.vtt"),
            SubtitleUrl(language: "uk", url: "https://example.com/subs_uk.vtt")
        ]

        let playerService = PlayerServiceProtocolMock()
        playerService.getSubtitlesHandler = { _, _ in [] }
        let playerHolder = makePlayerHolder(service: playerService)

        let viewModel = VideoPlayerViewModel(
            languages: languages,
            connectivity: connectivity,
            playerHolder: playerHolder,
            appStorage: appStorage,
            analytics: analytics
        )

        // Items should include 2 languages
        XCTAssertEqual(viewModel.items.count, 2)
    }

    func testFindSubtitle() async throws {
        let connectivity = ConnectivityProtocolMock()
        let analytics = CourseAnalyticsMock()
        let appStorage = CoreStorageMock()

        connectivity.isInternetAvaliable = true
        connectivity.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(.reachable)

        let playerService = PlayerServiceProtocolMock()
        let playerHolder = makePlayerHolder(service: playerService)

        let viewModel = VideoPlayerViewModel(
            languages: [],
            connectivity: connectivity,
            playerHolder: playerHolder,
            appStorage: appStorage,
            analytics: analytics
        )

        let now = Date()
        let subtitle = Subtitle(
            id: 1,
            fromTo: DateInterval(start: now, duration: 5),
            text: "Hello World"
        )
        viewModel.subtitles = [subtitle]

        let foundSubtitle = viewModel.findSubtitle(at: now.addingTimeInterval(2))
        XCTAssertNotNil(foundSubtitle)
        XCTAssertEqual(foundSubtitle?.text, "Hello World")

        let notFoundSubtitle = viewModel.findSubtitle(at: now.addingTimeInterval(10))
        XCTAssertNil(notFoundSubtitle)
    }
}
