//
//  BrazeListener.swift
//  OpenEdX
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

class BrazeListener: PushNotificationsListener {
    
    private let deepLinkManager: DeepLinkManager
    private let segmentService: SegmentAnalyticsService?
    
    init(deepLinkManager: DeepLinkManager, segmentService: SegmentAnalyticsService?) {
        self.segmentService = segmentService
        self.deepLinkManager = deepLinkManager
    }
    
    func shouldListenNotification(userinfo: [AnyHashable: Any]) -> Bool {
        //A push notification sent from the braze has a key ab in it like ab = {c = "c_value";};
        let data = userinfo["ab"] as? [String: Any]
        return userinfo.count > 0 && data != nil
    }
    
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any]) {
        guard let dictionary = userInfo as? [String: AnyHashable],
              shouldListenNotification(userinfo: userInfo) else { return }
        
        segmentService?.analytics?.receivedRemoteNotification(userInfo: userInfo)
        
        let link = PushLink(dictionary: dictionary)
        deepLinkManager.processLinkFromNotification(link)
    }
}
