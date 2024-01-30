//
//  BranchService.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 25/01/2024.
//

import Foundation
import UIKit

class BranchService: DeepLinkService {
    // configure service
    func configureWith(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        
    }
    
    // handle url and call DeepLinkanager.processDeepLink() with params
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        false
    }
}
