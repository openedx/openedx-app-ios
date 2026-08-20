import Foundation

protocol LMSDirectoryAnalytics: Sendable {
    func selectionMade(id: String)
}

struct LMSDirectoryAnalyticsNoop: LMSDirectoryAnalytics {
    func selectionMade(id: String) {}
}
