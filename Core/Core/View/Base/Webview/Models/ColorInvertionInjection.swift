//
//  ColorInvertionInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 31.01.24.
//

import WebKit

public struct ColorInvertionInjection: WebViewScriptInjectionProtocol, CSSInjectionProtocol {
    public var id: String = "ColorInvertionInjection"
    public var script: String {
        let css = """
            @media (prefers-color-scheme: dark) {
                html {
                    filter: invert(100%) hue-rotate(180deg);
                    background-color: transparent !important;
                }
                body {
                    background-color: transparent !important;
                }
                img, video, iframe {
                    filter: invert(100%) hue-rotate(180deg) !important;
                }
            }
        """
        return cssScript(with: css)
    }
    public var messages: [WebviewMessage]?
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    public var forMainFrameOnly: Bool = true
}
