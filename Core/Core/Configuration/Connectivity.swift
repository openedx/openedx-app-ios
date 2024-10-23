//
//  Connectivity.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 15.12.2022.
//

import Alamofire
import Combine
import Foundation

public enum InternetState {
    case reachable
    case notReachable
}

//sourcery: AutoMockable
public protocol ConnectivityProtocol {
    var isInternetAvaliable: Bool { get }
    var isMobileData: Bool { get }
    var internetReachableSubject: CurrentValueSubject<InternetState?, Never> { get }
}

public class Connectivity: ConnectivityProtocol {
    let networkManager = NetworkReachabilityManager()
    
    public var isInternetAvaliable: Bool {
        //        false
        networkManager?.isReachable ?? false
    }
    
    public var isMobileData: Bool {
        if let networkManager {
           return networkManager.isReachableOnCellular
        } else {
            return false
        }
    }
    
    public let internetReachableSubject = CurrentValueSubject<InternetState?, Never>(nil)
    
    public init() {
        checkInternet()
    }
    
    func checkInternet() {
        if let networkManager {
            networkManager.startListening { status in
                DispatchQueue.main.async {
                    switch status {
                    case .unknown:
                        self.internetReachableSubject.send(InternetState.notReachable)
                    case .notReachable:
                        self.internetReachableSubject.send(InternetState.notReachable)
                    case .reachable:
                        self.internetReachableSubject.send(InternetState.reachable)
                    }
                }
            }
        } else {
            DispatchQueue.main.async {
                self.internetReachableSubject.send(InternetState.notReachable)
            }
        }
    }
}

public class ConnectivityMock: ConnectivityProtocol {
    
    // Default values that can be changed in tests
    public var isInternetAvaliable: Bool = true
    public var isMobileData: Bool = false
    
    // Allow changing internet state in tests
    public var internetReachableSubject: CurrentValueSubject<InternetState?, Never>
    
    public init(
        isInternetAvaliable: Bool = true,
        isMobileData: Bool = false,
        initialState: InternetState? = .reachable
    ) {
        self.isInternetAvaliable = isInternetAvaliable
        self.isMobileData = isMobileData
        self.internetReachableSubject = CurrentValueSubject<InternetState?, Never>(initialState)
    }
    
    // Helper method to simulate network state changes
    public func simulateNetworkStateChange(_ state: InternetState) {
        DispatchQueue.main.async { [weak self] in
            self?.internetReachableSubject.send(state)
            self?.isInternetAvaliable = state == .reachable
        }
    }
    
    // Helper method to simulate connection type changes
    public func simulateConnectionTypeChange(isMobileData: Bool) {
        self.isMobileData = isMobileData
    }
}
