//
//  DownloadManager.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import SwiftUI
@preconcurrency import Combine
import ZipArchive
import OEXFoundation
import Alamofire

public enum DownloadState: String, Sendable {
    case waiting
    case inProgress
    case finished

    public var order: Int {
        switch self {
        case .inProgress:
            return 1
        case .waiting:
            return 2
        case .finished:
            return 3
        }
    }
}

public enum DownloadType: String, Sendable {
    case video
    case html, problem
}

public struct DownloadDataTask: Identifiable, Hashable, Sendable {
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
    public var lastModified: String?

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
        fileSize: Int,
        lastModified: String
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
        self.lastModified = lastModified
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
        self.lastModified = sourse.lastModified
    }
    
    public init?(block: CourseBlock, userId: Int, downloadQuality: DownloadQuality) {
        let url: URL
        let fileExtension: String
        let fileSize: Int
        if let html = block.offlineDownload, let htmlUrl = URL(string: html.fileUrl) {
            url = htmlUrl
            fileExtension = url.pathExtension
            fileSize = html.fileSize
            self.lastModified = html.lastModified
            self.type = .html
        } else if let video = block.encodedVideo?.video(downloadQuality: downloadQuality),
                  let videoUrlString = video.url,
                  let videoUrl = URL(string: videoUrlString) {
            url = videoUrl
            fileExtension = videoUrl.pathExtension
            fileSize = video.fileSize ?? 0
            self.type = .video
        } else { return nil }
        let fileName = "\(block.id).\(fileExtension)"
        
        let downloadDataId = "\(userId)_\(block.id)"
        self.id = downloadDataId
        self.blockId = block.id
        self.userId = userId
        self.courseId = block.courseId
        self.url = url.absoluteString
        self.fileName = fileName
        self.displayName = block.displayName
        self.progress = Double.zero
        self.resumeData = nil
        self.state = .waiting
        self.fileSize = fileSize
    }
}

public class NoWiFiError: LocalizedError, @unchecked Sendable {
    public init() {}
}

//sourcery: AutoMockable
@MainActor
public protocol DownloadManagerProtocol: Sendable {
    var currentDownloadTask: DownloadDataTask? { get }
    func publisher() throws -> AnyPublisher<Int, Never>
    func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never>

    func addToDownloadQueue(blocks: [CourseBlock]) async throws

    func getDownloadTasks() async -> [DownloadDataTask]
    func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask]

    func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws
    func cancelDownloading(task: DownloadDataTask) async throws
    func cancelDownloading(courseId: String) async throws
    func cancelAllDownloading() async throws

    func deleteAll() async

    func fileUrl(for blockId: String) async -> URL?
    func updateUnzippedFileSize(for sequentials: [CourseSequential]) async -> [CourseSequential]

    func resumeDownloading() async throws
    func isLargeVideosSize(blocks: [CourseBlock]) -> Bool

    func removeAppSupportDirectoryUnusedContent()
    func delete(blocks: [CourseBlock], courseId: String) async
}

public enum DownloadManagerEvent: Sendable {
    case added
    case started(DownloadDataTask)
    case progress(Double, DownloadDataTask)
    case paused(DownloadDataTask)
    case canceled([DownloadDataTask])
    case courseCanceled(String)
    case allCanceled
    case finished(DownloadDataTask)
    case deletedFile([String])
    case clearedAll
}

enum DownloadManagerState {
    case idle
    case downloading
    case paused
}

public class DownloadManager: DownloadManagerProtocol {
    // MARK: - Properties

    public nonisolated(unsafe) var currentDownloadTask: DownloadDataTask?
    private let persistence: CorePersistenceProtocol
    private let appStorage: CoreStorage
    private let connectivity: ConnectivityProtocol
    private var downloadRequest: DownloadRequest?
    private var currentDownloadEventPublisher: PassthroughSubject<DownloadManagerEvent, Never> = .init()
    private let backgroundTaskProvider = BackgroundTaskProvider()
    private var cancellables = Set<AnyCancellable>()
    private nonisolated(unsafe) var failedDownloads: [DownloadDataTask] = []

