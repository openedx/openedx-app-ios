//
//  WebView.swift
//  Core
//
//  Created by  Stepanok Ivan on 07.10.2022.
//

import Combine
import Foundation
import SwiftUI
import Theme
import WebKit

public protocol WebViewNavigationDelegate: AnyObject {
    func webView(
        _ webView: WKWebView,
        shouldLoad request: URLRequest,
        navigationAction: WKNavigationAction
    ) async -> Bool
}

public struct WebView: UIViewRepresentable {
    
    public class ViewModel: ObservableObject {
        
        @Published var url: String
        let baseURL: String
        let injections: [WebviewInjection]?
        
        public init(url: String, baseURL: String, injections: [WebviewInjection]? = nil) {
            self.url = url
            self.baseURL = baseURL
            self.injections = injections
        }
    }
    
    @ObservedObject var viewModel: ViewModel
    @Binding public var isLoading: Bool
    var webViewNavDelegate: WebViewNavigationDelegate?
    
    var refreshCookies: () async -> Void

    public init(
        viewModel: ViewModel,
        isLoading: Binding<Bool>,
        refreshCookies: @escaping () async -> Void,
        navigationDelegate: WebViewNavigationDelegate? = nil
    ) {
        self.viewModel = viewModel
        self._isLoading = isLoading
        self.refreshCookies = refreshCookies
        self.webViewNavDelegate = navigationDelegate
    }

    public class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
        var cancellables: [AnyCancellable] = []
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
            super.init()

            addObservers()
        }

        public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webView.isHidden = true
        }
        
        public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webView.isHidden = false
        }
        
        public func webView(
            _ webView: WKWebView,
            didFailProvisionalNavigation navigation: WKNavigation!,
            withError error: Error
        ) {
            webView.isHidden = false
        }
        
        public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.isHidden = false
            DispatchQueue.main.async {
                self.parent.isLoading = false
            }
        }

        public func webView(
            _ webView: WKWebView,
            runJavaScriptConfirmPanelWithMessage message: String,
            initiatedByFrame frame: WKFrameInfo,
            completionHandler: @escaping (Bool) -> Void
        ) {

            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .actionSheet)

            alertController.addAction(UIAlertAction(
                title: CoreLocalization.Webview.Alert.ok,
                style: .default,
                handler: { _ in
                    completionHandler(true)
                }))

            alertController.addAction(UIAlertAction(
                title: CoreLocalization.Webview.Alert.cancel,
                style: .cancel,
                handler: { _ in
                    completionHandler(false)
                }))

            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationAction: WKNavigationAction
        ) async -> WKNavigationActionPolicy {
            
            guard let url = navigationAction.request.url else { return .cancel }
            
            let isWebViewDelegateHandled = await (
                parent.webViewNavDelegate?.webView(
                    webView,
                    shouldLoad: navigationAction.request,
                    navigationAction: navigationAction) ?? false
            )
            
            if isWebViewDelegateHandled {
                return .cancel
            }
            
            let baseURL = await parent.viewModel.baseURL
            if !baseURL.isEmpty, !url.absoluteString.starts(with: baseURL) {
                if navigationAction.navigationType == .other {
                    return .allow
                } else if navigationAction.navigationType == .linkActivated {
                    await MainActor.run {
                        UIApplication.shared.open(url, options: [:])
                    }
                } else if navigationAction.navigationType == .formSubmitted {
                    return .allow
                }
                return .cancel
            }
            
            return .allow
        }

        public func webView(
            _ webView: WKWebView,
            decidePolicyFor navigationResponse: WKNavigationResponse
        ) async -> WKNavigationResponsePolicy {
            guard let response = (navigationResponse.response as? HTTPURLResponse),
                  let url = response.url else {
                return .cancel
            }
            let baseURL = await parent.viewModel.baseURL

            if (401...404).contains(response.statusCode) || url.absoluteString.hasPrefix(baseURL + "/login") {
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
        
        private func addObservers() {
            cancellables.removeAll()
            NotificationCenter.default.publisher(for: .webviewReloadNotification, object: nil)
                .sink { [weak self] _ in
                    self?.reload()
                }
                .store(in: &cancellables)

            NotificationCenter.default.publisher(for: UIContentSizeCategory.didChangeNotification, object: nil)
                .sink { [weak self] _ in
                    let script = """
                    function sendSizeEvent() {
                        const contentSizeEvent = new CustomEvent("UIContentSizeCategory.didChangeNotification", { bubbles: true });
                        window.dispatchEvent(contentSizeEvent);
                    }
                    sendSizeEvent();
                    """
                    self?.webview?.evaluateJavaScript(script)
                }
                .store(in: &cancellables)
        }

        fileprivate var webview: WKWebView?
        
        @objc private func reload() {
            parent.isLoading = true
            webview?.reload()
        }

        public func userContentController(
            _ userContentController: WKUserContentController,
            didReceive message: WKScriptMessage
        ) {
            let messages = parent.viewModel.injections?.compactMap({$0.messages}).flatMap({$0}) ?? []
            if let currentMessage = messages.first(where: { $0.name == message.name }) {
                currentMessage.handler(message.body, message.webView)
            }
        }
    }

    private var userAgent: String {
        let info = Bundle.main.infoDictionary
        return [
            info?[kCFBundleExecutableKey as String],
            info?[kCFBundleIdentifierKey as String],
            info?["CFBundleShortVersionString"]
        ]
            .compactMap { $0 as? String ?? "" }
            .joined(separator: "/")
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    public func makeUIView(context: UIViewRepresentableContext<WebView>) -> WKWebView {
        let webViewConfig = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: .zero, configuration: webViewConfig)
        #if DEBUG
        if #available(iOS 16.4, *) {
            webView.isInspectable = true
        }
        #endif
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        
        context.coordinator.webview = webView
        
        webView.scrollView.bounces = false
        webView.scrollView.alwaysBounceHorizontal = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.isScrollEnabled = true
        webView.configuration.suppressesIncrementalRendering = true
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = Theme.Colors.background.uiColor()
        webView.scrollView.alwaysBounceVertical = false
        webView.scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)
        // To add ability to change font size with webkitTextSizeAdjust need to set mode to mobile
        webView.configuration.defaultWebpagePreferences.preferredContentMode = .mobile
        for injection in viewModel.injections ?? [] {
            let script = WKUserScript(
                source: injection.script,
                injectionTime: injection.injectionTime,
                forMainFrameOnly: injection.forMainFrameOnly
            )
            webView.configuration.userContentController.addUserScript(script)
            
            for message in injection.messages ?? [] {
                webView.configuration.userContentController.add(context.coordinator, name: message.name)
            }
        }
        
        webView.customUserAgent = userAgent
        
        return webView
    }

    public func updateUIView(_ webview: WKWebView, context: UIViewRepresentableContext<WebView>) {
        if let url = URL(string: viewModel.url) {
            if webview.url?.absoluteString != url.absoluteString {
                DispatchQueue.main.async {
                    isLoading = true
                }
                let request = URLRequest(url: url)
                webview.load(request)
            }
        }
    }

    public static func dismantleUIView(_ uiView: WKWebView, coordinator: Coordinator) {
        uiView.configuration.userContentController.removeAllUserScripts()
        uiView.configuration.userContentController.removeAllScriptMessageHandlers()
    }
}
