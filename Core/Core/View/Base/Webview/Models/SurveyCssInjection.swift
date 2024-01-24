//
//  SurveyCssInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import WebKit

public struct SurveyCssInjection: WebViewScriptInjectionProtocol, CSSInjectionProtocol {
    public var id: String = "SurveyCSSInjection"
    public var messages: [WebviewMessage]?
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    
    public var script: String {
        cssScript(with: css)
    }
    
    var css: String {
        """
        .survey-table:not(.poll-results) .survey-option .visible-mobile-only {
            width: calc(100% - 21px) !important;
        }

        .survey-percentage .percentage {
            width: 54px !important;
        }
        """
    }
    
    public init() {}
    
    public static func == (lhs: SurveyCssInjection, rhs: SurveyCssInjection) -> Bool {
        lhs.script == rhs.script
    }
}
