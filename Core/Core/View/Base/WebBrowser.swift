//
//  WebBrowser.swift
//  Core
//
//  Created by  Stepanok Ivan on 06.10.2022.
//

import SwiftUI
import WebKit

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
        ZStack(alignment: .top) {
            Theme.Colors.background.ignoresSafeArea()
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: pageTitle,
                                     leftButtonAction: { presentationMode.wrappedValue.dismiss() })
                
                // MARK: - Page Body
                VStack {
                    ZStack(alignment: .top) {
//                        NavigationView {
                            WebView(
                                viewModel: .init(url: url, baseURL: ""),
                                isLoading: $isShowProgress,
                                refreshCookies: {}
                            )
                            
//                        }
                    }.navigationBarTitle(Text("")) // Needed for hide navBar on ios 14, 15
                        .navigationBarHidden(true)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

struct WebBrowser_Previews: PreviewProvider {
    static var previews: some View {
        WebBrowser(url: "", pageTitle: "")
    }
}
