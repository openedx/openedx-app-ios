//
//  AccessibilityInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 5.03.24.
//

import Foundation

import Combine
import WebKit

public struct AccessibilityInjection: WebViewScriptInjectionProtocol, CSSInjectionProtocol {
    public var id: String = "AccessibilityInjection"
    public var script: String {
        return """
            window.addEventListener("load", () => {
                window.webkit.messageHandlers.accessibility.postMessage("");
            });
            window.addEventListener("UIContentSizeCategory.didChangeNotification", () => {
                window.webkit.messageHandlers.accessibility.postMessage("");
            });
        """
    }
    public var messages: [WebviewMessage]? {
        let message = WebviewMessage(name: "accessibility") { _, webview in
            guard let webview = webview else { return }
            webview.evaluateJavaScript(getScript())
        }
        return [message]
    }
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    public var forMainFrameOnly: Bool = false
    
    private func css(for width: CGFloat) -> String {
        let unitSize = UIFontMetrics(forTextStyle: .body).scaledValue(for: ReadabilityHelper.unitSize)
        let padding = ReadabilityHelper.padding(containerWidth: width, unitWidth: unitSize)
        return """
            body {
                padding-left: \(padding)px !important;
                padding-right: \(padding)px !important;
            }
        """
    }
    
    private func getScript() -> String {
        let percent = UIFontMetrics(forTextStyle: .body).scaledValue(for: UIFont.systemFontSize) / UIFont.systemFontSize
        return """
            function resizeAccessibilityText() {
                document.documentElement.style.webkitTextSizeAdjust='\(percent * 100)%';
            }
            resizeAccessibilityText();
        """
    }
}
