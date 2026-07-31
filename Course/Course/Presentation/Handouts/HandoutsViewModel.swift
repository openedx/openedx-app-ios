//
//  HandoutsViewModel.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.02.2023.
//

import Foundation
import Core
import SwiftUI

@MainActor
@Observable
public final class HandoutsViewModel {
    
    private(set) var isShowProgress = false
    var handouts: String?
    var updates: [CourseUpdate] = []

    var errorMessage: String?

    var showError: Bool {
        errorMessage != nil
    }
    
    private let interactor: CourseInteractorProtocol
    let cssInjector: CSSInjector
    let router: CourseRouter
    let connectivity: ConnectivityProtocol
    let analytics: CourseAnalytics
    
    public init(
        interactor: CourseInteractorProtocol,
        router: CourseRouter,
        cssInjector: CSSInjector,
        connectivity: ConnectivityProtocol,
        courseID: String,
        analytics: CourseAnalytics
    ) {
        self.interactor = interactor
        self.router = router
        self.cssInjector = cssInjector
        self.connectivity = connectivity
        self.analytics = analytics
    }
    
    func getHandouts(courseID: String) async {
        isShowProgress = true
        do {
            if let handouts = try await interactor.getHandouts(courseID: courseID) {
                self.handouts = handouts
                isShowProgress = false
            }
        } catch {
            isShowProgress = false
        }
    }
    
    func getUpdates(courseID: String) async {
        isShowProgress = true
        do {
            updates = try await interactor.getUpdates(courseID: courseID)
            isShowProgress = false
        } catch {
            isShowProgress = false
        }
    }
}
