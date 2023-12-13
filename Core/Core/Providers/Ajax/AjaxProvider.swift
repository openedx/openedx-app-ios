//
//  AjaxProvider.swift
//  Core
//
//  Created by Eugene Yatsenko on 12.12.2023.
//

import Foundation
import WebKit
import Swinject

public extension NSNotification {
    static let blockCompletion = Notification.Name.init("block_completion")
}

final class AjaxProvider {

    let AJAXCallBackHandler = "ajaxCallbackHandler"
    let ajaxScriptFile = "ajaxHandler"

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

    enum XBlockCompletionCallbackType: String {
       case html = "publish_completion"
       case problem = "problem_check"
       case dragAndDrop = "do_attempt"
       case ora = "render_grade"
   }

    func addAjaxCallbackScript(
        in contentController: WKUserContentController,
        scriptMessageHandler: WKScriptMessageHandler
    ) {
        guard let url = Bundle(for: CoreBundle.self).url(forResource: ajaxScriptFile, withExtension: "js"),
              let handler = try? String(contentsOf: url, encoding: .utf8) else { return }
        let script = WKUserScript(source: handler, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        contentController.add(scriptMessageHandler, name: AJAXCallBackHandler)
        contentController.addUserScript(script)
    }

    @discardableResult
    func isCompletionCallback(with data: [AnyHashable: Any]) -> Bool {
        let callback = AJAXCallbackData(data: data)
        let requestURL = callback.url

        if callback.statusCode != 200 {
            return false
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
        return complete
    }

    private func isBlockOf(type: XBlockCompletionCallbackType, with requestURL: String) -> Bool {
        return requestURL.contains(type.rawValue)
    }

}
