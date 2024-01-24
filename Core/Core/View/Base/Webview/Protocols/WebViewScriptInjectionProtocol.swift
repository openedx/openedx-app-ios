//
//  WebViewScriptInjectionProtocol.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import WebKit
public protocol WebViewScriptInjectionProtocol: Equatable, Identifiable {
    var id: String { get }
    var script: String { get }
    var messages: [WebviewMessage]? { get }
    var injectionTime: WKUserScriptInjectionTime { get }
}

extension WebViewScriptInjectionProtocol {
    public func webviewInjection() -> WebviewInjection {
        WebviewInjection(
            id: self.id,
            script: self.script,
            messages: self.messages,
            injectionTime: self.injectionTime
        )
    }
}
