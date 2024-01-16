//
//  CSSInjectionProtocol.swift
//  Core
//
//  Created by Vadim Kuznetsov on 4.01.24.
//

import Foundation

public protocol CSSInjectionProtocol {
    func cssScript(with css: String) -> String
}

extension CSSInjectionProtocol {
    public func cssScript(with css: String) -> String {
        """
        window.addEventListener("load", () => {
            var css = `\(css)`,
                head = document.head || document.getElementsByTagName('head')[0],
                style = document.createElement('style');
            head.appendChild(style);
            style.type = 'text/css';
            if (style.styleSheet) {
                style.styleSheet.cssText = css;
            } else {
                style.appendChild(document.createTextNode(css));
            }
        })
        """
    }
}
