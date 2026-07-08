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
    // Read the base URL live rather than freezing it at init: with the LMS Directory
    // feature the active host changes at runtime when the learner picks a platform, so
    // the reachability probe must follow config.baseURL — otherwise it keeps verifying
    // the launch-time host (e.g. the localhost dev default) and reports Offline.
    private let config: ConfigProtocol
    private let verificationTimeout: TimeInterval
    private let cacheValidity: TimeInterval = 30
    private let notReachableDelay: TimeInterval = 1.5

    private var lastVerificationDate: TimeInterval?
    private var lastVerificationResult: Bool = true
    // The host the cached result was probed against. When the active LMS changes the
    // cache is stale even if still within cacheValidity, so we must re-probe the new host.
    private var lastVerificationURL: URL?
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
        let currentURL = config.baseURL
        // Cache is valid only when it was probed against the current host recently.
        if let last = lastVerificationDate,
           lastVerificationURL == currentURL,
           Date().timeIntervalSince1970 - last < cacheValidity {
            return lastVerificationResult
        }

        Task {
            await performVerification()
        }

        // No fresh result for the current host (first check, or the LMS just changed):
        // assume reachable rather than returning a result probed against a previous host,
        // so a freshly-selected platform isn't wrongly treated as offline. The actual
        // request will surface a genuine connectivity failure on its own.
        return lastVerificationURL == currentURL ? lastVerificationResult : true
    }

    public var isMobileData: Bool {
        networkManager?.isReachableOnCellular == true
    }

    public init(
        config: ConfigProtocol,
        timeout: TimeInterval = 15
    ) {
        self.config = config
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
                        await self.performVerification()
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
        // Capture the host up front so the cache records exactly what was probed,
        // even if the active LMS changes while the request is in flight.
        let url = config.baseURL
        let live = await verifyInternet(url: url)
        updateAvailability(live, url: url, at: now)
    }

    private func updateAvailability(_ available: Bool, url: URL, at timestamp: TimeInterval) {
        _isInternetAvailable = available
        lastVerificationDate = timestamp
        lastVerificationResult = available
        lastVerificationURL = url
    }

    private func verifyInternet(url: URL) async -> Bool {
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = verificationTimeout
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, (200..<400).contains(http.statusCode) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
}
