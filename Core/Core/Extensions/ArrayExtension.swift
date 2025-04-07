//
//  ArrayExtension.swift
//  Core
//
//  Created by Ivan Stepanok on 05.03.2025.
//

import Foundation
import WebKit

public extension Array where Element: Hashable {
    func unique() -> [Element] {
        return Array(Set(self))
    }
}

public extension Array where Element == DownloadDataTask {
    func filter(userId: Int?) -> [DownloadDataTask] {
        filter {
            guard let userId else {
                return true
            }
            return $0.userId == userId
        }
    }
}

public extension Array where Element == CDDownloadData {
    func downloadDataTasks() -> [DownloadDataTask] {
        compactMap { DownloadDataTask(sourse: $0) }
    }
}

public extension Array {
    mutating func modifyForEach(_ body: (_ element: inout Element) -> Void) {
        for index in indices {
            modifyElement(atIndex: index) { body(&$0) }
        }
    }

    mutating func modifyElement(atIndex index: Index, _ modifyElement: (_ element: inout Element) -> Void) {
        var element = self[index]
        modifyElement(&element)
        self[index] = element
    }
}

public extension Array where Element == WebviewInjection {
    
    @MainActor
    func handle(message: WKScriptMessage) {
        let messages = compactMap { $0.messages }
            .flatMap { $0 }
        if let currentMessage = messages.first(where: { $0.name == message.name }) {
            currentMessage.handler(message.body, message.webView)
        }
    }
}
