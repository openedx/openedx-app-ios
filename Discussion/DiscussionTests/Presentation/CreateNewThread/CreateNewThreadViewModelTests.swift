//
//  CreateNewThreadViewModelTests.swift
//  DiscussionTests
//
//  Created by  Stepanok Ivan on 31.01.2023.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Discussion
import Alamofire
import SwiftUI

@MainActor
final class CreateNewThreadViewModelTests: XCTestCase {
    
    let newThread = DiscussionNewThread(
        courseID: "1",
        topicID: "1",
        type: .discussion,
        title: "1",
        rawBody: "1",
        followPost: false
    )
    
    func testCreateNewThreadSuccess() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        
        let viewModel = CreateNewThreadViewModel(interactor: interactor, router: router, config: config)
        
        Given(interactor, .createNewThread(newThread: .any, willProduce: {_ in}))
        
        result = await viewModel.createNewThread(newThread: newThread)
        
        Verify(interactor, .createNewThread(newThread: .any))
        Verify(router, .back(animated: .value(true)))
        
        XCTAssertTrue(result)
        XCTAssertFalse(viewModel.showError)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testCreateNewThreadNoInternetError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        
        let viewModel = CreateNewThreadViewModel(interactor: interactor, router: router, config: config)
        
        let noInternetError = AFError.sessionInvalidated(error: URLError(.notConnectedToInternet))
        
        Given(interactor, .createNewThread(newThread: .any, willThrow: noInternetError))
        
        result = await viewModel.createNewThread(newThread: newThread)
        
        Verify(interactor, .createNewThread(newThread: .any))
        Verify(router, 0, .back(animated: .value(true)))
        
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.slowOrNoInternetConnection)
        XCTAssertFalse(viewModel.isShowProgress)
    }
    
    func testCreateNewThreadUnknownError() async {
        let interactor = DiscussionInteractorProtocolMock()
        let router = DiscussionRouterMock()
        let config = ConfigMock()
        var result = false
        
        let viewModel = CreateNewThreadViewModel(interactor: interactor, router: router, config: config)
        
        Given(interactor, .createNewThread(newThread: .any, willThrow: NSError()))
        
        result = await viewModel.createNewThread(newThread: newThread)
        
        Verify(interactor, .createNewThread(newThread: .any))
        Verify(router, 0, .back(animated: .value(true)))
        
        XCTAssertFalse(result)
        XCTAssertTrue(viewModel.showError)
        XCTAssertEqual(viewModel.errorMessage, CoreLocalization.Error.unknownError)
        XCTAssertFalse(viewModel.isShowProgress)
    }
}
