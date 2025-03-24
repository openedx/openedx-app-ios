//
//  DownloadsHelper.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Core

public actor DownloadsHelper: DownloadsHelperProtocol {
    
    private let downloadManager: DownloadManagerProtocol
    private var downloadTasks: [DownloadDataTask] = []
    
    public init(downloadManager: DownloadManagerProtocol) {
        self.downloadManager = downloadManager
    }
    
    public func calculateDownloadProgress(courseID: String) async -> (downloaded: Int, total: Int) {
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        downloadTasks = tasks
        
        let totalSize = tasks.reduce(0) { $0 + $1.fileSize }
        let downloadedSize = tasks.reduce(0) { $0 + ($1.state == .finished ? $1.actualSize : 0) }
        
        return (downloadedSize, totalSize)
    }
    
    public func isDownloading(courseID: String) async -> Bool {
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        return tasks.contains(where: { $0.state == .inProgress || $0.state == .waiting })
    }
    
    public func isPartiallyDownloaded(courseID: String) async -> Bool {
        let (downloaded, total) = await calculateDownloadProgress(courseID: courseID)
        let isDownloading = await isDownloading(courseID: courseID)
        
        // If there's downloaded content, but it's not complete and not currently downloading
        return downloaded > 0 && downloaded < total && !isDownloading
    }
    
    public func hasDownloadedContent(courseID: String) async -> Bool {
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        return tasks.contains(where: { $0.state == .finished })
    }
    
    public func isFullyDownloaded(courseID: String) async -> Bool {
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        return !tasks.isEmpty && tasks.allSatisfy { $0.state == .finished }
    }
    
    public func getDownloadTasksForCourse(courseID: String) async -> [DownloadDataTask] {
        let tasks = await downloadManager.getDownloadTasksForCourse(courseID)
        downloadTasks = tasks
        return tasks
    }
}
