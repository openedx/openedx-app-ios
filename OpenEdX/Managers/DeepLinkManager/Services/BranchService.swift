//
//  BranchService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 25/01/2024.
//

import Foundation
import UIKit
import Core
import BranchSDK

class BranchService: DeepLinkService {
    // configure service
    func configureWith(
        manager: DeepLinkManager,
        config: ConfigProtocol,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        guard config.branch.enabled && config.branch.key != nil else { return }
        
        Branch.getInstance().initSession(launchOptions: launchOptions) { params, error in
            guard let params = params, error == nil else { return }
            
            manager.processDeepLink(with: params)
        }
    }
    
    // handle url and call DeepLinkanager.processDeepLink() with params
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        return Branch.getInstance().application(app, open: url, options: options)
    }
}
