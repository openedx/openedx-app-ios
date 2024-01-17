//
//  WebviewMessage.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import WebKit
public struct WebviewMessage: Equatable {
    var name: String
    var handler: (Any, WKWebView?) -> Void

    public static func == (lhs: WebviewMessage, rhs: WebviewMessage) -> Bool {
        lhs.name == rhs.name
    }
}
