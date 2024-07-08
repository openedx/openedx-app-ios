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
    case finished

    public var order: Int {
        switch self {
        case .inProgress:
            1
        case .waiting:
            2
        case .finished:
            3
        }
    }
}

public enum DownloadType: String {
    case video
}

public struct DownloadDataTask: Identifiable, Hashable {
    public let id: String
    public let courseId: String
    public let blockId: String
    public let userId: Int
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
        blockId: String,
        courseId: String,
        userId: Int,
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
        self.blockId = blockId
        self.userId = userId
        self.url = url
        self.fileName = fileName
        self.displayName = displayName
        self.progress = progress
        self.resumeData = resumeData
        self.state = state
        self.type = type
        self.fileSize = fileSize
    }

    public init(sourse: CDDownloadData) {
        self.id = sourse.id ?? ""
        self.blockId = sourse.blockId ?? ""
        self.courseId = sourse.courseId ?? ""
        self.userId = Int(sourse.userId)
        self.url = sourse.url ?? ""
        self.fileName = sourse.fileName ?? ""
        self.displayName = sourse.displayName ?? ""
        self.progress = sourse.progress
        self.resumeData = sourse.resumeData
        self.state = DownloadState(rawValue: sourse.state ?? "") ?? .waiting
        self.type = DownloadType(rawValue: sourse.type ?? "") ?? .video
        self.fileSize = Int(sourse.fileSize)
    }
}

public class NoWiFiError: LocalizedError {
    public init() {}
}

//sourcery: AutoMockable
public protocol DownloadManagerProtocol {
    var currentDownloadTask: DownloadDataTask? { get }
    func publisher() -> AnyPublisher<Int, Never>
    func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never>

    func addToDownloadQueue(blocks: [CourseBlock]) throws

    func getDownloadTasks() async -> [DownloadDataTask]
    func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask]

    func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws
    func cancelDownloading(task: DownloadDataTask) async throws
    func cancelDownloading(courseId: String) async throws
    func cancelAllDownloading() async throws

    func deleteFile(blocks: [CourseBlock]) async
    func deleteAllFiles() async

    func fileUrl(for blockId: String) async -> URL?

    func resumeDownloading() throws
    func fileUrl(for blockId: String) -> URL?
    func isLargeVideosSize(blocks: [CourseBlock]) -> Bool
    
    func removeAppSupportDirectoryUnusedContent()
}

public enum DownloadManagerEvent {
    case added
    case started(DownloadDataTask)
    case progress(Double, DownloadDataTask)
    case paused(DownloadDataTask)
    case canceled(DownloadDataTask)
    case courseCanceled(String)
    case allCanceled
    case finished(DownloadDataTask)
    case deletedFile(String)
    case clearedAll
}

public class DownloadManager: DownloadManagerProtocol {

    // MARK: - Properties

    public var currentDownloadTask: DownloadDataTask?
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
        if let userId = appStorage.user?.id {
            self.persistence.set(userId: userId)
        }
        self.appStorage = appStorage
        self.connectivity = connectivity
        self.backgroundTask()
        try? self.resumeDownloading()
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

    public func isLargeVideosSize(blocks: [CourseBlock]) -> Bool {
        (blocks.reduce(0) {
            $0 + Double($1.encodedVideo?.video(downloadQuality: downloadQuality)?.fileSize ?? 0)
        } / 1024 / 1024 / 1024) > 1
    }

    public func getDownloadTasks() async -> [DownloadDataTask] {
        await withCheckedContinuation { continuation in
            persistence.getDownloadDataTasks { downloads in
                continuation.resume(returning: downloads)
            }
        }
    }

    public func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {
        await withCheckedContinuation { continuation in
            persistence.getDownloadDataTasksForCourse(courseId) { downloads in
                continuation.resume(returning: downloads)
            }
        }
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) throws {
        if userCanDownload() {
            persistence.addToDownloadQueue(
                blocks: blocks,
                downloadQuality: downloadQuality
            )
            currentDownloadEventPublisher.send(.added)
            guard !isDownloadingInProgress else { return }
            try newDownload()
        } else {
            throw NoWiFiError()
        }
    }

