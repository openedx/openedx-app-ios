//
//  CourseDownloadHelper.swift
//  Course
//
//  Created by Vadim Kuznetsov on 6.01.25.
//

import Combine
import Core
import Foundation

//sourcery: AutoMockable
public protocol CourseDownloadHelperProtocol: Sendable {
    var value: CourseDownloadValue? { get }
    var courseStructure: CourseStructure? { get set }
    var videoQuality: DownloadQuality { get set }
    
    func publisher() -> AnyPublisher<CourseDownloadValue, Never>
    func progressPublisher() -> AnyPublisher<DownloadDataTask, Never>
    func refreshValue()
    func refreshValue() async
    func sizeFor(block: CourseBlock) -> Int?
    func sizeFor(blocks: [CourseBlock]) -> Int
    func sizeFor(sequential: CourseSequential) -> Int
    func sizeFor(sequentials: [CourseSequential]) -> Int
    func cancelDownloading(task: DownloadDataTask) async throws
}

public struct CourseDownloadValue: Sendable, Equatable {
    public static let empty = CourseDownloadValue(
        courseDownloadTasks: [],
        allDownloadTasks: [],
        notFinishedTasks: [],
        downloadableVerticals: [],
        sequentialsStates: [:],
        totalFilesSize: 0,
        downloadedFilesSize: 0,
        largestBlocks: [],
        state: .start
    )
    public var currentDownloadTask: DownloadDataTask?
    public let courseDownloadTasks: [DownloadDataTask]
    public let allDownloadTasks: [DownloadDataTask]
    public let notFinishedTasks: [DownloadDataTask]
    public let downloadableVerticals: Set<VerticalsDownloadState>
    public let sequentialsStates: [String: DownloadViewState]
    public let totalFilesSize: Int
    public let downloadedFilesSize: Int
    public let largestBlocks: [CourseBlock]
    let state: OfflineView.DownloadAllState
    
    mutating func setCurrentDownloadTask(task: DownloadDataTask?) {
        self.currentDownloadTask = task
    }
}

/// Helper to obtain download info for course
public final class CourseDownloadHelper: CourseDownloadHelperProtocol, @unchecked Sendable {
    
    public var value: CourseDownloadValue?
    public var courseStructure: CourseStructure?
    public var videoQuality: DownloadQuality = .auto

    private let queue: DispatchQueue = .init(label: "course.download.helper.queue")
    private let manager: DownloadManagerProtocol
    private var sourcePublisher: PassthroughSubject<CourseDownloadValue, Never> = .init()
    private var sourceProgressPublisher: PassthroughSubject<DownloadDataTask, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    public func publisher() -> AnyPublisher<CourseDownloadValue, Never> {
        sourcePublisher.share().eraseToAnyPublisher()
    }
    
