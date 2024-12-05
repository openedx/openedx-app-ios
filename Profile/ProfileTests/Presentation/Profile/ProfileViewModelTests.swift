//
//  ProfileViewModelTests.swift
//  ProfileTests
//
//  Created by  Stepanok Ivan on 18.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Profile
import Alamofire
import SwiftUI

@MainActor
final class ProfileViewModelTests: XCTestCase {
    
    func testGetUserProfileSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        
        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )
        
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
        
        Given(interactor, .getUserProfile(username: .value("Steve"), willReturn: user))
        
        await viewModel.getUserProfile()
        
        Verify(interactor, 1, .getUserProfile(username: .value("Steve")))
        
        XCTAssertEqual(viewModel.userModel, user)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testGetUserProfileNoInternetError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        
        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getUserProfile(username: .value("Steve"), willThrow: noInternetError))
        
        await viewModel.getUserProfile()
        
        Verify(interactor, 1, .getUserProfile(username: .value("Steve")))
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetUserProfileUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        
        let viewModel = UserProfileViewModel(
            interactor: interactor,
            username: "Steve"
        )
        
        Given(interactor, .getUserProfile(username: .value("Steve"), willThrow: NSError()))
        
        await viewModel.getUserProfile()
        
        Verify(interactor, 1, .getUserProfile(username: .value("Steve")))
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetMyProfileSuccess() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            connectivity: connectivity
        )
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyProfileOffline(willReturn: user))
        Given(interactor, .getMyProfile(willReturn: user))
        
        await viewModel.getMyProfile()
        
        Verify(interactor, 1, .getMyProfile())
        
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
        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            connectivity: connectivity
        )
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: false))
        Given(interactor, .getMyProfileOffline(willReturn: user))
        
        await viewModel.getMyProfile()
        
        Verify(interactor, 1, .getMyProfileOffline())
        
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
        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            connectivity: connectivity
        )
        
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
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyProfileOffline(willReturn: user))
        Given(interactor, .getMyProfile(willThrow: noInternetError))
        
        await viewModel.getMyProfile()
        
        Verify(interactor, 1, .getMyProfile())
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetMyProfileUnknownError() async throws {
        let interactor = ProfileInteractorProtocolMock()
        let router = ProfileRouterMock()
        let analytics = ProfileAnalyticsMock()
        let connectivity = ConnectivityProtocolMock()
        let viewModel = ProfileViewModel(
            interactor: interactor,
            router: router,
            analytics: analytics,
            config: ConfigMock(),
            connectivity: connectivity
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyProfile(willThrow: NSError()))
        
        await viewModel.getMyProfile()
        
        Verify(interactor, 1, .getMyProfile())
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
}
