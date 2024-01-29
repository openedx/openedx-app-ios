//
//  AjaxProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 12.12.2023.
//

import Foundation
import WebKit
import Swinject

struct AjaxInjection: WebViewScriptInjectionProtocol {
    private struct AJAXCallbackData {
        private enum Keys: String {
            case url = "url"
            case statusCode = "status"
            case responseText = "response_text"
        }

        let url: String
        let statusCode: Int
        let responseText: String

        init(data: [AnyHashable: Any]) {
            url = data[Keys.url.rawValue] as? String ?? ""
            statusCode = data[Keys.statusCode.rawValue] as? Int ?? 0
            responseText = data[Keys.responseText.rawValue] as? String ?? ""
        }
    }

    private enum XBlockCompletionCallbackType: String {
        case html = "publish_completion"
        case problem = "problem_check"
        case dragAndDrop = "do_attempt"
        case ora = "render_grade"
    }

    private let AJAXCallBackHandler = "ajaxCallbackHandler"
    private let ajaxScriptFile = "ajaxHandler"

    var id: String = "AjaxInjection"
    var script: String {
        guard let url = Bundle(for: CoreBundle.self).url(forResource: ajaxScriptFile, withExtension: "js"),
              let script = try? String(contentsOf: url, encoding: .utf8) else { return "" }
        return script
    }

    var messages: [WebviewMessage]? {
        [
            WebviewMessage(name: AJAXCallBackHandler) { result, _ in
                guard let data = result as? [AnyHashable: Any] else { return }
                let callback = AJAXCallbackData(data: data)
                let requestURL = callback.url

                if callback.statusCode != 200 {
                    return
                }

                var complete = false
                if isBlockOf(type: .ora, with: requestURL) {
                    complete = callback.responseText.contains("is--complete")
                } else {
                    complete = isBlockOf(type: .html, with: requestURL)
                        || isBlockOf(type: .problem, with: requestURL)
                        || isBlockOf(type: .dragAndDrop, with: requestURL)
                }
                if complete {
                    NotificationCenter.default.post(
                        name: NSNotification.blockCompletion,
                        object: nil
                    )
                }
            }
         ]
    }
    
    var injectionTime: WKUserScriptInjectionTime = .atDocumentEnd
    
    private func isBlockOf(type: XBlockCompletionCallbackType, with requestURL: String) -> Bool {
        return requestURL.contains(type.rawValue)
    }
}

public extension NSNotification {
    static let blockCompletion = Notification.Name.init("block_completion")
}
