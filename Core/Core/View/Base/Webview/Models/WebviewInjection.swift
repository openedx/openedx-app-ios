//
//  WebviewInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import WebKit
public struct WebviewInjection: WebViewScriptInjectionProtocol {
    public var id: String
    public var script: String
    public var messages: [WebviewMessage]?
    public var injectionTime: WKUserScriptInjectionTime
    public var forMainFrameOnly: Bool
    init(
        id: String,
        script: String,
        messages: [WebviewMessage]? = nil,
        injectionTime: WKUserScriptInjectionTime = .atDocumentEnd,
        forMainFrameOnly: Bool = true
    ) {
        self.id = id
        self.script = script
        self.messages = messages
        self.injectionTime = injectionTime
        self.forMainFrameOnly = forMainFrameOnly
    }
    
    public static func == (lhs: WebviewInjection, rhs: WebviewInjection) -> Bool {
        lhs.id == rhs.id &&
        lhs.script == rhs.script &&
        lhs.injectionTime == rhs.injectionTime &&
        lhs.messages == rhs.messages &&
        lhs.forMainFrameOnly == rhs.forMainFrameOnly
    }
}

public extension WebviewInjection {

    static var surveyCSS: WebviewInjection {
        SurveyCssInjection()
            .webviewInjection()
    }
    
    static var dragAndDropCss: WebviewInjection {
        DragAndDropCssInjection()
            .webviewInjection()
    }

    static var colorInversionCss: WebviewInjection {
        ColorInversionInjection()
            .webviewInjection()
    }

    static var ajaxCallback: WebviewInjection {
        AjaxInjection()
            .webviewInjection()
    }
    
    static var readability: WebviewInjection {
        ReadabilityInjection()
            .webviewInjection()
    }
    
    static var accessibility: WebviewInjection {
        AccessibilityInjection()
            .webviewInjection()
    }
}
