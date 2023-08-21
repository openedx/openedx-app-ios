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

final class ProfileViewModelTests: XCTestCase {
    
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
            isFullProfile: false
        )
        
        Given(connectivity, .isInternetAvaliable(getter: true))
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
            isFullProfile: false
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
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))

        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .getMyProfile(willThrow: noInternetError) )
        
        await viewModel.getMyProfile()
        
        Verify(interactor, 1, .getMyProfile())
        
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertTrue(viewModel.showError)
    }
    
    func testGetMyProfileNoCacheError() async throws {
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
        Given(interactor, .getMyProfile(willThrow: NoCachedDataError()))
        
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
    
    func testLogOutSuccess() async throws {
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
        Given(interactor, .logOut(willProduce: {_ in}))
        
        await viewModel.logOut()
        
        Verify(router, .showLoginScreen())
        XCTAssertFalse(viewModel.showError)
    }
    
    func testLogOutNoInternetError() async throws {
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
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(connectivity, .isInternetAvaliable(getter: true))
        Given(interactor, .logOut(willThrow: noInternetError))
                
        await viewModel.logOut()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
    }
    
    func testLogOutUnknownError() async throws {
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
        Given(interactor, .logOut(willThrow: NSError()))
                
        await viewModel.logOut()
        
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
    }
    
    func testTrackProfileVideoSettingsClicked() {
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
        
        viewModel.trackProfileVideoSettingsClicked()
        
        Verify(analytics, 1, .profileVideoSettingsClicked())
    }
    
    func testTrackEmailSupportClicked() {
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
        
        viewModel.trackEmailSupportClicked()
        
        Verify(analytics, 1, .emailSupportClicked())
    }
    
    func testTrackCookiePolicyClicked() {
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
        
        viewModel.trackCookiePolicyClicked()
        
        Verify(analytics, 1, .cookiePolicyClicked())
    }
    
    func testTrackPrivacyPolicyClicked() {
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
        
        viewModel.trackPrivacyPolicyClicked()
        
        Verify(analytics, 1, .privacyPolicyClicked())
    }
    
    func testTrackProfileEditClicked() {
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
        
        viewModel.trackProfileEditClicked()
        
        Verify(analytics, 1, .profileEditClicked())
    }

}
