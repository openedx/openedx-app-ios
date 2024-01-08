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

    public var fileSizeInMb: Double {
        Double(fileSize) / 1024.0 / 1024.0
    }

    public var fileSizeInMbText: String {
        String(format: "%.2fMB", fileSizeInMb)
    }

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

    func getDownloads() async -> [DownloadData]
    func getDownloadsForCourse(_ courseId: String) async -> [DownloadData]
    func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws
    func cancelDownloading(downloadData: DownloadData) async throws
    func deleteFile(blocks: [CourseBlock]) async
    func deleteAllFiles() async
    func fileUrl(for blockId: String) async -> URL?

    func addToDownloadQueue(blocks: [CourseBlock]) throws
    func isLarge(blocks: [CourseBlock]) -> Bool
    func resumeDownloading() throws
    func pauseDownloading()
    func fileUrl(for blockId: String) -> URL?
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

    // MARK: - Properties

    public var currentDownload: DownloadData?
    private let persistence: CorePersistenceProtocol
    private let appStorage: CoreStorage
    private let connectivity: ConnectivityProtocol
    private var downloadRequest: DownloadRequest?
    private var isDownloadingInProgress: Bool = false
    private var currentDownloadEventPublisher: PassthroughSubject<DownloadManagerEvent, Never> = .init()
    private let backgroundTaskProvider = BackgroundTaskProvider()
    private var cancellables = Set<AnyCancellable>()

    private var downloadQuality: DownloadQuality {
        appStorage.userSettings?.downloadQuality ?? .auto
    }

    // MARK: - Init

    public init(
        persistence: CorePersistenceProtocol,
        appStorage: CoreStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.persistence = persistence
        self.appStorage = appStorage
        self.connectivity = connectivity
        self.backgroundTask()
    }

    // MARK: - Publishers

    public func publisher() -> AnyPublisher<Int, Never> {
        persistence.publisher()
    }

    public func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        currentDownloadEventPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Intents

    public func isLarge(blocks: [CourseBlock]) -> Bool {
        (blocks.reduce(0) {
            $0 + Double($1.video(quality: downloadQuality)?.fileSize ?? 0)
        } / 1024 / 1024 / 1024) > 1
    }

    public func getDownloads() async -> [DownloadData] {
        await withCheckedContinuation { continuation in
            persistence.getAllDownloadData { downloads in
                continuation.resume(returning: downloads)
            }
        }
    }

    public func getDownloadsForCourse(_ courseId: String) async -> [DownloadData] {
        await withCheckedContinuation { continuation in
            persistence.getDownloadsForCourse(courseId) { downloads in
                continuation.resume(returning: downloads)
            }
        }
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) throws {
        if userCanDownload() {
            persistence.addToDownloadQueue(
                blocks: blocks,
                quality: downloadQuality
            )
            currentDownloadEventPublisher.send(.added)
            guard !isDownloadingInProgress else { return }
            try newDownload()
        } else {
            throw NoWiFiError()
        }
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

    public func resumeDownloading() throws {
        try newDownload()
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {
        downloadRequest?.cancel()

        let downloaded = await getDownloadsForCourse(courseId).filter { $0.state == .finished }
        let blocksForDelete = blocks.filter { block in downloaded.first(where: { $0.id == block.id }) == nil }

        await deleteFile(blocks: blocksForDelete)
        downloaded.forEach {
            currentDownloadEventPublisher.send(.canceled($0))
        }
        try newDownload()
    }

    public func cancelDownloading(downloadData: DownloadData) async throws {
        downloadRequest?.cancel()
        do {
            try persistence.deleteDownloadData(id: downloadData.id)
            if let fileUrl = await fileUrl(for: downloadData.id) {
                try FileManager.default.removeItem(at: fileUrl)
            }
            currentDownloadEventPublisher.send(.canceled(downloadData))
        } catch {
            NSLog("Error deleting file: \(error.localizedDescription)")
        }
        try newDownload()
    }

    public func deleteFile(blocks: [CourseBlock]) async {
        for block in blocks {
            do {
                try persistence.deleteDownloadData(id: block.id)
                currentDownloadEventPublisher.send(.deletedFile(block.id))
                if let fileURL = await fileUrl(for: block.id) {
                    try FileManager.default.removeItem(at: fileURL)
                }
            } catch {
                NSLog("Error deleting file: \(error.localizedDescription)")
            }
        }
    }

    public func deleteAllFiles() async {
        let downloadsData = await getDownloads()
        for downloadData in downloadsData {
            if let fileURL = await fileUrl(for: downloadData.id) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    NSLog("Error deleting All files: \(error.localizedDescription)")
                }
            }
        }
        currentDownloadEventPublisher.send(.clearedAll)
    }

    public func fileUrl(for blockId: String) async -> URL? {
        await withCheckedContinuation { continuation in
            persistence.downloadData(by: blockId) { [weak self] data in
                guard let data = data, data.url.count > 0, data.state == .finished else {
                    continuation.resume(returning: nil)
                    return
                }
                let path = self?.videosFolderUrl()
                let fileName = data.fileName
                continuation.resume(returning: path?.appendingPathComponent(fileName))
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

    private func newDownload() throws {
        guard userCanDownload() else {
            throw NoWiFiError()
        }
        guard let download = persistence.getNextBlockForDownloading() else {
            isDownloadingInProgress = false
            return
        }
        currentDownload = download
        try downloadFileWithProgress(download)
        currentDownloadEventPublisher.send(.started(download))
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

    private func downloadFileWithProgress(_ download: DownloadData) throws {
        guard let url = URL(string: download.url) else {
            return
        }

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

        downloadRequest?.responseData { [weak self] data in
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
        }
    }

    func cancelAllInProgress() {
        downloadRequest?.cancel()
        persistence.getAllDownloadData {  [weak self] downloadDatas in
            guard let self else { return }
            Task {
                for downloadData in downloadDatas.filter({ $0.state == .inProgress || $0.state == .waiting }) {
                    do {
                        try self.persistence.deleteDownloadData(id: downloadData.id)
                        if let fileUrl = await self.fileUrl(for: downloadData.id) {
                            try FileManager.default.removeItem(at: fileUrl)
                        }
                        self.currentDownloadEventPublisher.send(.canceled(downloadData))
                    } catch {
                        NSLog("Error deleting file: \(error.localizedDescription)")
                    }
                }
            }
        }
    }

    // MARK: - Private Intents

    private func backgroundTask() {
        backgroundTaskProvider.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case.didBecomeActive: break
                case .didEnterBackground: self.cancelAllInProgress()
                }
            }
            .store(in: &cancellables)
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

@available(iOSApplicationExtension, unavailable)
public final class BackgroundTaskProvider {

    private var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    private var currentEventPublisher: PassthroughSubject<Events, Never> = .init()

    public enum Events {
        case didBecomeActive
        case didEnterBackground
    }

    public func eventPublisher() -> AnyPublisher<Events, Never> {
        currentEventPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Init -

    deinit {
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.removeObserver(
            self,
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    public init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didEnterBackgroundNotification),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(didBecomeActiveNotification),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )
    }

    @objc
    func didEnterBackgroundNotification() {
        registerBackgroundTask()
        currentEventPublisher.send(.didEnterBackground)
    }

    @objc
    func didBecomeActiveNotification() {
        endBackgroundTaskIfActive()
        currentEventPublisher.send(.didBecomeActive)
    }

    // MARK: - Background Task -

    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            debugLog("iOS has signaled time has expired")
            self?.endBackgroundTaskIfActive()
        }
    }

    private func endBackgroundTaskIfActive() {
        let isBackgroundTaskActive = backgroundTask != .invalid
        if isBackgroundTaskActive {
            debugLog("Background task ended.")
            UIApplication.shared.endBackgroundTask(backgroundTask)
            backgroundTask = .invalid
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
        return Just(
            .canceled(
                .init(id: "", courseId: "", url: "", fileName: "", displayName: "", progress: 1, resumeData: nil, state: .inProgress, type: .video, fileSize: 0)
            )
        ).eraseToAnyPublisher()
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) {
        
    }

    public func getDownloads() -> [DownloadData] {
        []
    }

    public func getDownloadsForCourse(_ courseId: String) async -> [DownloadData] {
        await withCheckedContinuation { continuation in
            continuation.resume(returning: [])
        }
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {

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
