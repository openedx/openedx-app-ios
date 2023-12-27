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

    public var order: Int {
        switch self {
        case .inProgress:
            1
        case .waiting:
            2
        case .paused:
            3
        case .finished:
            4
        }
    }
}

public enum DownloadType: String {
    case video
}

public struct DownloadData: Identifiable, Hashable {
    public let id: String
    public let courseId: String
    public let url: String
    public let fileName: String
    public let displayName: String
    public var progress: Double
    public let resumeData: Data?
    public var state: DownloadState
    public let type: DownloadType
    public let fileSize: Int

    public init(
        id: String,
        courseId: String,
        url: String,
        fileName: String,
        displayName: String,
        progress: Double,
        resumeData: Data?,
        state: DownloadState,
        type: DownloadType,
        fileSize: Int
    ) {
        self.id = id
        self.courseId = courseId
        self.url = url
        self.fileName = fileName
        self.displayName = displayName
        self.progress = progress
        self.resumeData = resumeData
        self.state = state
        self.type = type
        self.fileSize = fileSize
    }
}

public class NoWiFiError: LocalizedError {
    public init() {}
}

//sourcery: AutoMockable
public protocol DownloadManagerProtocol {
    var currentDownload: DownloadData? { get }
    func publisher() -> AnyPublisher<Int, Never>
    func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never>
    func addToDownloadQueue(blocks: [CourseBlock]) throws
    func getDownloadsForCourse(_ courseId: String) -> [DownloadData]
    func getDownloads() -> [DownloadData]
    func cancelDownloading(courseId: String, blocks: [CourseBlock]) throws
    func cancelDownloading(downloadData: DownloadData) throws
    func resumeDownloading() throws
    func pauseDownloading()
    func deleteFile(blocks: [CourseBlock])
    func deleteAllFiles()
    func fileUrl(for blockId: String) -> URL?
    func isLarge(blocks: [CourseBlock]) -> Bool
}

public enum DownloadManagerEvent {
    case added
    case started(DownloadData)
    case progress(Double, DownloadData)
    case paused(DownloadData)
    case canceled(DownloadData)
    case finished(DownloadData)
    case deletedFile(String)
    case clearedAll
}

public class DownloadManager: DownloadManagerProtocol {
    public var currentDownload: DownloadData?

    private let persistence: CorePersistenceProtocol
    private let appStorage: CoreStorage
    private let connectivity: ConnectivityProtocol
    private var downloadRequest: DownloadRequest?
    private var isDownloadingInProgress: Bool = false
    private var currentDownloadEventPublisher: PassthroughSubject<DownloadManagerEvent, Never> = .init()

    public init(
        persistence: CorePersistenceProtocol,
        appStorage: CoreStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.persistence = persistence
        self.appStorage = appStorage
        self.connectivity = connectivity
    }
    
    public func publisher() -> AnyPublisher<Int, Never> {
        persistence.publisher()
    }

