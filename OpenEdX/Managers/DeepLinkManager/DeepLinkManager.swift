//
//  DeepLinkManager.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation
import Core
import UIKit

public protocol DeepLinkService {
    func configureWith(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func handledURLWith(app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
}

class DeepLinkManager {
    private var services: [DeepLinkService] = []
    
    // Init manager
    public init(config: ConfigProtocol) {
        services = servicesFor(config: config)
    }
    
    private func servicesFor(config: ConfigProtocol) -> [DeepLinkService] {
        var deepServices: [DeepLinkService] = []
        // init deep link services
        if config.branch.enabled {
            deepServices.append(BranchService())
        }
        return deepServices
    }
    
    // check if any service is added (means enabled)
    var anyServiceEnabled: Bool {
        services.count > 0
    }
    
    // Configure services
    func configureDeepLinkService(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        for service in services {
            service.configureWith(launchOptions: launchOptions)
        }
    }
    
    // Handle open url
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        for service in services where service.handledURLWith(app: app, open: url, options: options) {
            return true
        }
        return false
    }
    
    // This method do redirect with link from push notification
    func processLinkFromNotification(_ link: PushLink) {
        // redirect if possible
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [String: Any]) {
        if anyServiceEnabled {
            // redirect if possible
        }
    }
    
}