    public func resumeDownloading() throws {
        try newDownload()
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {
        downloadRequest?.cancel()
        let downloaded = await getDownloadTasksForCourse(courseId)
        let blocksForDelete = blocks.filter {  block in
            downloaded.first(where: { $0.blockId == block.id }) != nil
        }
        await deleteFile(blocks: blocksForDelete)
        downloaded.forEach {
            currentDownloadEventPublisher.send(.canceled($0))
        }
        try newDownload()
    }

    public func cancelDownloading(task: DownloadDataTask) async throws {
        downloadRequest?.cancel()
        do {
            if let fileUrl = await fileUrl(for: task.id) {
                try FileManager.default.removeItem(at: fileUrl)
            }
            try persistence.deleteDownloadDataTask(id: task.id)
            currentDownloadEventPublisher.send(.canceled(task))
        } catch {
            NSLog("Error deleting file: \(error.localizedDescription)")
        }
        try newDownload()
    }

    public func cancelDownloading(courseId: String) async throws {
        let tasks = await getDownloadTasksForCourse(courseId)
        await cancel(tasks: tasks)
        currentDownloadEventPublisher.send(.courseCanceled(courseId))
        downloadRequest?.cancel()
        try newDownload()
    }

    public func cancelAllDownloading() async throws {
        let tasks = await getDownloadTasks().filter { $0.state != .finished }
        await cancel(tasks: tasks)
        currentDownloadEventPublisher.send(.allCanceled)
        downloadRequest?.cancel()
        try newDownload()
    }

    public func deleteFile(blocks: [CourseBlock]) async {
        for block in blocks {
            do {
                if let fileURL = await fileUrl(for: block.id) {
                    try FileManager.default.removeItem(at: fileURL)
                }
                try persistence.deleteDownloadDataTask(id: block.id)
                currentDownloadEventPublisher.send(.deletedFile(block.id))
            } catch {
                debugLog("Error deleting file: \(error.localizedDescription)")
            }
        }
    }

    public func deleteAllFiles() async {
        let downloadsData = await getDownloadTasks()
        for downloadData in downloadsData {
            if let fileURL = await fileUrl(for: downloadData.id) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    debugLog("Error deleting All files: \(error.localizedDescription)")
                }
            }
        }
        currentDownloadEventPublisher.send(.clearedAll)
    }

    public func fileUrl(for blockId: String) async -> URL? {
        await withCheckedContinuation { continuation in
            persistence.downloadDataTask(for: blockId) { [weak self] data in
                guard let data = data, data.url.count > 0, data.state == .finished else {
                    continuation.resume(returning: nil)
                    return
                }
                let path = self?.videosFolderUrl
                let fileName = data.fileName
                continuation.resume(returning: path?.appendingPathComponent(fileName))
            }
        }
    }

    public func fileUrl(for blockId: String) -> URL? {
        guard let data = persistence.downloadDataTask(for: blockId),
              data.url.count > 0,
              data.state == .finished else { return nil }
        let path = videosFolderUrl
        let fileName = data.fileName
        return path?.appendingPathComponent(fileName)
    }

    // MARK: - Private Intents

    private func newDownload() throws {
        guard userCanDownload() else {
            throw NoWiFiError()
        }
        guard let downloadTask = persistence.nextBlockForDownloading() else {
            isDownloadingInProgress = false
            return
        }
        currentDownloadTask = downloadTask
        try downloadFileWithProgress(downloadTask)
        currentDownloadEventPublisher.send(.started(downloadTask))
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

    private func downloadFileWithProgress(_ download: DownloadDataTask) throws {
        guard let url = URL(string: download.url), let folderURL = self.videosFolderUrl else {
            return
        }

        persistence.updateDownloadState(
            id: download.id,
            state: .inProgress,
            resumeData: download.resumeData
        )
        self.isDownloadingInProgress = true
        let destination: DownloadRequest.Destination = { _, _ in
            let file = folderURL.appendingPathComponent(download.fileName)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        if let resumeData = download.resumeData {
            downloadRequest = AF.download(resumingWith: resumeData, to: destination)
        } else {
            downloadRequest = AF.download(url, to: destination)
        }

        downloadRequest?.downloadProgress { [weak self]  prog in
            guard let self else { return }
            let fractionCompleted = prog.fractionCompleted
            self.currentDownloadTask?.progress = fractionCompleted
            self.currentDownloadTask?.state = .inProgress
            self.currentDownloadEventPublisher.send(.progress(fractionCompleted, download))
            let completed = Double(fractionCompleted * 100)
            debugLog(">>>>> Downloading", download.url, completed, "%")
        }

        downloadRequest?.responseData { [weak self] _ in
            guard let self else { return }
            self.persistence.updateDownloadState(
                id: download.id,
                state: .finished,
                resumeData: nil
            )
            self.currentDownloadTask?.state = .finished
            self.currentDownloadEventPublisher.send(.finished(download))
            try? self.newDownload()
        }
    }

    private func waitingAll() {
        persistence.getDownloadDataTasks {  [weak self] tasks in
            guard let self else { return }
            Task {
                for task in tasks.filter({ $0.state == .inProgress }) {
                    self.persistence.updateDownloadState(
                        id: task.id,
                        state: .waiting,
                        resumeData: nil
                    )
                    self.currentDownloadEventPublisher.send(.added)
                }
                self.downloadRequest?.cancel()
            }
        }
    }

    private func cancel(tasks: [DownloadDataTask]) async {
        for task in tasks {
            do {
                if let fileUrl = await fileUrl(for: task.id) {
                    try FileManager.default.removeItem(at: fileUrl)
                }
                try persistence.deleteDownloadDataTask(id: task.id)
            } catch {
                debugLog("Error deleting file: \(error.localizedDescription)")
            }
        }
    }

    private func backgroundTask() {
        backgroundTaskProvider.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case.didBecomeActive: try? self.resumeDownloading()
                case .didEnterBackground: self.waitingAll()
                }
            }
            .store(in: &cancellables)
    }

    lazy var videosFolderUrl: URL? = {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directoryURL = documentDirectoryURL.appendingPathComponent(folderPathComponent, isDirectory: true)

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
                debugLog(error.localizedDescription)
                return nil
            }
        }
    }()

    private var folderPathComponent: String {
        if let id = appStorage.user?.id {
            return "\(id)_Files"
        }
        return "Files"
    }

    private func saveFile(fileName: String, data: Data, folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            debugLog("SaveFile Error", error.localizedDescription)
        }
    }
    
    public func removeAppSupportDirectoryUnusedContent() {
        deleteMD5HashedFolders()
    }
    
    private func getApplicationSupportDirectory() -> URL? {
        let fileManager = FileManager.default
        do {
            let appSupportDirectory = try fileManager.url(
                for: .applicationSupportDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true
            )
            return appSupportDirectory
        } catch {
            debugPrint("Error getting Application Support Directory: \(error)")
            return nil
        }
    }
    
    private func isMD5Hash(_ folderName: String) -> Bool {
        let md5Regex = "^[a-fA-F0-9]{32}$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", md5Regex)
        return predicate.evaluate(with: folderName)
    }
    
    private func deleteMD5HashedFolders() {
        guard let appSupportDirectory = getApplicationSupportDirectory() else {
            return
        }
        
        let fileManager = FileManager.default
        do {
            let folderContents = try fileManager.contentsOfDirectory(
                at: appSupportDirectory,
                includingPropertiesForKeys: nil,
                options: []
            )
            for folderURL in folderContents {
                let folderName = folderURL.lastPathComponent
                if isMD5Hash(folderName) {
                    do {
                        try fileManager.removeItem(at: folderURL)
                        debugPrint("Deleted folder: \(folderName)")
                    } catch {
                        debugPrint("Error deleting folder \(folderName): \(error)")
                    }
                }
            }
        } catch {
            debugPrint("Error reading contents of Application Support directory: \(error)")
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
// swiftlint:disable file_length
#if DEBUG
public class DownloadManagerMock: DownloadManagerProtocol {

    public init() {
        
    }

    public var currentDownloadTask: DownloadDataTask? {
        return nil
    }

    public func publisher() -> AnyPublisher<Int, Never> {
        return Just(1).eraseToAnyPublisher()
    }

    public func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        return Just(
            .canceled(
                .init(
                    id: "",
                    blockId: "",
                    courseId: "",
                    userId: 0,
                    url: "",
                    fileName: "",
                    displayName: "",
                    progress: 1,
                    resumeData: nil,
                    state: .inProgress,
                    type: .video,
                    fileSize: 0
                )
            )
        ).eraseToAnyPublisher()
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) {
        
    }

    public func getDownloadTasks() -> [DownloadDataTask] {
        []
    }

    public func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {
        await withCheckedContinuation { continuation in
            continuation.resume(returning: [])
        }
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {

    }

    public func cancelDownloading(task: DownloadDataTask) {

    }

    public func cancelDownloading(courseId: String) async {

    }

    public func cancelAllDownloading() async throws {

    }

    public func resumeDownloading() {
        
    }
    
    public func deleteFile(blocks: [CourseBlock]) {
        
    }
    
    public func deleteAllFiles() {
        
    }
    
    public func fileUrl(for blockId: String) -> URL? {
        return nil
    }

    public func isLargeVideosSize(blocks: [CourseBlock]) -> Bool {
        false
    }

    public func removeAppSupportDirectoryUnusedContent() {
        
    }
}
#endif
// swiftlint:enable file_length
