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

    var url: String
    var pageTitle: String

    @State private var isShowProgress: Bool = true
    @Environment(\.presentationMode) var presentationMode
    
    public init(url: String, pageTitle: String) {
        self.url = url
        self.pageTitle = pageTitle
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                Theme.Colors.background.ignoresSafeArea()
                webView(proxy: proxy)
                if isShowProgress {
                    HStack(alignment: .center) {
                        ProgressBar(
                            size: 40,
                            lineWidth: 8
                        )
                        .padding(20)
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
                viewModel: .init(url: url, baseURL: ""),
                isLoading: $isShowProgress,
                refreshCookies: {}
            )
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
