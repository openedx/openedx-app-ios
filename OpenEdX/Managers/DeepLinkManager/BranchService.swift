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
    
    // handle url
    func handledURLWith(
        app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any]
    ) -> Bool {
        false
    }
    
    // This method process push notification with the link object
    func processNotification(with link: PushLink) {
        
    }
    
    // This method process the deep link with response parameters
    func processDeepLink(with params: [String: Any]) {
        
    }
}
