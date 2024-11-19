//
//  ReadabilityInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 29.02.24.
//

import WebKit

public struct ReadabilityInjection: @preconcurrency WebViewScriptInjectionProtocol, CSSInjectionProtocol {
    public var id: String = "ReadabilityInjection"
    public var script: String {
        let uniqueId = UUID().uuidString.replacingOccurrences(of: "-", with: "")
        return """
            window.addEventListener("load", () => {
                window.webkit.messageHandlers.readability.postMessage("");
        
                window.resizeObserver\(uniqueId) = new ResizeObserver((entries) => {
                    window.webkit.messageHandlers.readability.postMessage("");
                });

                window.resizeObserver\(uniqueId).observe(document.body);

            });
            window.addEventListener("UIContentSizeCategory.didChangeNotification", () => {
                window.webkit.messageHandlers.readability.postMessage("");
            });
        """
    }
    
    @MainActor
    public var messages: [WebviewMessage]? {
        let message = WebviewMessage(name: "readability") { _, webview in
            guard let webview = webview else { return }
            let contentWidth = webview.frame.size.width
            let css = css(for: contentWidth)
            webview.evaluateJavaScript(script(for: css))
        }
        return [message]
    }
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    public var forMainFrameOnly: Bool = true
    
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
    
    private func script(for css: String) -> String {
        """
        function alterReadabilityCss() {
            const id = "readabilityCss";
            const style = document.getElementById(id);
            const css = `\(css)`;
            if (style != undefined) {
                style.innerHTML = "";
                if (style.styleSheet) {
                 style.styleSheet.cssText = css;
                } else {
                 style.appendChild(document.createTextNode(css));
                }
            } else {
                const head = document.head || document.getElementsByTagName('head')[0],
                    style = document.createElement('style');
                head.appendChild(style);
                style.type = 'text/css';
                style.id = id;
                if (style.styleSheet) {
                    style.styleSheet.cssText = css;
                } else {
                    style.appendChild(document.createTextNode(css));
                }
            }
        }
        alterReadabilityCss();
        """
    }
}
