//
//  HandoutsViewModelTests.swift
//  CourseTests
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

@MainActor
final class HandoutsViewModelTests: XCTestCase {
    
    func testGetHandoutsSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let courseUpdate = [CourseUpdate(id: 1, date: "1", content: "Update", status: "1")]
        
        Given(interactor, .getHandouts(courseID: .any, willReturn: "Result"))
        Given(interactor, .getUpdates(courseID: .any, willReturn: courseUpdate))
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
        
        await viewModel.getHandouts(courseID: "")
        
        Verify(interactor, 1, .getHandouts(courseID: .any))
        
        XCTAssert(viewModel.handouts == "Result")
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetHandoutsNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getHandouts(courseID: .any, willThrow: noInternetError))
        Given(interactor, .getUpdates(courseID: .any, willThrow: noInternetError))
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
                
        await viewModel.getHandouts(courseID: "")
        
        Verify(interactor, 1, .getHandouts(courseID: .any))
        
        XCTAssert(viewModel.handouts == nil)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetHandoutsUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        Given(interactor, .getHandouts(courseID: .any, willThrow: NSError()))
        Given(interactor, .getUpdates(courseID: .any, willThrow: NSError()))
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
        
        await viewModel.getHandouts(courseID: "")
        
        Verify(interactor, 1, .getHandouts(courseID: .any))
        
        XCTAssert(viewModel.handouts == nil)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetUpdatesSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let courseUpdate = [CourseUpdate(id: 1, date: "1", content: "Update", status: "1")]
        
        Given(interactor, .getUpdates(courseID: .any, willReturn: courseUpdate))
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
        
        await viewModel.getUpdates(courseID: "")
        
        Verify(interactor, 1, .getUpdates(courseID: .any))
        
        XCTAssert(viewModel.updates[0].content == "Update")
        XCTAssertFalse(viewModel.isShowProgress)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.showError)
    }
    
    func testGetUpdatesNoInternetError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .getUpdates(courseID: .any, willThrow: noInternetError))
        
        await viewModel.getUpdates(courseID: "")
        
        Verify(interactor, 1, .getUpdates(courseID: .any))
        
        XCTAssertTrue(viewModel.updates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testGetUpdatesUnknownError() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        
        let viewModel = HandoutsViewModel(
            interactor: interactor,
            router: router,
            cssInjector: CSSInjectorMock(),
            connectivity: connectivity,
            courseID: "123",
            analytics: CourseAnalyticsMock())
        
        
        Given(interactor, .getUpdates(courseID: .any, willThrow: NSError()))
        
        await viewModel.getUpdates(courseID: "")
        
        Verify(interactor, 1, .getUpdates(courseID: .any))
        
        XCTAssertTrue(viewModel.updates.isEmpty)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
}
