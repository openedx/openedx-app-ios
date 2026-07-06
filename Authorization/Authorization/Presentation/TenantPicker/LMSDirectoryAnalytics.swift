import Foundation

protocol LMSDirectoryAnalytics: Sendable {
    func searchStarted(query: String)
    func searchResultsShown(count: Int)
    func selectionMade(id: String, fromHistory: Bool)
    func historyCleared()
}

struct LMSDirectoryAnalyticsNoop: LMSDirectoryAnalytics {
    func searchStarted(query: String) {}
    func searchResultsShown(count: Int) {}
    func selectionMade(id: String, fromHistory: Bool) {}
    func historyCleared() {}
}
