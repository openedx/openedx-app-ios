//
//  DownloadsHelperProtocol.swift
//  Downloads
//
//  Created by Ivan Stepanok on 03.03.2025.
//

import Foundation
import Core

/// @mockable
public protocol DownloadsHelperProtocol: Sendable {
    func calculateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int)
    func isDownloading(courseID: String) async -> Bool
    func isFullyDownloaded(courseID: String) async -> Bool
    func getDownloadTasksForCourse(courseID: String) async -> [DownloadDataTask]
}

#if DEBUG
public actor DownloadsHelperPreviewMock: DownloadsHelperProtocol {
    
    public var mockDownloadProgress: (downloaded: Int, total: Int) = (0, 0)
    public var mockIsDownloading: Bool = false
    public var mockIsFullyDownloaded: Bool = false
    public var mockDownloadTasks: [DownloadDataTask] = []
    
    public init() {}
    
    public func calculateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int) {
        return mockDownloadProgress
    }
    
    public func isDownloading(courseID: String) async -> Bool {
        return mockIsDownloading
    }
    
    public func isFullyDownloaded(courseID: String) async -> Bool {
        return mockIsFullyDownloaded
    }
    
    public func getDownloadTasksForCourse(courseID: String) async -> [DownloadDataTask] {
        return mockDownloadTasks
    }
}
#endif
