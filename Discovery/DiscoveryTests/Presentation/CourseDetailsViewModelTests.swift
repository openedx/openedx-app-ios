//
//  CourseDetailsViewModelTests.swift
//  CourseDetailsTests
//
//  Created by  Stepanok Ivan on 20.01.2023.
//

import XCTest
@testable import Core
@testable import Discovery
import Alamofire
import SwiftUI

@MainActor
final class CourseDetailsViewModelTests: XCTestCase {

    func testGetCourseDetailSuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        let courseDetails = CourseDetails(
            courseID: "123",
            org: "org",
            courseTitle: "title",
            courseDescription: "description",
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: true,
            overviewHTML: "",
            courseBannerURL: "",
            courseVideoURL: nil,
            courseRawImage: nil
        )


        interactor.getCourseDetailsHandler = { _ in courseDetails }

        await viewModel.getCourseDetail(courseID: "123")

        XCTAssertEqual(interactor.getCourseDetailsCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetCourseDetailSuccessOffline() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = false

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        let courseDetails = CourseDetails(
            courseID: "123",
            org: "org",
            courseTitle: "title",
            courseDescription: "description",
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil,
            isEnrolled: true,
            overviewHTML: "",
            courseBannerURL: "",
            courseVideoURL: nil,
            courseRawImage: nil
        )

        interactor.getLoadedCourseDetailsHandler = { _ in courseDetails }

        await viewModel.getCourseDetail(courseID: "123")

        XCTAssertEqual(interactor.getLoadedCourseDetailsCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testGetCourseDetailNoInternetError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.getCourseDetailsHandler = { _ in throw noInternetError }

        await viewModel.getCourseDetail(courseID: "123")

        XCTAssertEqual(interactor.getCourseDetailsCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetCourseDetailNoCacheError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        interactor.getCourseDetailsHandler = { _ in throw NoCachedDataError() }

        await viewModel.getCourseDetail(courseID: "123")

        XCTAssertEqual(interactor.getCourseDetailsCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetCourseDetailUnknownError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        interactor.getCourseDetailsHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        await viewModel.getCourseDetail(courseID: "123")

        XCTAssertEqual(interactor.getCourseDetailsCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
    }

    func testEnrollToCourseSuccess() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        interactor.enrollToCourseHandler = { _ in true }

        await viewModel.enrollToCourse(id: "123")

        XCTAssertEqual(interactor.enrollToCourseCallCount, 1)
        XCTAssertTrue(analytics.courseEnrollClickedCallCount > 0)
        XCTAssertTrue(analytics.courseEnrollSuccessCallCount > 0)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }

    func testEnrollToCourseUnknownError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        interactor.enrollToCourseHandler = { _ in throw AFError.explicitlyCancelled }

        await viewModel.enrollToCourse(id: "123")

        XCTAssertEqual(interactor.enrollToCourseCallCount, 1)
        XCTAssertTrue(analytics.courseEnrollClickedCallCount > 0)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertTrue(viewModel.showError)
    }

    func testEnrollToCourseNoInternetError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.enrollToCourseHandler = { _ in throw noInternetError }

        await viewModel.enrollToCourse(id: "123")

        XCTAssertEqual(interactor.enrollToCourseCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
    }

    func testEnrollToCourseNoCacheError() async throws {
        let interactor = DiscoveryInteractorProtocolMock()
        let router = DiscoveryRouterMock()
        let analytics = DiscoveryAnalyticsMock()
        let config = ConfigMock()
        let cssInjector = CSSInjectorMock()
        let connectivity = ConnectivityProtocolMock()

        connectivity.isInternetAvaliable = true

        let viewModel = CourseDetailsViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            cssInjector: cssInjector,
            connectivity: connectivity,
            storage: CoreStorageMock()
        )

        interactor.enrollToCourseHandler = { _ in throw NoCachedDataError() }

        await viewModel.enrollToCourse(id: "123")

        XCTAssertEqual(interactor.enrollToCourseCallCount, 1)

        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertTrue(viewModel.showError)
    }

}
