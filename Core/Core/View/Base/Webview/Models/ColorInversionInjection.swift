//
//  ColorInversionInjection.swift
//  Core
//
//  Created by Vadim Kuznetsov on 31.01.24.
//

import WebKit

public struct ColorInversionInjection: WebViewScriptInjectionProtocol, CSSInjectionProtocol {
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
                img {
                    /* Course figures are often PNGs with dark text on a transparent
                       background. Give them the white page they were drawn for; the
                       double inversion above keeps it white. */
                    background-color: #ffffff;
                }
            }
        """
        return cssScript(with: css)
    }
    public var messages: [WebviewMessage]?
    public var injectionTime: WKUserScriptInjectionTime = .atDocumentStart
    public var forMainFrameOnly: Bool = true
}
