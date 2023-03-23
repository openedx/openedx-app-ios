//
//  DashboardViewModel.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import Foundation
import Core
import SwiftUI
import Combine

public class DashboardViewModel: ObservableObject {
    
    @Published private(set) var courses: [CourseItem] = []
    @Published private(set) var isShowProgress = false
    @Published var showError: Bool = false
    var errorMessage: String? {
        didSet {
            withAnimation {
                showError = errorMessage != nil
            }
        }
    }
    
    private let interactor: DashboardInteractorProtocol
    public let connectivity: ConnectivityProtocol
    
    private var onCourseEnrolledCancellable: AnyCancellable?
    
    public init(interactor: DashboardInteractorProtocol, connectivity: ConnectivityProtocol) {
        self.interactor = interactor
        self.connectivity = connectivity
        
        onCourseEnrolledCancellable = NotificationCenter.default
            .publisher(for: .onCourseEnrolled)
            .sink { [weak self] _ in
                guard let self = self else { return }
                Task {
                    await self.getMyCourses()
                }
            }
    }
    
    @MainActor
    func getMyCourses(withProgress: Bool = true) async {
        isShowProgress = withProgress
        do {
            if connectivity.isInternetAvaliable {
                courses = try await interactor.getMyCourses()
                isShowProgress = false
            } else {
                courses = try interactor.discoveryOffline()
                isShowProgress = false
            }
        } catch let error {
            isShowProgress = false
            if error is NoCachedDataError {
                errorMessage = CoreLocalization.Error.noCachedData
            } else {
                errorMessage = CoreLocalization.Error.unknownError
            }
        }
    }
}