    public func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        currentDownloadEventPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func isLarge(blocks: [CourseBlock]) -> Bool {
        true
        //(blocks.reduce(0) {$0 + Double($1.fileSize ?? 0)} / 1024 / 1024 / 1024) > 1
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) throws {
        if userCanDownload() {
            persistence.addToDownloadQueue(blocks: blocks)
            currentDownloadEventPublisher.send(.added)
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
            currentDownloadEventPublisher.send(.started(download))
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
        persistence.getDownloadsForCourse(courseId)
    }

    public func getDownloads() -> [DownloadData] {
        persistence.getAllDownloadData()
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) throws {
        downloadRequest?.cancel()
        
        let downloaded = getDownloadsForCourse(courseId).filter { $0.state == .finished }
        let blocksForDelete = blocks.filter { block in downloaded.first(where: { $0.id == block.id }) == nil }

        deleteFile(blocks: blocksForDelete)
        downloaded.forEach {
            currentDownloadEventPublisher.send(.canceled($0))
        }
        try newDownload()
    }

    public func cancelDownloading(downloadData: DownloadData) throws {
        downloadRequest?.cancel()
        do {
            try persistence.deleteDownloadData(id: downloadData.id)
            if let fileUrl = fileUrl(for: downloadData.id) {
                try FileManager.default.removeItem(at: fileUrl)
            }
            currentDownloadEventPublisher.send(.canceled(downloadData))
        } catch {
            NSLog("Error deleting file: \(error.localizedDescription)")
        }
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
            if let resumeData = download.resumeData {
                downloadRequest = AF.download(resumingWith: resumeData)
            } else {
                downloadRequest = AF.download(url)
            }

            downloadRequest?.downloadProgress { [weak self]  prog in
                guard let self else { return }
                let fractionCompleted = prog.fractionCompleted
                self.currentDownload?.progress = fractionCompleted
                self.currentDownload?.state = .inProgress
                self.currentDownloadEventPublisher.send(.progress(fractionCompleted, download))
                let completed = Double(fractionCompleted * 100)
                print(">>>>> Downloading", download.url, completed, "%")
            }

            downloadRequest?.responseData(completionHandler: { [weak self] data in
                guard let self else { return }
                if let data = data.value, let url = self.videosFolderUrl() {
                    self.saveFile(fileName: download.fileName, data: data, folderURL: url)
                    self.persistence.updateDownloadState(
                        id: download.id,
                        state: .finished,
                        resumeData: nil
                    )
                    self.currentDownload?.state = .finished
                    self.currentDownloadEventPublisher.send(.finished(download))
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
        downloadRequest?.cancel(byProducingResumeData: { [weak self] resumeData in
            guard let self else { return }
            self.persistence.updateDownloadState(
                id: currentDownload.id,
                state: .paused,
                resumeData: resumeData
            )
            self.currentDownload?.state = .paused
            self.currentDownloadEventPublisher.send(.paused(currentDownload))
        })
    }
    
    public func deleteFile(blocks: [CourseBlock]) {
        for block in blocks {
            do {
                try persistence.deleteDownloadData(id: block.id)
                currentDownloadEventPublisher.send(.deletedFile(block.id))
                if let fileURL = fileUrl(for: block.id) {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } catch {
                NSLog("Error deleting file: \(error.localizedDescription)")
            }
        }
    }
    
    public func deleteAllFiles() {
        let downloadData = persistence.getAllDownloadData()
        currentDownloadEventPublisher.send(.clearedAll)
        downloadData.forEach {
            if let fileURL = fileUrl(for: $0.id) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    NSLog("Error deleting All files: \(error.localizedDescription)")
                }
            }
        }
    }
    
    public func fileUrl(for blockId: String) -> URL? {
        guard let data = persistence.downloadData(by: blockId),
              data.url.count > 0,
              data.state == .finished else { return nil }
        let path = videosFolderUrl()
        let fileName = data.fileName
        return path?.appendingPathComponent(fileName)
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
    
    private func saveFile(fileName: String, data: Data, folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            NSLog("SaveFile Error", error.localizedDescription)
        }
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public class DownloadManagerMock: DownloadManagerProtocol {

    public init() {
        
    }

    public var currentDownload: DownloadData? {
        return nil
    }

    public func publisher() -> AnyPublisher<Int, Never> {
        return Just(1).eraseToAnyPublisher()
    }

    public func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        return Just(.canceled(.init(id: "", courseId: "", url: "", fileName: "", displayName: "", progress: 1, resumeData: nil, state: .inProgress, type: .video, fileSize: 0))).eraseToAnyPublisher()
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) {
        
    }
    
    public func getDownloadsForCourse(_ courseId: String) -> [DownloadData] {
        return []
    }

    public func getDownloads() -> [DownloadData] {
        []
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) {
        
    }

    public func cancelDownloading(downloadData: DownloadData) {

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

    public func isLarge(blocks: [CourseBlock]) -> Bool {
        false
    }

}
#endif
