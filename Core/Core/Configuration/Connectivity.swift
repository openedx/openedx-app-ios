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

@MainActor
public class Connectivity: ConnectivityProtocol {

    private let networkManager = NetworkReachabilityManager()
    private let verificationURL: URL
    private let verificationTimeout: TimeInterval
    private let secondsPast: TimeInterval = 30

    private static var lastVerificationDate: TimeInterval?
    private static var lastVerificationResult: Bool = false

    private var _isInternetAvailable: Bool = true {
        didSet {
            internetReachableSubject.send(_isInternetAvailable ? .reachable : .notReachable)
        }
    }

    public var isInternetAvaliable: Bool {
        _isInternetAvailable
    }

    public var isMobileData: Bool {
        networkManager?.isReachableOnCellular == true
    }

    public let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(nil)

    public init(
        config: ConfigProtocol,
        timeout: TimeInterval = 15
    ) {
        print("+++ go")
        self.verificationURL = config.baseURL
        self.verificationTimeout = timeout
        checkInternet()
    }

    deinit {
        print("+++ deinit")
        networkManager?.stopListening()
    }

    @MainActor
    private func updateAvailability(
        _ available: Bool,
        lastChecked: TimeInterval = Date().timeIntervalSince1970
    ) {
        self._isInternetAvailable = available
        Connectivity.lastVerificationDate = lastChecked
        Connectivity.lastVerificationResult = available
    }

    func checkInternet() {
        networkManager?.startListening(onQueue: .global()) { [weak self] status in
            guard let self = self else { return }
            let now = Date().timeIntervalSince1970

            Task { @MainActor in
                switch status {
                case .reachable:
                    if let last = Connectivity.lastVerificationDate,
                       now - last < self.secondsPast {
                        print("+++ last")
                        self.updateAvailability(Connectivity.lastVerificationResult)
                    } else {
                        Task.detached {
                            print("+++ verif")
                            let live = await self.verifyInternet()
                            await self.updateAvailability(live, lastChecked: Date().timeIntervalSince1970)
                        }
                    }

                case .notReachable, .unknown:
                    self.updateAvailability(false, lastChecked: 0)
                }
            }
        }
    }

    private func verifyInternet() async -> Bool {
        var request = URLRequest(url: verificationURL)
        request.httpMethod = "HEAD"
        request.timeoutInterval = verificationTimeout

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse,
               (200..<400).contains(http.statusCode) {
                print("++++ got response")
                return true
            }
        } catch {
            print("++++ no response")
            return false
        }
        print("++++ no response")
        return false
    }
}
