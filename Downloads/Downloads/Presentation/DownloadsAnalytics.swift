//
//  DownloadsAnalytics.swift
//  Downloads
//
//  Created by Ivan Stepanok on 5.03.2025.
//

import Foundation
import Core

//sourcery: AutoMockable
public protocol DownloadsAnalytics {
    func downloadCourseClicked(courseId: String, courseName: String)
    func cancelDownloadClicked(courseId: String, courseName: String)
    func removeDownloadClicked(courseId: String, courseName: String)
    func downloadConfirmed(courseId: String, courseName: String, downloadSize: Int64)
    func downloadCancelled(courseId: String, courseName: String)
    func downloadRemoved(courseId: String, courseName: String, downloadSize: Int64)
    func downloadError(courseId: String, courseName: String, errorType: String)
    func downloadCompleted(courseId: String, courseName: String, downloadSize: Int64)
    func downloadStarted(courseId: String, courseName: String, downloadSize: Int64)
    func downloadsScreenViewed()
}

public enum AnalyticsError: String {
    case storageFull = "storage_full"
    case noInternet = "no_internet"
    case wifiRequired = "wifi_required"
    case unknown = "unknown"
}

#if DEBUG
public class DownloadsAnalyticsMock: DownloadsAnalytics {
    public init() {}
    
    public func downloadCourseClicked(courseId: String, courseName: String) {}
    public func cancelDownloadClicked(courseId: String, courseName: String) {}
    public func removeDownloadClicked(courseId: String, courseName: String) {}
    public func downloadConfirmed(courseId: String, courseName: String, downloadSize: Int64) {}
    public func downloadCancelled(courseId: String, courseName: String) {}
    public func downloadRemoved(courseId: String, courseName: String, downloadSize: Int64) {}
    public func downloadError(courseId: String, courseName: String, errorType: String) {}
    public func downloadCompleted(courseId: String, courseName: String, downloadSize: Int64) {}
    public func downloadStarted(courseId: String, courseName: String, downloadSize: Int64) {}
    public func downloadsScreenViewed() {}
}
#endif
