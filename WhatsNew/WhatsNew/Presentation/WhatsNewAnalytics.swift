//
//  WhatsNewAnalytics.swift
//  WhatsNew
//
//  Created by Saeed Bashir on 3/7/24.
//

import Foundation

//sourcery: AutoMockable
public protocol WhatsNewAnalytics {
    func whatsnewPopup()
    func whatsnewDone(totalScreens: Int)
    func whatsnewClose(totalScreens: Int, currentScreen: Int)
}

#if DEBUG
class WhatsNewAnalyticsMock: WhatsNewAnalytics {
    public func whatsnewPopup() {}
    public func whatsnewDone(totalScreens: Int) {}
    public func whatsnewClose(totalScreens: Int, currentScreen: Int) {}
}
#endif
