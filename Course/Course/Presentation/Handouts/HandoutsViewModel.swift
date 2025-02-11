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
public final class HandoutsViewModel: ObservableObject {
    
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    @Published var handouts: String?
    @Published var updates: [CourseUpdate] = []
    
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
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
