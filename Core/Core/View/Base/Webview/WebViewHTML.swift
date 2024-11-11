//
//  WebViewHTML.swift
//  Core
//
//  Created by  Stepanok Ivan on 06.03.2023.
//

import Combine
import SwiftUI
import WebKit

public struct WebViewHtml: UIViewRepresentable {
    let htmlString: String
    let injections: [WebviewInjection]?
    
    public init(_ htmlString: String, injections: [WebviewInjection]? = nil) {
        self.htmlString = htmlString
        self.injections = injections
    }

    public func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.isScrollEnabled = true
        webView.configuration.suppressesIncrementalRendering = true
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = UIColor.clear
        webView.scrollView.alwaysBounceVertical = false
        // To add ability to change font size with webkitTextSizeAdjust need to set mode to mobile
        webView.configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        webView.applyInjections(injections, toHandler: context.coordinator)

        context.coordinator.webview = webView
        #if DEBUG
        webView.isInspectable = true
        #endif
        return webView
    }

    public func updateUIView(_ webView: WKWebView, context: Context) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

    public func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator(injections: injections)
        return coordinator
    }
    
    public static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.clear()
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKScriptMessageHandler {
        weak var webview: WKWebView?
        var injections: [WebviewInjection]?
        var cancellables: [AnyCancellable] = []
        
        init(injections: [WebviewInjection]? = nil) {
            self.injections = injections
            super.init()
            self.addObservers()
        }
        
        func addObservers() {
            cancellables.removeAll()
            NotificationCenter.default.publisher(for: UIContentSizeCategory.didChangeNotification, object: nil)
                .sink { [weak self] _ in
                    self?.webview?.evaluateSizeNotification()
                }
                .store(in: &cancellables)

        }
        
        public func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            injections?.handle(message: message)
        }
        
        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationAction: WKNavigationAction,
                            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if let url = navigationAction.request.url, navigationAction.navigationType == .linkActivated {
                UIApplication.shared.open(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        }
    }
}
