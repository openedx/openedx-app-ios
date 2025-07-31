////
////  Connectivity.swift
////  OpenEdX
////
////  Created by  Stepanok Ivan on 15.12.2022.
////

import Alamofire
import Combine
import Foundation

public enum InternetState: Sendable {
    case reachable
    case notReachable
}

//sourcery: AutoMockable
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
          return _isInternetAvailable
      }

    public var isMobileData: Bool {
        if let networkManager {
           return networkManager.isReachableOnCellular
        } else {
            return false
        }
    }

    public let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(nil)

    public init(
        urlToVerify: URL = Config().baseURL,
        timeout: TimeInterval = 15
    ) {
        self.verificationURL = urlToVerify
        self.verificationTimeout = timeout
        checkInternet()
    }

    deinit {
        networkManager?.stopListening()
    }

    private func checkInternet() {
        guard let nm = networkManager else {
            _isInternetAvailable = false
            return
        }

        nm.startListening { [weak self] status in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch status {
                case .reachable:
                    let nowTS = Date().timeIntervalSince1970
                    if let lastTS = Connectivity.lastVerificationDate,
                       nowTS - lastTS < self.secondsPast {
                        self._isInternetAvailable = Connectivity.lastVerificationResult
                    } else {
                        Task { @MainActor in
                            let live = await self.verifyInternet()
                            Connectivity.lastVerificationDate = Date().timeIntervalSince1970
                            Connectivity.lastVerificationResult = live
                            self._isInternetAvailable = live
                        }
                    }
                case .notReachable, .unknown:
                    Connectivity.lastVerificationDate = nil
                    Connectivity.lastVerificationResult = false
                    self._isInternetAvailable = false
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
                return true
            }
        } catch {
            return false
        }
        return false
    }
}
