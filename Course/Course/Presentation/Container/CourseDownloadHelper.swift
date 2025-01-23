//
//  CourseDownloadHelper.swift
//  Course
//
//  Created by Vadim Kuznetsov on 6.01.25.
//

import Combine
import Core
import Foundation

struct CourseDownloadValue {
    static let empty = CourseDownloadValue(
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
    var currentDownloadTask: DownloadDataTask?
    let courseDownloadTasks: [DownloadDataTask]
    let allDownloadTasks: [DownloadDataTask]
    let notFinishedTasks: [DownloadDataTask]
    let downloadableVerticals: Set<VerticalsDownloadState>
    let sequentialsStates: [String: DownloadViewState]
    let totalFilesSize: Int
    let downloadedFilesSize: Int
    let largestBlocks: [CourseBlock]
    let state: OfflineView.DownloadAllState
    
    mutating func setCurrentDownloadTask(task: DownloadDataTask?) {
        self.currentDownloadTask = task
    }
}

public final class CourseDownloadHelper: @unchecked Sendable {
    
    var value: CourseDownloadValue?
    var courseStructure: CourseStructure?
    var videoQuality: DownloadQuality = .auto

    private let queue: DispatchQueue = .init(label: "testQueue")
    private let manager: DownloadManagerProtocol
    private var sourcePublisher: PassthroughSubject<CourseDownloadValue, Never> = .init()
    private var sourceProgressPublisher: PassthroughSubject<DownloadDataTask, Never> = .init()
    private var cancellables = Set<AnyCancellable>()

    func publisher() -> AnyPublisher<CourseDownloadValue, Never> {
        sourcePublisher.share().eraseToAnyPublisher()
    }
    
    func progressPublisher() -> AnyPublisher<DownloadDataTask, Never> {
        sourceProgressPublisher
            .throttle(for: .seconds(0.1), scheduler: queue, latest: true)
            .share()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func stopAllDownloads() async throws {
        try await manager.cancelAllDownloading()
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

    func refreshValue() {
        Task(priority: .background) {
            await refreshValue()
        }
    }

    func cancelDownloading(task: DownloadDataTask) async throws {
        try await manager.cancelDownloading(task: task)
    }

    func refreshValue() async {
        guard let courseStructure else { return }
        let downloadTasks = await manager.getDownloadTasks()
        await enumerate(
            tasks: downloadTasks,
            courseStructure: courseStructure,
            currentDownloadTask: await manager.getCurrentDownloadTask()
        )
    }
    
    func sizeFor(block: CourseBlock) -> Int? {
        if block.type == .video {
            return block.encodedVideo?.video(downloadQuality: videoQuality)?.fileSize
        }
        return block.fileSize
    }
    
    func sizeFor(blocks: [CourseBlock]) -> Int {
        let filteredBlocks = blocks.filter { $0.isDownloadable }
        let sizes = filteredBlocks.compactMap { sizeFor(block: $0) }
        return sizes.reduce(0, +)
    }
    
    func sizeFor(sequential: CourseSequential) -> Int {
        let blocks = sequential.childs.flatMap({ $0.childs })
        return sizeFor(blocks: blocks)
    }
    
    func sizeFor(sequentials: [CourseSequential]) -> Int {
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

    private func getUsedDiskSpace() -> Int? {
        do {
            let attributes = try FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String)
            if let totalSpace = attributes[.systemSize] as? Int64,
                let freeSpace = attributes[.systemFreeSize] as? Int64 {
                return Int(totalSpace - freeSpace)
            }
        } catch {
            print("Error retrieving used disk space: \(error.localizedDescription)")
        }
        return nil
    }
}
