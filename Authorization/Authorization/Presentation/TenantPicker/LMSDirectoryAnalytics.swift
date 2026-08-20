//
//  LMSDirectoryAnalytics.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import Foundation

protocol LMSDirectoryAnalytics: Sendable {
    func selectionMade(id: String)
}

struct LMSDirectoryAnalyticsNoop: LMSDirectoryAnalytics {
    func selectionMade(id: String) {}
}
