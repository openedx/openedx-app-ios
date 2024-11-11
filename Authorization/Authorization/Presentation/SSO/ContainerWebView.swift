//
//  ContainerWebView.swift
//  Authorization
//
//  Created by Rawan Matar on 02/06/2024.
//

import SwiftUI
import Core
import Swinject

public struct ContainerWebView: View {

    // MARK: - Internal Properties
    
    let url: String
    private var pageTitle: String
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: - Init
    
    public init(_ url: String, title: String) {
        self.url = url
        self.pageTitle = title
    }
    
    // MARK: - UI
    
    public var body: some View {
        VStack(alignment: .center) {
            NavigationBar(
                title: pageTitle,
                leftButtonAction: { presentationMode.wrappedValue.dismiss() }
            )
            
            ZStack {
                if !url.isEmpty {
                    SSOWebView(url: URL(string: url), viewModel: Container.shared.resolve(SSOWebViewModel.self)!)
                } else {
                    EmptyView()
                }
            }
            .accessibilityIdentifier("web_browser")
        }
    }
}
