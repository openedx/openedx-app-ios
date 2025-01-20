//
//  Connectivity.swift
//  OpenEdX
//
//  Created by  Stepanok Ivan on 15.12.2022.
//

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