    private let indexPage = "index.html"

    private var downloadQuality: DownloadQuality {
        appStorage.userSettings?.downloadQuality ?? .auto
    }

    private var userId: Int {
        appStorage.user?.id ?? 0
    }
    
    private var queue: [DownloadDataTask] = [] {
        didSet {
            queuePublisher.send(0)
        }
    }
    private var queuePublisher: PassthroughSubject<Int, Never> = .init()
    private var state: DownloadManagerState = .idle
    // MARK: - Init
    
    public init(
        persistence: CorePersistenceProtocol,
        appStorage: CoreStorage,
        connectivity: ConnectivityProtocol
    ) {
        self.persistence = persistence
        self.appStorage = appStorage
        self.connectivity = connectivity
        if let userId = appStorage.user?.id {
            persistence.set(userId: userId)
            connectivity.internetReachableSubject
                .sink {[weak self] state in
                    guard let self else { return }
                    Task {
                        switch state {
                        case .notReachable:
                            self.waitingAll()
                        case .reachable:
                            try? await self.resumeDownloading()
                        case .none:
                            return
                        }
                    }
                }
                .store(in: &cancellables)
            self.backgroundTask()
        }

        NotificationCenter.default.publisher(for: .tryDownloadAgain)
            .compactMap { $0.object as? [DownloadDataTask] }
            .sink { [weak self] downloads in
                Task {
                    await self?.tryDownloadAgain(downloads: downloads)
                }
            }
            .store(in: &cancellables)
    }
    
    private func tryDownloadAgain(downloads: [DownloadDataTask]) async {
        var tasksToInsert: [DownloadDataTask] = []

        if queue.isEmpty {
            _ = await getDownloadTasks()
        }

        for task in downloads {
            if let index = queue.firstIndex(where: { $0.id == task.id }) {
                queue[index].state = .waiting
            } else {
                queue.append(task)
                var newTask = task
                newTask.state = .waiting
                tasksToInsert.append(newTask)
            }
        }

        if !tasksToInsert.isEmpty {
            persistence.addToDownloadQueue(tasks: tasksToInsert)
        }

        try? newDownload()
    }

    // MARK: - Publishers

