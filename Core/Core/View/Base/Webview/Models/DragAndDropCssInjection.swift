//
//  DragAndDropCssInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import WebKit

public struct DragAndDropCssInjection: WebViewScriptInjectionProtocol, CSSInjectionProtocol {
    public var id: String = "DragAndDropCSSInjection"
    public var messages: [WebviewMessage]?
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    
    public var script: String {
        cssScript(with: css)
    }
    
    var css: String {
        """
        .xblock--drag-and-drop .drag-container {
            -webkit-user-select: none !important;
            -ms-user-select: none !important;
            user-select: none !important;
        }
        """
    }
    
    public init() {}
    
    public static func == (lhs: DragAndDropCssInjection, rhs: DragAndDropCssInjection) -> Bool {
        lhs.script == rhs.script
    }
}
