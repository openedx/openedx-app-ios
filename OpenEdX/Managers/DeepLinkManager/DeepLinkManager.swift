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
    func processNotification(with link: PushLink)
    func processDeepLink(with params: [String: Any])
    func configureWith(launchOptions: [UIApplication.LaunchOptionsKey: Any]?)
    func handledURLWith(app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool
}

class DeepLinkManager {
    private var service: DeepLinkService?
    
    // Init manager
    public init(config: ConfigProtocol) {
        self.service = self.serviceFor(config: config)
    }
    
    private func serviceFor(config: ConfigProtocol) -> DeepLinkService? {
        if config.branch.enabled {
            return BranchService()
        }
        return nil
    }
    
    // check if service is added (means enabled)
    var serviceEnabled: Bool {
        service != nil
    }
    
    // Configure services
    func configureDeepLinkService(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        if let service = service {
            service.configureWith(launchOptions: launchOptions)
        }
    }
    
    // Handle open url
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        if let service = service {
            return service.handledURLWith(app: app, open: url, options: options)
        }
        return false
    }
    
    // This method process push notification with the link object
    func processNotification(with link: PushLink) {
        if let service = service {
            service.processNotification(with: link)
        }
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [String: Any]) {
        if let service = service {
            service.processDeepLink(with: params)
        }
    }
    
}
