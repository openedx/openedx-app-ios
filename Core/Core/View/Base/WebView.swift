//
//  WebView.swift
//  Core
//
//  Created by  Stepanok Ivan on 07.10.2022.
//

import Foundation
import WebKit
import SwiftUI

public struct WebView: UIViewRepresentable {
    
    public class ViewModel: ObservableObject {
        
        @Published var url: String
        let baseURL: String
        
        public init(url: String, baseURL: String) {
            self.url = url
            self.baseURL = baseURL
        }
    }
    
    @ObservedObject var viewModel: ViewModel
    @Binding public var isLoading: Bool
    var refreshCookies: () async -> Void
    
    public init(viewModel: ViewModel, isLoading: Binding<Bool>, refreshCookies: @escaping () async -> Void) {
        self.viewModel = viewModel
        self._isLoading = isLoading
        self.refreshCookies = refreshCookies
    }
    
    public class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(_ parent: WebView) {
            self.parent = parent
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }
        
        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
            
            guard let url = navigationAction.request.url else {
                return .cancel
            }
            
            let baseURL = await parent.viewModel.baseURL
            if !baseURL.isEmpty, !url.absoluteString.starts(with: baseURL) {
                await MainActor.run {
                    UIApplication.shared.open(url, options: [:])
                }
                return .cancel
            }
            
            return .allow
        }
        
        public func webView(_ webView: WKWebView,
                            decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
            guard let statusCode = (navigationResponse.response as? HTTPURLResponse)?.statusCode else {
                return .cancel
            }
            if (401...404).contains(statusCode) {
                await parent.refreshCookies()
                DispatchQueue.main.async {
                    if let url = webView.url {
                        let request = URLRequest(url: url)
                        webView.load(request)
                    }
                }
            }
            return .allow
        }
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webview = WKWebView()
        webview.navigationDelegate = context.coordinator
        
        webview.scrollView.bounces = false
        webview.scrollView.alwaysBounceHorizontal = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.isScrollEnabled = true
        webview.configuration.suppressesIncrementalRendering = true
        webview.isOpaque = false
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = UIColor.clear
        webview.scrollView.alwaysBounceVertical = false
        webview.scrollView.layer.cornerRadius = 24
        webview.scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        return webview
    }
    
    public func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {
        if let url = URL(string: viewModel.url) {
            let cookies = HTTPCookieStorage.shared.cookies ?? []
            for (cookie) in cookies {
                webview.configuration.websiteDataStore.httpCookieStore
                    .setCookie(cookie)
            }
            let request = URLRequest(url: url)
            if webview.url?.absoluteString != url.absoluteString {
                DispatchQueue.main.async {
                    isLoading = true
                }
                webview.load(request)
            }
        }
    }
}
