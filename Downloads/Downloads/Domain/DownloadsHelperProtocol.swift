//
//  DownloadsHelperProtocol.swift
//  Downloads
//
//  Created by Ivan Stepanok on 03.03.2025.
//

import Foundation

//sourcery: AutoMockable
public protocol DownloadsHelperProtocol: Sendable {
    func calculateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int)
    func isDownloading(courseID: String) async -> Bool
    func isPartiallyDownloaded(courseID: String) async -> Bool
    func hasDownloadedContent(courseID: String) async -> Bool
    func isFullyDownloaded(courseID: String) async -> Bool
}

#if DEBUG
public actor DownloadsHelperMock: DownloadsHelperProtocol {
    
    public var mockDownloadProgress: (downloaded: Int, total: Int) = (0, 0)
    public var mockIsDownloading: Bool = false
    public var mockIsPartiallyDownloaded: Bool = false
    public var mockHasDownloadedContent: Bool = false
    public var mockIsFullyDownloaded: Bool = false
    
    public init() {}
    
    public func calculateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int) {
        return mockDownloadProgress
    }
    
    public func isDownloading(courseID: String) async -> Bool {
        return mockIsDownloading
    }
    
    public func isPartiallyDownloaded(courseID: String) async -> Bool {
        return mockIsPartiallyDownloaded
    }
    
    public func hasDownloadedContent(courseID: String) async -> Bool {
        return mockHasDownloadedContent
    }
    
    public func isFullyDownloaded(courseID: String) async -> Bool {
        return mockIsFullyDownloaded
    }
}
#endif
