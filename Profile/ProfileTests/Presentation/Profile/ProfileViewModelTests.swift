//
//  ProfileViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 18.01.2023.
//

import XCTest
@testable import Core
@testable import Profile
import Alamofire
import SwiftUI

@MainActor
final class ProfileViewModelTests: XCTestCase {

    func testGetUserProfileSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()

        let user = UserProfile(
            avatarUrl: "",
            name: "Steve",
            username: "Steve",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "Ua",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        interactor.getUserProfileHandler = { _ in user }

        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )

        await viewModel.getUserProfile()

        XCTAssertEqual(interactor.getUserProfileCallCount, 1)
        XCTAssertEqual(viewModel.userModel, user)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGetUserProfileNoInternetError() async throws {
        let interactor = ProfileInteractorProtocolMock()

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        interactor.getUserProfileHandler = { _ in throw noInternetError }

        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )

        await viewModel.getUserProfile()

        XCTAssertEqual(interactor.getUserProfileCallCount, 1)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetUserProfileUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()

        interactor.getUserProfileHandler = { _ in throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )

        await viewModel.getUserProfile()

        XCTAssertEqual(interactor.getUserProfileCallCount, 1)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetMyProfileSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        let user = UserProfile(
            avatarUrl: "",
            name: "Steve",
            username: "Steve",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "Ua",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        connectivity.isInternetAvaliable = true
        interactor.getMyProfileOfflineHandler = { user }
        interactor.getMyProfileHandler = { user }

        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity
        )

        await viewModel.getMyProfile()

        XCTAssertEqual(interactor.getMyProfileCallCount, 1)
        XCTAssertEqual(viewModel.userModel, user)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGetMyProfileOfflineSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        let user = UserProfile(
            avatarUrl: "",
            name: "Steve",
            username: "Steve",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "Ua",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        connectivity.isInternetAvaliable = false
        interactor.getMyProfileOfflineHandler = { user }

        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity
        )

        await viewModel.getMyProfile()

        XCTAssertEqual(interactor.getMyProfileOfflineCallCount, 1)
        XCTAssertEqual(viewModel.userModel, user)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testGetMyProfileNoInternetError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        let user = UserProfile(
            avatarUrl: "",
            name: "Steve",
            username: "Steve",
            dateJoined: Date(),
            yearOfBirth: 2000,
            country: "Ua",
            shortBiography: "Bio",
            isFullProfile: false,
            email: ""
        )

        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        connectivity.isInternetAvaliable = true
        interactor.getMyProfileOfflineHandler = { user }
        interactor.getMyProfileHandler = { throw noInternetError }

        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity
        )

        await viewModel.getMyProfile()

        XCTAssertEqual(interactor.getMyProfileCallCount, 1)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }

    func testGetMyProfileUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let config = ConfigProtocolMock()

        connectivity.isInternetAvaliable = true
        interactor.getMyProfileHandler = { throw NSError(domain: "error", code: -1, userInfo: nil) }

        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: config,
            connectivity: connectivity
        )

        await viewModel.getMyProfile()

        XCTAssertEqual(interactor.getMyProfileCallCount, 1)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
}
