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
import OEXFoundation

@preconcurrency final class BranchService: DeepLinkService {
    // configure service
    func configureWith(
        manager: DeepLinkManagerProtocol,
        config: ConfigProtocol,
        launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) {
        guard let key = config.branch.key, config.branch.enabled else { return }
        Branch.setBranchKey(key)
        
        if Branch.branchKey() != nil {
            Branch.getInstance().initSession(launchOptions: launchOptions) { params, error in
                guard let params = params, error == nil else { return }
                
                manager.processDeepLink(with: params)
            }
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
