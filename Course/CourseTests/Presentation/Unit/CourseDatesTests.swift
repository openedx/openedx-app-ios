//
//  CourseDatesTests.swift
//  CourseTests
//
//  Created by Muhammad Umer on 10/24/23.
//

import SwiftyMocky
import XCTest
@testable import Core
@testable import Course
import Alamofire
import SwiftUI

final class CourseDatesTests: XCTestCase {
    
    func testBlockCompletionRequestSuccess() async throws {
        let interactor = CourseInteractorProtocolMock()
        let router = CourseRouterMock()
        let connectivity = ConnectivityProtocolMock()
        let cssInjector = CSSInjectorMock()
        let analytics = CourseAnalyticsMock()
        
        let viewModel = CourseDatesViewModel(
            interactor: interactor,
            router: router, 
            cssInjector: cssInjector,
            connectivity: connectivity,
            courseID: "")
    }
}
