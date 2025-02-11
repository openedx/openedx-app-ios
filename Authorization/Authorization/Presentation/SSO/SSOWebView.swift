//
//  SSOWebView.swift
//  Authorization
//
//  Created by Rawan Matar on 02/06/2024.
//
import SwiftUI
@preconcurrency import WebKit
import Core

public struct SSOWebView: UIViewRepresentable {

    let url: URL?
    
    var viewModel: SSOWebViewModel
    
    public init(url: URL?, viewModel: SSOWebViewModel) {
        self.url = url
        self.viewModel = viewModel
    }
    
    public func makeUIView(context: Context) -> WKWebView {
        let coordinator = makeCoordinator()
        let userContentController = WKUserContentController()
        userContentController.add(coordinator, name: "bridge")
        
        let prefs = WKWebpagePreferences()
        let config = WKWebViewConfiguration()
        prefs.allowsContentJavaScript = true
        
        config.userContentController = userContentController
        config.defaultWebpagePreferences = prefs
        config.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let wkWebView = WKWebView(frame: .zero, configuration: config)
        wkWebView.navigationDelegate = coordinator

        guard let currentURL = url else {
            return wkWebView
        }
        let request = URLRequest(url: currentURL)
        wkWebView.load(request)
        
        return wkWebView
    }
    
    public func updateUIView(_ uiView: WKWebView, context: Context) {
        
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: self.viewModel)
    }
    
    public class Coordinator: NSObject, WKScriptMessageHandler, WKNavigationDelegate {
        var viewModel: SSOWebViewModel
        
        init(viewModel: SSOWebViewModel) {
            self.viewModel = viewModel
            super.init()
        }
        
        // WKScriptMessageHandler
        public func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
        }
            
        // WKNavigationDelegate
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if webView.url?.absoluteString == nil {
                return
            }
        }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction,
            decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
        ) {
            guard let url = webView.url?.absoluteString else {
                decisionHandler(.allow)
                return
            }
                
            if url.contains(viewModel.config.ssoFinishedURL.absoluteString) {
                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                    Task {
                        await self.viewModel.SSOLogin(cookies: cookies)
                    }
                }
            }

            decisionHandler(.allow)
        }
    }
}
