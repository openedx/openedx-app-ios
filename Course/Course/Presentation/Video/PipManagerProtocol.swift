//
//  PipManagerProtocol.swift
//  Course
//
//  Created by Vadim Kuznetsov on 22.04.24.
//

import Combine
import Foundation

@MainActor
public protocol PipManagerProtocol: Sendable {
    var isPipActive: Bool { get }
    var isPipPlaying: Bool { get }
    
    func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolderProtocol?
    func set(holder: PlayerViewControllerHolderProtocol)
    func remove(holder: PlayerViewControllerHolderProtocol)
    func restore(holder: PlayerViewControllerHolderProtocol) async throws
    func pipRatePublisher() -> AnyPublisher<Float, Never>?
    func pauseCurrentPipVideo()
}

#if DEBUG
public final class PipManagerProtocolMock: PipManagerProtocol {
    public var isPipActive: Bool {
        false
    }
    
    public var isPipPlaying: Bool {
        false
    }

    public init() {}
    public func holder(
        for url: URL?,
        blockID: String,
        courseID: String,
        selectedCourseTab: Int
    ) -> PlayerViewControllerHolderProtocol? {
        return nil
    }
    public func set(holder: PlayerViewControllerHolderProtocol) {}
    public func remove(holder: PlayerViewControllerHolderProtocol) {}
    public func restore(holder: PlayerViewControllerHolderProtocol) async throws {}
    public func pipRatePublisher() -> AnyPublisher<Float, Never>? { nil }
    public func pauseCurrentPipVideo() {}
}
#endif
