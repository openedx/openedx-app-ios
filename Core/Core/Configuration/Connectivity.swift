//
//  Connectivity.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 15.12.2022.
//

import Alamofire
import Combine
import Foundation

public enum InternetState: Sendable {
    case reachable
    case notReachable
}

/// @mockable
@MainActor
public protocol ConnectivityProtocol: Sendable {
    var isInternetAvaliable: Bool { get }
    var isMobileData: Bool { get }
    var internetReachableSubject: CurrentValueSubject<InternetState?, Never> { get }
    var internetState: InternetState? { get }
}

@MainActor
@Observable
public class Connectivity: ConnectivityProtocol {

    private let networkManager = NetworkReachabilityManager()
    private let verificationURL: URL
    private let verificationTimeout: TimeInterval
    private let cacheValidity: TimeInterval = 30
    private let notReachableDelay: TimeInterval = 1.5

    private var lastVerificationDate: TimeInterval?
    private var lastVerificationResult: Bool = true
    private var notReachableTask: Task<Void, Never>?

    // MARK: - Observable property (new way)
    public private(set) var internetState: InternetState? {
        didSet {
            // Keep backward compatibility - update Combine subject
            internetReachableSubject.send(internetState)
        }
    }

    // MARK: - Combine subject (for backward compatibility)
    public let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(nil)

    private(set) var _isInternetAvailable: Bool = true {
        didSet {
            internetState = _isInternetAvailable ? .reachable : .notReachable
        }
    }

    public var isInternetAvaliable: Bool {
        if let last = lastVerificationDate,
           Date().timeIntervalSince1970 - last < cacheValidity {
            return lastVerificationResult
        }

        Task {
            await performVerification()
        }

        return lastVerificationResult
    }

    public var isMobileData: Bool {
        networkManager?.isReachableOnCellular == true
    }

    public init(
        config: ConfigProtocol,
        timeout: TimeInterval = 15
    ) {
        self.verificationURL = config.baseURL
        self.verificationTimeout = timeout

        networkManager?.startListening(onQueue: .global()) { [weak self] status in
            guard let self = self else { return }
            Task { @MainActor in
                switch status {
                case .reachable:
                    // Cancel pending notReachable — network came back before debounce fired
                    self.notReachableTask?.cancel()
                    self.notReachableTask = nil
                    await self.performVerification()
                case .notReachable, .unknown:
                    // Debounce: wait before marking offline to filter transient blips
                    self.notReachableTask?.cancel()
                    self.notReachableTask = Task { @MainActor [weak self] in
                        try? await Task.sleep(nanoseconds: UInt64((self?.notReachableDelay ?? 1.5) * 1_000_000_000))
                        guard !Task.isCancelled, let self else { return }
                        // Verify with a real request before going offline
                        let live = await self.verifyInternet()
                        if live {
                            self.updateAvailability(true, at: Date().timeIntervalSince1970)
                        } else {
                            self.updateAvailability(false, at: Date().timeIntervalSince1970)
                        }
                    }
                }
            }
        }
    }

    deinit {
        networkManager?.stopListening()
    }

    private func performVerification() async {
        let now = Date().timeIntervalSince1970
        let live = await verifyInternet()
        updateAvailability(live, at: now)
    }

    private func updateAvailability(_ available: Bool, at timestamp: TimeInterval) {
        _isInternetAvailable = available
        lastVerificationDate = timestamp
        lastVerificationResult = available
    }

    private func verifyInternet() async -> Bool {
        var request = URLRequest(url: verificationURL)
        request.httpMethod = "HEAD"
        request.timeoutInterval = verificationTimeout
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            return response is HTTPURLResponse
        } catch {
            return false
        }
    }
}
