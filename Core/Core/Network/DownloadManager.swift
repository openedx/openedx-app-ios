//
//  DownloadManager.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import Alamofire
import SwiftUI
import Combine

public enum DownloadState: String {
    case waiting
    case inProgress
    case paused
    case finished
}

public enum DownloadType: String {
    case video
}

public struct DownloadData {
    public let id: String
    public let courseId: String
    public let url: String
    public let fileName: String
    public let progress: Double
    public let resumeData: Data?
    public let state: DownloadState
    public let type: DownloadType
    
    public init(
        id: String,
        courseId: String,
        url: String,
        fileName: String,
        progress: Double,
        resumeData: Data?,
        state: DownloadState,
        type: DownloadType
    ) {
        self.id = id
        self.courseId = courseId
        self.url = url
        self.fileName = fileName
        self.progress = progress
        self.resumeData = resumeData
        self.state = state
        self.type = type
    }
}

public class NoWiFiError: LocalizedError {
    public init() {}
}

//sourcery: AutoMockable
public protocol DownloadManagerProtocol {
    func publisher() -> AnyPublisher<Int, Never>
    func addToDownloadQueue(blocks: [CourseBlock]) throws
    func getDownloadsForCourse(_ courseId: String) -> [DownloadData]
    func cancelDownloading(courseId: String, blocks: [CourseBlock]) throws
    func resumeDownloading() throws
    func pauseDownloading()
    func deleteFile(blocks: [CourseBlock])
    func deleteAllFiles()
    func fileUrl(for blockId: String) -> URL?
}

public class DownloadManager: DownloadManagerProtocol {
    
    private let persistence: CorePersistenceProtocol
    private let appStorage: Core.AppStorage
    private let connectivity: ConnectivityProtocol
    private var downloadRequest: DownloadRequest?
    private var currentDownload: DownloadData?
    private var isDownloadingInProgress: Bool = false
    
    public init(
        persistence: CorePersistenceProtocol,
        appStorage: Core.AppStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.persistence = persistence
        self.appStorage = appStorage
        self.connectivity = connectivity
    }
    
    public func publisher() -> AnyPublisher<Int, Never> {
        return persistence.publisher()
    }
    
    public func addToDownloadQueue(blocks: [CourseBlock]) throws {
        if userCanDownload() {
            persistence.addToDownloadQueue(blocks: blocks)
            guard !isDownloadingInProgress else { return }
            try newDownload()
        } else {
            throw NoWiFiError()
        }
    }
    
    private func newDownload() throws {
        if userCanDownload() {
            guard let download = persistence.getNextBlockForDownloading() else {
                isDownloadingInProgress = false
                return
            }
            currentDownload = download
            try downloadFileWithProgress(download)
        } else {
            throw NoWiFiError()
        }
    }
    
    private func userCanDownload() -> Bool {
        if appStorage.userSettings?.wifiOnly ?? true {
            if !connectivity.isMobileData {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    public func getDownloadsForCourse(_ courseId: String) -> [DownloadData] {
        return persistence.getDownloadsForCourse(courseId)
    }
    
    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) throws {
        downloadRequest?.cancel()
        
        let downloaded = getDownloadsForCourse(courseId).filter { $0.state == .finished }
        let blocksForDelete = blocks.filter { block in downloaded.first(where: { $0.id == block.id }) == nil }
        
        deleteFile(blocks: blocksForDelete)
        try newDownload()
    }
    
    private func downloadFileWithProgress(_ download: DownloadData) throws {
        if let url = URL(string: download.url) {
            persistence.updateDownloadState(
                id: download.id,
                state: .inProgress,
                resumeData: download.resumeData
            )
            self.isDownloadingInProgress = true
            let fileName = url.lastPathComponent
            if let resumeData = download.resumeData {
                downloadRequest = AF.download(resumingWith: resumeData)
            } else {
                downloadRequest = AF.download(url)
            }
//            downloadRequest?.downloadProgress { prog in
//                let completed = Double(prog.fractionCompleted * 100)
//                print(">>>>> Downloading", download.url, completed, "%")
//            }
            downloadRequest?.responseData(completionHandler: { [weak self] data in
                guard let self else { return }
                if let data = data.value, let url = self.videosFolderUrl() {
                    self.saveFile(file: fileName, data: data, url: url)
                    self.persistence.updateDownloadState(
                        id: download.id,
                        state: .finished,
                        resumeData: nil
                    )
                    try? self.newDownload()
                }
            })
        }
    }
    
    public func resumeDownloading() throws {
        try newDownload()
    }
    
    public func pauseDownloading() {
        guard let currentDownload else { return }
        downloadRequest?.cancel(byProducingResumeData: { resumeData in
            self.persistence.updateDownloadState(
                id: currentDownload.id,
                state: .paused,
                resumeData: resumeData
            )
        })
    }
    
    public func deleteFile(blocks: [CourseBlock]) {
        for block in blocks {
            if let url = block.videoUrl,
               let fileName = URL(string: url)?.lastPathComponent, let folderUrl = videosFolderUrl() {
                do {
                    let fileUrl = folderUrl.appendingPathComponent(fileName)
                    try persistence.deleteDownloadData(id: block.id)
                    try FileManager.default.removeItem(at: fileUrl)
                    print("File deleted successfully")
                } catch {
                    print("Error deleting file: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func deleteAllFiles() {
        if let folderUrl = videosFolderUrl() {
            do {
                try FileManager.default.removeItem(at: folderUrl)
            } catch {
                NSLog("Error deleting All files: \(error.localizedDescription)")
            }
        }
    }
    
    public func fileUrl(for blockId: String) -> URL? {
        guard let data = persistence.downloadData(by: blockId),
              data.url.count > 0,
              data.state == .finished else { return nil }
        
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent("Files", isDirectory: true)
        return directoryURL.appendingPathComponent(data.fileName)
    }
    
    private func videosFolderUrl() -> URL? {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent("Files", isDirectory: true)
        
        if FileManager.default.fileExists(atPath: directoryURL.path) {
            return URL(fileURLWithPath: directoryURL.path)
        } else {
            do {
                try FileManager.default.createDirectory(
                    at: directoryURL,
                    withIntermediateDirectories: true,
                    attributes: nil
                )
                return URL(fileURLWithPath: directoryURL.path)
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    private func saveFile(file: String, data: Data, url: URL) {
        let fileURL = url.appendingPathComponent(file)
        do {
            try data.write(to: fileURL)
        } catch {
            print("SaveFile Error", error.localizedDescription)
        }
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DownloadManagerMock: DownloadManagerProtocol {
    
    public init() {
        
    }
    
    public func publisher() -> AnyPublisher<Int, Never> {
        return Just(1).eraseToAnyPublisher()
    }
    
    public func addToDownloadQueue(blocks: [CourseBlock]) {
        
    }
    
    public func getDownloadsForCourse(_ courseId: String) -> [DownloadData] {
        return []
    }
    
    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) {
        
    }
    
    public func resumeDownloading() {
        
    }
    
    public func pauseDownloading() {
        
    }
    
    public func deleteFile(blocks: [CourseBlock]) {
        
    }
    
    public func deleteAllFiles() {
        
    }
    
    public func fileUrl(for blockId: String) -> URL? {
        return nil
    }
    
}
#endif