    public func publisher() -> AnyPublisher<Int, Never> {
        queuePublisher
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    public func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        currentDownloadEventPublisher
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    // MARK: - Intents

    public func isLargeVideosSize(blocks: [CourseBlock]) -> Bool {
        let totalSizeInBytes = blocks.reduce(0) { accumulator, block in
            let videoSize = block.encodedVideo?.video(downloadQuality: downloadQuality)?.fileSize ?? 0
            return accumulator + Double(videoSize)
        }
        
        let totalSizeInGB = totalSizeInBytes / (1024 * 1024 * 1024)
        
        return totalSizeInGB > 1
    }

    public func getDownloadTasks() async -> [DownloadDataTask] {
        if queue.isEmpty {
            queue =  await persistence.getDownloadDataTasks()
        }
        return queue
    }

    public func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {
        if queue.isEmpty {
            await persistence.getDownloadDataTasksForCourse(courseId)
        } else {
            queue.filter({$0.courseId == courseId})
        }
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) throws {
        if userCanDownload() {
            let newTasks = blocks.compactMap {
                DownloadDataTask(
                    block: $0,
                    userId: userId,
                    downloadQuality: downloadQuality
                )
            }

            for task in newTasks where queue.first(where: { $0.id == task.id }) == nil {
                queue.append(task)
            }

            persistence.addToDownloadQueue(
                blocks: blocks,
                downloadQuality: downloadQuality
            )
            currentDownloadEventPublisher.send(.added)
            try newDownload()
        } else {
            throw NoWiFiError()
        }
    }

    public func resumeDownloading() async throws {
        guard state != .downloading && connectivity.isInternetAvaliable else { return }
        state = .idle
        if queue.isEmpty {
            queue = await persistence.getDownloadDataTasks()
        }
        try newDownload()
    }

    private func cancelCurrentTask() {
        downloadRequest?.cancel()
        currentDownloadTask = nil
    }
    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {
        if blocks.contains(where: { $0.id == currentDownloadTask?.blockId }) {
            cancelCurrentTask()
        }
        await delete(blocks: blocks, courseId: courseId)
        try newDownload()
    }

    public func cancelDownloading(task: DownloadDataTask) throws {
        if task.id == currentDownloadTask?.id {
            cancelCurrentTask()
        }

        delete(tasks: [task])
        try newDownload()
    }

    public func cancelDownloading(courseId: String) async throws {
        if currentDownloadTask?.courseId == courseId {
            cancelCurrentTask()
        }

        let tasks = await getDownloadTasksForCourse(courseId)
        delete(tasks: tasks)
        currentDownloadEventPublisher.send(.courseCanceled(courseId))
        try newDownload()
    }

    public func cancelAllDownloading() async throws {
        cancelCurrentTask()

        let tasks = await getDownloadTasks().filter { $0.state != .finished }
        delete(tasks: tasks)
        currentDownloadEventPublisher.send(.allCanceled)
        try newDownload()
    }

    public func delete(blocks: [CourseBlock], courseId: String) async {
        let tasks = await getDownloadTasksForCourse(courseId)
        let tasksForDelete = tasks.filter {  task in
            blocks.first(where: { $0.id == task.blockId }) != nil
        }
        delete(tasks: tasksForDelete)
    }

//swift6
    public func updateUnzippedFileSize(for sequentials: [CourseSequential]) async -> [CourseSequential] {
        var updatedSequentials = sequentials

        for i in 0..<updatedSequentials.count {
            for j in 0..<updatedSequentials[i].childs.count {
                for k in 0..<updatedSequentials[i].childs[j].childs.count {
                    let block = updatedSequentials[i].childs[j].childs[k]
                    if let fileUrl = await fileUrl(for: block.id) {
                        do {
                            if fileUrl.lastPathComponent == indexPage {
                                let folderUrl = fileUrl.deletingLastPathComponent()
                                let folderSize = try calculateFolderSize(at: folderUrl)
                                updatedSequentials[i].childs[j].childs[k].actualFileSize = folderSize
                            } else {
                                let fileAttributes = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
                                if let fileSize = fileAttributes[.size] as? NSNumber {
                                    let fileSizeInBytes = fileSize.intValue
                                    updatedSequentials[i].childs[j].childs[k].actualFileSize = fileSizeInBytes
                                }
                            }
                        } catch {
                            debugLog("Failed to get file size for \(fileUrl): \(error)")
                        }
                    }
                }
            }
        }

        return updatedSequentials
    }

    func calculateFolderSize(at url: URL) throws -> Int {
        let fileManager = FileManager.default
        let resourceKeys: [URLResourceKey] = [.isDirectoryKey, .fileSizeKey]
        var totalSize: Int64 = 0

        if let enumerator = fileManager.enumerator(
            at: url,
            includingPropertiesForKeys: resourceKeys,
            options: [],
            errorHandler: nil
        ) {
            for case let fileUrl as URL in enumerator {
                let resourceValues = try fileUrl.resourceValues(forKeys: Set(resourceKeys))
                if resourceValues.isDirectory == false {
                    if let fileSize = resourceValues.fileSize {
                        totalSize += Int64(fileSize)
                    }
                }
            }
        }

        return Int(totalSize)
    }
    
    public func deleteAll() async {
        let downloadsData = await getDownloadTasks()
        delete(tasks: downloadsData)
        currentDownloadEventPublisher.send(.clearedAll)
    }

    private func downloadTask(for blockId: String) async -> DownloadDataTask? {
        if queue.isEmpty {
            return await persistence.downloadDataTask(for: blockId)
        }
        return queue.first(where: {$0.blockId == blockId})
    }
    
    public func fileUrl(for blockId: String) async -> URL? {
        guard let data = await downloadTask(for: blockId),
              data.url.count > 0,
              data.state == .finished else { return nil }
        let path = filesFolderUrl
        switch data.type {
        case .html, .problem:
            if let folderUrl = URL(string: data.url) {
                let folder = folderUrl.deletingPathExtension().lastPathComponent
                return path?.appendingPathComponent(folder).appendingPathComponent(indexPage)
            } else {
                return nil
            }
        case .video:
            return path?.appendingPathComponent(data.fileName)
        }
    }
    
    public func fileOrFolderUrl(for blockId: String) async -> URL? {
        guard let data = await persistence.downloadDataTask(for: blockId),
              data.url.count > 0,
              data.state == .finished else { return nil }
        let path = filesFolderUrl
        switch data.type {
        case .html, .problem:
            if let folderUrl = URL(string: data.url) {
                let folder = folderUrl.deletingPathExtension().lastPathComponent
                return path?.appendingPathComponent(folder)
            } else {
                return nil
            }
        case .video:
            return path?.appendingPathComponent(data.fileName)
        }
    }

    // MARK: - Private Intents

    @MainActor
    private func newDownload() throws {
        guard state != .paused else { return }
        guard userCanDownload() else {
            throw NoWiFiError()
        }

        guard downloadRequest?.state != .resumed else { return }
        guard let downloadTask = queue.first(where: {$0.state != .finished}) else {
            downloadRequest = nil
            currentDownloadTask = nil
            if !failedDownloads.isEmpty {
                DispatchQueue.main.async {
                    NotificationCenter.default.post(
                        name: .showDownloadFailed,
                        object: self.failedDownloads
                    )
                    self.failedDownloads = []
                }
            }
            print(">>> IS NIL")
            return
        }
        if !connectivity.isInternetAvaliable {
            failedDownloads.append(downloadTask)
            try cancelDownloading(task: downloadTask)
            return
        }
        if downloadTask.type == .html || downloadTask.type == .problem {
            try downloadHTMLWithProgress(downloadTask)
        } else {
            try downloadFileWithProgress(downloadTask)
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

    private func downloadFileWithProgress(_ download: DownloadDataTask) throws {
        guard state != .paused else { return }
        guard let url = URL(string: download.url), let folderURL = self.filesFolderUrl else {
            delete(tasks: [download])
            try newDownload()
            return
        }

        currentDownloadEventPublisher.send(.started(download))

        if let index = queue.firstIndex(where: {$0.id == download.id}) {
            queue[index].state = .inProgress
        }
        
        persistence.updateDownloadState(
            id: download.id,
            state: .inProgress,
            resumeData: download.resumeData
        )
        currentDownloadTask = download
        currentDownloadTask?.state = .inProgress
        let destination: DownloadRequest.Destination = { _, _ in
            let file = folderURL.appendingPathComponent(download.fileName)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }

        if let resumeData = download.resumeData {
            downloadRequest = AF.download(resumingWith: resumeData, to: destination)
        } else {
            downloadRequest = AF.download(url, to: destination)
        }

        downloadRequest?.downloadProgress { @Sendable [weak self] prog in
            guard let self = self else { return }
            let fractionCompleted = prog.fractionCompleted
            self.currentDownloadTask?.progress = fractionCompleted
            self.currentDownloadTask?.state = .inProgress
            DispatchQueue.main.async {
                self.currentDownloadEventPublisher.send(.progress(fractionCompleted, download))
            }
            let completed = Double(fractionCompleted * 100)
            debugLog(">>>>> Downloading File", download.url, completed, "%")
        }

        downloadRequest?.responseData { [weak self] response in
            guard let self else { return }
            var state: DownloadState = .finished
            if let error = response.error {
                if error.isInternetError {
                    state = .waiting
                } else if error.asAFError?.isExplicitlyCancelledError == false {
                    self.failedDownloads.append(download)
                    Task {
                        try? await self.newDownload()
                    }
                    return
                }
            }
            
                self.persistence.updateDownloadState(
                    id: download.id,
                    state: state,
                    resumeData: nil
                )
            DispatchQueue.main.async {
                if let index = self.queue.firstIndex(where: {$0.id == download.id}) {
                    self.queue[index].state = state
                }
                self.currentDownloadTask?.state = state
                
                if state != .waiting {
                    self.currentDownloadEventPublisher.send(.finished(download))
                    try? self.newDownload()
                } else {
                    self.currentDownloadEventPublisher.send(.paused(download))
                }
            }
        }
        state = .downloading
    }

    private func downloadHTMLWithProgress(_ download: DownloadDataTask) throws {
        guard state != .paused else { return }
        guard let url = URL(string: download.url), let folderURL = self.filesFolderUrl else {
            delete(tasks: [download])
            try newDownload()
            return
        }
        currentDownloadEventPublisher.send(.started(download))
        if let index = queue.firstIndex(where: {$0.id == download.id}) {
            queue[index].state = .inProgress
        }

        persistence.updateDownloadState(
            id: download.id,
            state: .inProgress,
            resumeData: download.resumeData
        )

        let destination: DownloadRequest.Destination = { _, _ in
            let fileName = URL(string: download.url)?.lastPathComponent ?? "file.zip"
            let file = folderURL.appendingPathComponent(fileName)
            return (file, [.createIntermediateDirectories, .removePreviousFile])
        }
        currentDownloadTask = download
        currentDownloadTask?.state = .inProgress
        if let resumeData = download.resumeData {
            downloadRequest = AF.download(resumingWith: resumeData, to: destination)
        } else {
            downloadRequest = AF.download(url, to: destination)
        }
        downloadRequest?.downloadProgress { [weak self] prog in
            guard let self else { return }
            let fractionCompleted = prog.fractionCompleted
            self.currentDownloadTask?.progress = fractionCompleted
            DispatchQueue.main.async {
                self.currentDownloadEventPublisher.send(.progress(fractionCompleted, download))
            }
            let completed = Double(fractionCompleted * 100)
            debugLog(">>>>> Downloading HTML", download.url, completed, "%")
        }

        downloadRequest?.responseURL { [weak self] response in
            guard let self else {
                return
            }
            if let error = response.error {
                if error.asAFError?.isExplicitlyCancelledError == false {
                    failedDownloads.append(download)
                    DispatchQueue.main.async {
                        try? self.newDownload()
                    }
                    return
                }
            }
            if let fileURL = response.fileURL {
                DispatchQueue.main.async {
                    self.unzipFile(url: fileURL)
                    if let index = self.queue.firstIndex(where: {$0.id == download.id}) {
                        self.queue[index].state = .finished
                    }
                    self.persistence.updateDownloadState(
                        id: download.id,
                        state: .finished,
                        resumeData: nil
                    )
                    self.currentDownloadTask?.state = .finished
                    DispatchQueue.main.async {
                        self.currentDownloadEventPublisher.send(.finished(download))
                    }
                    try? self.newDownload()
                }
            }
        }
        state = .downloading
    }

    private func waitingAll() {
        guard state != .paused else { return }
        downloadRequest?.suspend()

        for i in 0 ..< queue.count where queue[i].state == .inProgress {
            queue[i].state = .waiting

            self.persistence.updateDownloadState(
                id: queue[i].id,
                state: .waiting,
                resumeData: nil
            )
        }
        self.currentDownloadEventPublisher.send(.added)
        state = .paused
    }

    private func delete(tasks: [DownloadDataTask]) {
        let ids = tasks.map { $0.id }
        let names = tasks.map { $0.fileName }

        deleteTasks(with: ids, and: names)
        currentDownloadEventPublisher.send(.deletedFile(tasks.map({$0.blockId})))
    }
    
    private func deleteTasks(with ids: [String], and names: [String]) {
        queue.removeAll(where: {ids.contains($0.id)})
        removeFiles(names: names)
        persistence.deleteDownloadDataTasks(ids: ids)
    }
    
    private func removeFiles(names: [String]) {
        guard let folderURL = filesFolderUrl else { return }
        for name in names {
            let fileURL = folderURL.appendingPathComponent(name)
            if FileManager.default.fileExists(atPath: fileURL.path) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    debugLog("Error deleting file: \(error.localizedDescription)")
                }
            }
        }
    }

    private func backgroundTask() {
        backgroundTaskProvider.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }
                Task {
                    switch state {
                    case.didBecomeActive: try? await self.resumeDownloading()
                    case .didEnterBackground: self.waitingAll()
                    }
                }
            }
            .store(in: &cancellables)
    }

    var filesFolderUrl: URL? {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        guard let folderPathComponent else { return nil }
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
    }

    private var folderPathComponent: String? {
        if let id = appStorage.user?.id {
            return "\(id)_Files"
        }
        return nil
    }

    private func saveFile(fileName: String, data: Data, folderURL: URL) {
        let fileURL = folderURL.appendingPathComponent(fileName)
        do {
            try data.write(to: fileURL)
        } catch {
            debugLog("SaveFile Error", error.localizedDescription)
        }
    }

    private func unzipFile(url: URL) {
        let fileName = url.deletingPathExtension().lastPathComponent
        guard let directoryURL = filesFolderUrl else {
            return
        }
        let uniqueDirectory = directoryURL.appendingPathComponent(fileName, isDirectory: true)

        try? FileManager.default.removeItem(at: uniqueDirectory)

        do {
            try FileManager.default.createDirectory(
                at: uniqueDirectory,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            debugLog("Error creating temporary directory: \(error.localizedDescription)")
        }
        SSZipArchive.unzipFile(atPath: url.path, toDestination: uniqueDirectory.path)

        do {
            try FileManager.default.removeItem(at: url)
        } catch {
            debugLog("Error removing file: \(error.localizedDescription)")
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

    func isMD5Hash(_ folderName: String) -> Bool {
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
public final class BackgroundTaskProvider: @unchecked Sendable {

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

    @MainActor
    @objc
    func didEnterBackgroundNotification() {
        registerBackgroundTask()
        currentEventPublisher.send(.didEnterBackground)
    }

    @MainActor
    @objc
    func didBecomeActiveNotification() {
        endBackgroundTaskIfActive()
        currentEventPublisher.send(.didBecomeActive)
    }

    // MARK: - Background Task -

    @MainActor
    private func registerBackgroundTask() {
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            debugLog("iOS has signaled time has expired")
            Task { @MainActor in
                self?.endBackgroundTaskIfActive()
            }
        }
    }

    @MainActor
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
    public init() {}

    public func updateUnzippedFileSize(for sequentials: [CourseSequential]) -> [CourseSequential] {[]}
    public func delete(blocks: [CourseBlock], courseId: String) async {
        
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
                [
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
                    fileSize: 0,
                    lastModified: ""
                )
                ]
            )
        ).eraseToAnyPublisher()
    }

    public func addToDownloadQueue(blocks: [CourseBlock]) {}

    public func getDownloadTasks() -> [DownloadDataTask] {
        []
    }

    public func getDownloadTasksForCourse(_ courseId: String) async -> [DownloadDataTask] {
        await withCheckedContinuation { continuation in
            continuation.resume(returning: [])
        }
    }

    public func cancelDownloading(courseId: String, blocks: [CourseBlock]) async throws {}

    public func cancelDownloading(task: DownloadDataTask) {}

    public func cancelDownloading(courseId: String) async {}

    public func cancelAllDownloading() async throws {}

    public func resumeDownloading() {}

    public func deleteFile(blocks: [CourseBlock]) {}

    public func deleteAll() {}
                
    public func fileUrl(for blockId: String) async -> URL? {
        return nil
    }

    public func isLargeVideosSize(blocks: [CourseBlock]) -> Bool {
        false
    }

    public func removeAppSupportDirectoryUnusedContent() {}
}
#endif
// swiftlint:enable file_length