    public func progressPublisher() -> AnyPublisher<DownloadDataTask, Never> {
        sourceProgressPublisher
            .throttle(for: .seconds(0.1), scheduler: queue, latest: true)
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    public init (courseStructure: CourseStructure?, manager: DownloadManagerProtocol) {
        self.manager = manager
        self.courseStructure = courseStructure
        manager.eventPublisher()
            .sink { [weak self] state in
                guard let self else { return }

                self.queue.async {[weak self] in
                    if case let .progress(currentTask) = state {
                        if let value = self?.value {
                            var newValue = value
                            newValue.setCurrentDownloadTask(task: currentTask)
                            self?.value = newValue
                        }
                        self?.sourceProgressPublisher.send(currentTask)
                        return
                    }
                    
                    self?.refreshValue()
                }
            }
            .store(in: &cancellables)
    }

    public func refreshValue() {
        Task(priority: .background) {
            await refreshValue()
        }
    }

    public func cancelDownloading(task: DownloadDataTask) async throws {
        try await manager.cancelDownloading(task: task)
    }

    public func refreshValue() async {
        guard let courseStructure else { return }
        let downloadTasks = await manager.getDownloadTasks()
        await enumerate(
            tasks: downloadTasks,
            courseStructure: courseStructure,
            currentDownloadTask: await manager.getCurrentDownloadTask()
        )
    }
    
    public func sizeFor(block: CourseBlock) -> Int? {
        if block.type == .video {
            return block.encodedVideo?.video(downloadQuality: videoQuality)?.fileSize
        }
        return block.fileSize
    }
    
    public func sizeFor(blocks: [CourseBlock]) -> Int {
        let filteredBlocks = blocks.filter { $0.isDownloadable }
        let sizes = filteredBlocks.compactMap { sizeFor(block: $0) }
        return sizes.reduce(0, +)
    }
    
    public func sizeFor(sequential: CourseSequential) -> Int {
        let blocks = sequential.childs.flatMap({ $0.childs })
        return sizeFor(blocks: blocks)
    }
    
    public func sizeFor(sequentials: [CourseSequential]) -> Int {
        let sizes = sequentials.map { sizeFor(sequential: $0) }
        return sizes.reduce(0, +)
    }
    
    // swiftlint:disable function_body_length
    private func enumerate(
        tasks: [DownloadDataTask],
        courseStructure: CourseStructure,
        currentDownloadTask: DownloadDataTask?
    ) async {
        await withCheckedContinuation { continuation in
            queue.async {[weak self] in
                guard let self else { return }
                let notFinishedTasks: [DownloadDataTask] = tasks.filter { $0.state != .finished }
                    .sorted(by: { $0.state.order < $1.state.order })
                let courseDownloadTasks = tasks.filter { $0.courseId == courseStructure.id }
                var downloadableVerticals: Set<VerticalsDownloadState> = []
                var sequentialsStates: [String: DownloadViewState] = [:]
                var totalFilesSize: Int = 0
                var downloadedFilesSize: Int = 0
                var largestBlocks: [(block: CourseBlock, task: DownloadDataTask)] = []
                var downloadState: OfflineView.DownloadAllState = .start
                for chapter in courseStructure.childs {
                    for sequential in chapter.childs {
                        var sequentialsChilds: [DownloadViewState] = []
                        for vertical in sequential.childs {
                            var verticalsChilds: [DownloadViewState] = []
                            for block in vertical.childs where block.isDownloadable {
                                if var download = courseDownloadTasks.first(where: { $0.blockId == block.id }) {
                                    if download.state == .finished, download.actualSize > 0 {
                                        downloadedFilesSize += download.actualSize
                                        totalFilesSize += download.actualSize
                                        largestBlocks.append((block, download))
                                        largestBlocks = Array(
                                            largestBlocks
                                                .sorted { $0.task.actualSize > $1.task.actualSize }
                                                .prefix(5)
                                        )
                                    } else {
                                        totalFilesSize += sizeFor(block: block) ?? 0
                                    }
                                    if let newDateOfLastModified = block.offlineDownload?.lastModified,
                                       let oldDateOfLastModified = download.lastModified {
                                        if Date(iso8601: newDateOfLastModified) > Date(iso8601: oldDateOfLastModified) {
                                            guard isEnoughSpace(for: sizeFor(block: block) ?? 0) else { return }
                                            download.lastModified = newDateOfLastModified
                                            sequentialsChilds.append(.available)
                                            verticalsChilds.append(.available)
                                            Task {
                                                try? await self.manager.cancelDownloading(task: download)
                                                try? await self.manager.addToDownloadQueue(blocks: [block])
                                            }
                                            continue
                                        }
                                    }
                                    switch download.state {
                                    case .waiting, .inProgress:
                                        sequentialsChilds.append(.downloading)
                                        verticalsChilds.append(.downloading)
                                    case .finished:
                                        sequentialsChilds.append(.finished)
                                        verticalsChilds.append(.finished)
                                    }
                                } else {
                                    sequentialsChilds.append(.available)
                                    verticalsChilds.append(.available)
                                    totalFilesSize += sizeFor(block: block) ?? 0
                                }
                            }
                            guard !verticalsChilds.isEmpty else { continue }
                            if verticalsChilds.first(where: { $0 == .downloading }) != nil {
                                downloadableVerticals.insert(.init(vertical: vertical, state: .downloading))
                            } else if verticalsChilds.allSatisfy({ $0 == .finished }) {
                                downloadableVerticals.insert(.init(vertical: vertical, state: .finished))
                            } else {
                                downloadableVerticals.insert(.init(vertical: vertical, state: .available))
                            }
                        }
                        
                        guard !sequentialsChilds.isEmpty else { continue }
                        if sequentialsChilds.first(where: { $0 == .downloading }) != nil {
                            sequentialsStates[sequential.id] = .downloading
                        } else if sequentialsChilds.allSatisfy({ $0 == .finished }) {
                            sequentialsStates[sequential.id] = .finished
                        } else {
                            sequentialsStates[sequential.id] = .available
                        }
                    }
                }
                if sequentialsStates.values.allSatisfy({ $0 == .available }) {
                    downloadState = .start
                }
                
                if sequentialsStates.values.contains(.downloading) {
                    downloadState = .cancel
                }
                let value = CourseDownloadValue(
                    currentDownloadTask: currentDownloadTask,
                    courseDownloadTasks: courseDownloadTasks,
                    allDownloadTasks: tasks,
                    notFinishedTasks: notFinishedTasks,
                    downloadableVerticals: downloadableVerticals,
                    sequentialsStates: sequentialsStates,
                    totalFilesSize: totalFilesSize,
                    downloadedFilesSize: downloadedFilesSize,
                    largestBlocks: largestBlocks.map { $0.block },
                    state: downloadState
                )

                self.value = value
                DispatchQueue.main.async {
                    self.sourcePublisher.send(value)
                }

                continuation.resume()
            }
        }
    }
    // swiftlint:enable function_body_length
    
    private func isEnoughSpace(for fileSize: Int) -> Bool {
        if let freeSpace = getFreeDiskSpace() {
            return freeSpace > Int(Double(fileSize) * 1.2)
        }
        return false
    }

    private func getFreeDiskSpace() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            if let freeSpace = attributes[.systemFreeSize] as? Int64 {
                return Int(freeSpace)
            }
        } catch {
            print("Error retrieving free disk space: \(error.localizedDescription)")
        }
        return nil
    }
}
