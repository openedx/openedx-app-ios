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

// sourcery: AutoMockable
@MainActor
public protocol ConnectivityProtocol: Sendable {
    var isInternetAvaliable: Bool { get }
    var isMobileData: Bool { get }
    var internetReachableSubject: CurrentValueSubject<InternetState?, Never> { get }
}

public class Connectivity: ConnectivityProtocol {

    private let networkManager = NetworkReachabilityManager()
    private let verificationURL: URL
    private let verificationTimeout: TimeInterval
    private let cacheValidity: TimeInterval = 5//30

    private var lastVerificationDate: TimeInterval?
    private var lastVerificationResult: Bool = true

    public let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(nil)

    private(set) var _isInternetAvailable: Bool = true {
        didSet {
            Task { @MainActor in
                internetReachableSubject.send(_isInternetAvailable ? .reachable : .notReachable)
            }
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
                    await self.performVerification()
                case .notReachable, .unknown:
                    self.updateAvailability(false, at: 0)
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
            if let http = response as? HTTPURLResponse, (200..<400).contains(http.statusCode) {
                return true
            }
        } catch {
            return false
        }
        return false
    }
}
