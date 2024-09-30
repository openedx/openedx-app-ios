//
//  FileWebView.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.07.2024.
//

import Foundation
import WebKit
import SwiftUI

public struct FileWebView: UIViewRepresentable {
    public func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        webview.scrollView.bounces = false
        webview.scrollView.alwaysBounceHorizontal = false
        webview.scrollView.showsHorizontalScrollIndicator = false
        webview.scrollView.isScrollEnabled = true
        webview.configuration.suppressesIncrementalRendering = true
        webview.isOpaque = false
        webview.configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        webview.configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        webview.backgroundColor = .clear
        webview.scrollView.backgroundColor = UIColor.white
        webview.scrollView.alwaysBounceVertical = false
        webview.scrollView.layer.cornerRadius = 24
        webview.scrollView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        if let url = URL(string: viewModel.url) {
            
            if let fileURL = URL(string: url.absoluteString) {
                let fileAccessURL = fileURL.deletingLastPathComponent()
                if let pdfData = try? Data(contentsOf: url) {
                    webview.load(
                        pdfData,
                        mimeType: "application/pdf",
                        characterEncodingName: "",
                        baseURL: fileAccessURL
                    )
                }
            }
        }
        
        return webview
    }
    
    public func updateUIView(_ webview: WKWebView, context: Context) {
        
    }
    
    public class ViewModel: ObservableObject {
        
        @Published var url: String
        
        public init(url: String) {
            self.url = url
        }
    }
    
    @ObservedObject var viewModel: ViewModel
    
    public init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
}
