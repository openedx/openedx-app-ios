//
//  OfflineSyncManager.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation
import WebKit
import Combine
import Swinject
import OEXFoundation

public protocol OfflineSyncManagerProtocol {
    func handleMessage(message: WKScriptMessage, blockID: String)
    func syncOfflineProgress() async
}

public class OfflineSyncManager: OfflineSyncManagerProtocol {
    
    let persistence: CorePersistenceProtocol
    let interactor: OfflineSyncInteractorProtocol
    let connectivity: ConnectivityProtocol
    private var cancellables = Set<AnyCancellable>()
    
    public init(
        persistence: CorePersistenceProtocol,
        interactor: OfflineSyncInteractorProtocol,
        connectivity: ConnectivityProtocol
    ) {
        self.persistence = persistence
        self.interactor = interactor
        self.connectivity = connectivity
        
        self.connectivity.internetReachableSubject.sink(receiveValue: { state in
            switch state {
            case .reachable:
                Task(priority: .low) {
                    await self.syncOfflineProgress()
                }
            case .notReachable, nil:
                 break
            }
        }).store(in: &cancellables)
    }
    
    public func handleMessage(message: WKScriptMessage, blockID: String) {
        if message.name == "IOSBridge",
           let progressJson = message.body as? String {
            persistence.saveOfflineProgress(
                progress: OfflineProgress(
                    progressJson: progressJson
                )
            )
            var correctedProgressJson = progressJson
            correctedProgressJson = correctedProgressJson.removingPercentEncoding ?? correctedProgressJson
            message.webView?.evaluateJavaScript("markProblemCompleted('\(correctedProgressJson)')")
        } else if let offlineProgress = persistence.loadProgress(for: blockID) {
            var correctedProgressJson = offlineProgress.progressJson
            correctedProgressJson = correctedProgressJson.removingPercentEncoding ?? correctedProgressJson
            message.webView?.evaluateJavaScript("markProblemCompleted('\(correctedProgressJson)')")
        }
    }
    
    public func syncOfflineProgress() async {
        let offlineProgress = persistence.loadAllOfflineProgress()
        let cookies = HTTPCookieStorage.shared.cookies
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        for progress in offlineProgress {
            do {
                if try await interactor.submitOfflineProgress(
                    courseID: progress.courseID,
                    blockID: progress.blockID,
                    data: progress.data
                ) {
                    persistence.deleteProgress(for: progress.blockID)
                }
                if let config = Container.shared.resolve(ConfigProtocol.self), let cookies {
                    HTTPCookieStorage.shared.setCookies(cookies, for: config.baseURL, mainDocumentURL: nil)
                }
            } catch {
                debugLog("Error submitting offline progress: \(error.localizedDescription)")
            }
        }
    }
}
