//
//  WebBrowser.swift
//  Core
//
//  Created by  Stepanok Ivan on 06.10.2022.
//

import SwiftUI
import WebKit
import Theme

public struct WebBrowser: View {

    @State private var isLoading: Bool = true
    @Environment(\.presentationMode) var presentationMode

    private var url: String
    private var pageTitle: String
    private var showProgress: Bool
    
    public init(url: String, pageTitle: String, showProgress: Bool = false) {
        self.url = url
        self.pageTitle = pageTitle
        self.showProgress = showProgress
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                Theme.Colors.background.ignoresSafeArea()
                webView(proxy: proxy)
                if isLoading, showProgress {
                    HStack(alignment: .center) {
                        ProgressBar(
                            size: 40,
                            lineWidth: 8
                        )
                        .padding(20)
                        .accessibilityIdentifier("progress_bar")
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .navigationBarTitle(Text(""))
            .navigationBarHidden(true)
            .ignoresSafeArea()
        }
    }

    private func webView(proxy: GeometryProxy) -> some View {
        VStack(alignment: .center) {
            NavigationBar(
                title: pageTitle,
                leftButtonAction: { presentationMode.wrappedValue.dismiss() }
            )
            WebView(
                viewModel: .init(
                    url: url,
                    baseURL: "",
                    injections: [.colorInversionCss]
                ),
                isLoading: $isLoading,
                refreshCookies: {}
            )
            .accessibilityIdentifier("web_browser")
        }
        .padding(.top, proxy.safeAreaInsets.top)
        .padding(.bottom, proxy.safeAreaInsets.bottom)
    }
}

struct WebBrowser_Previews: PreviewProvider {
    static var previews: some View {
        WebBrowser(url: "", pageTitle: "")
    }
}
