//
//  ProgramWebviewView.swift
//  Discovery
//
//  Created by SaeedBashir on 1/23/24.
//

import Foundation
import SwiftUI
import Theme
import Core

public enum ProgramViewType: Equatable {
    case program
    case programDetail
}

public struct ProgramWebviewView: View {
    @State private var isLoading: Bool = true
    
    @ObservedObject private var viewModel: ProgramWebviewViewModel
    private var router: DiscoveryRouter
    private var viewType: ProgramViewType
    private var pathID: String
    
    private var URLString: String {
        switch viewType {
        case .program:
            return viewModel.config.program.webview.baseURL ?? ""
        case .programDetail:
            let template = viewModel.config.program.webview.programDetailTemplate
            return template?.replacingOccurrences(
                of: URIString.pathPlaceHolder.rawValue,
                with: pathID
            ) ?? ""
        }
    }
    
    public init(
        viewModel: ProgramWebviewViewModel,
        router: DiscoveryRouter,
        viewType: ProgramViewType = .program,
        pathID: String = ""
    ) {
        self.viewModel = viewModel
        self.router = router
        self.viewType = viewType
        self.pathID = pathID
        
        if let url = URL(string: URLString) {
            viewModel.request = URLRequest(url: url)
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center) {
                WebView(
                    viewModel: .init(
                        url: URLString,
                        baseURL: "",
                        injections: [.colorInversionCss]
                    ),
                    isLoading: $isLoading,
                    refreshCookies: {
                        await viewModel.updateCookies(
                            force: true
                        )
                    },
                    navigationDelegate: viewModel
                )
                .accessibilityIdentifier("program_webview")
                
                if isLoading || viewModel.showProgress || viewModel.updatingCookies {
                    HStack(alignment: .center) {
                        ProgressBar(
                            size: 40,
                            lineWidth: 8
                        )
                        .padding(.vertical, proxy.size.height / 2)
                        .accessibilityIdentifier("progressbar")
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                }
                
                // MARK: - Show Error
                if viewModel.showError {
                    VStack {
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, 20)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(
                connectivity: viewModel.connectivity,
                reloadAction: {
                    NotificationCenter.default.post(
                        name: .webviewReloadNotification,
                        object: nil
                    )
                })
        }
        .navigationBarHidden(viewType == .program)
        .navigationTitle(CoreLocalization.Mainscreen.programs)
        .background(Theme.Colors.background.ignoresSafeArea())
        .animation(.default, value: viewModel.showError)
    }
}
