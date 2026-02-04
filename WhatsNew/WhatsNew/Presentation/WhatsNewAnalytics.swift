//
//  WhatsNewAnalytics.swift
//  WhatsNew
//
//  Created by Saeed Bashir on 3/7/24.
//

import Foundation

/// @mockable
public protocol WhatsNewAnalytics {
    func whatsnewPopup()
    func whatsnewDone(totalScreens: Int)
    func whatsnewClose(totalScreens: Int, currentScreen: Int)
}

#if DEBUG
class WhatsNewAnalyticsPreviewMock: WhatsNewAnalytics {
    func whatsnewPopup() {}
    func whatsnewDone(totalScreens: Int) {}
    func whatsnewClose(totalScreens: Int, currentScreen: Int) {}
}
#endif
