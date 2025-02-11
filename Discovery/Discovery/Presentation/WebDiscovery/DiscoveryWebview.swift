//
//  DiscoveryWebview.swift
//  Discovery
//
//  Created by SaeedBashir on 12/16/23.
//

import Foundation
import SwiftUI
import Theme
import Core
import OEXFoundation

public enum DiscoveryWebviewType: Equatable {
    case discovery
    case courseDetail(String)
    case programDetail(String)

    var rawValue: String {
        switch self {
        case .discovery:
            return "discovery"
        case .courseDetail(let value):
            return "courseDetail(\(value))"
        case .programDetail(let value):
            return "programDetail(\(value))"
        }
    }
}

public struct DiscoveryWebview: View {
    @State private var searchQuery: String = ""
    @State private var isLoading: Bool = true
    
    @StateObject private var viewModel: DiscoveryWebviewViewModel
    private var router: DiscoveryRouter
    private var discoveryType: DiscoveryWebviewType
    public var pathID: String
    
    private var URLString: String {
        switch discoveryType {
        case .discovery:
            if !searchQuery.isEmpty {
                let baseURL = viewModel.config.discovery.webview.baseURL ?? ""
                return buildQuery(baseURL: baseURL, params: ["q": searchQuery])
            }
            
            return viewModel.config.discovery.webview.baseURL ?? ""
        case .courseDetail:
            let template = viewModel.config.discovery.webview.courseDetailTemplate
            return template?.replacingOccurrences(
                of: URIString.pathPlaceHolder.rawValue,
                with: pathID
            ) ?? ""
            
        case .programDetail:
            let template = viewModel.config.discovery.webview.programDetailTemplate
            return template?.replacingOccurrences(
                of: URIString.pathPlaceHolder.rawValue,
                with: pathID
            ) ?? ""
        }
    }
    
    private func buildQuery(baseURL: String, params: [String: String]) -> String {
        var query = baseURL
        for param in params {
            let join = query.contains("?") ? "&" : "?"
            let value = param.key + "=" + param.value
            if !query.contains(find: value) {
                query = query + join + value
            }
        }
        
        return query
    }
    
    public init(
        viewModel: DiscoveryWebviewViewModel,
        router: DiscoveryRouter,
        searchQuery: String? = nil,
        discoveryType: DiscoveryWebviewType = .discovery,
        pathID: String = ""
    ) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.router = router
        self._searchQuery = State<String>(initialValue: searchQuery ?? "")
        self.discoveryType = discoveryType
        self.pathID = pathID
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    WebView(
                        viewModel: .init(
                            url: URLString,
                            baseURL: "",
                            openFile: {_ in}
                        ),
                        isLoading: $isLoading,
                        refreshCookies: {},
                        navigationDelegate: viewModel,
                        connectivity: viewModel.connectivity,
                        webViewType: discoveryType.rawValue
                    )
                    .accessibilityIdentifier("discovery_webview")

                    if isLoading || viewModel.showProgress {
                        HStack(alignment: .center) {
                            ProgressBar(
                                size: 40,
                                lineWidth: 8
                            )
                            .padding(.vertical, proxy.size.height / 2)
                            .accessibilityIdentifier("progress_bar")
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

                    if !viewModel.userloggedIn, !isLoading {
                        LogistrationBottomView(
                            ssoEnabled: viewModel.config.uiComponents.samlSSOLoginEnabled
                        ) { buttonAction in
                            switch buttonAction {
                            case .signIn:
                                viewModel.router.showLoginScreen(sourceScreen: sourceScreen)
                            case .signInWithSSO:
                                viewModel.router.showLoginScreen(sourceScreen: sourceScreen)
                            case .register:
                                viewModel.router.showRegisterScreen(sourceScreen: sourceScreen)
                            }
                        }
                    }
                }

                if viewModel.webViewError {
                    FullScreenErrorView(
                        type: viewModel.connectivity.isInternetAvaliable ? .generic : .noInternetWithReload
                    ) {
                        if viewModel.connectivity.isInternetAvaliable {
                            viewModel.webViewError = false
                            NotificationCenter.default.post(
                                name: Notification.Name(discoveryType.rawValue),
                                object: nil
                            )
                        }
                    }
                }
            }
            .onFirstAppear {
                if let url = URL(string: URLString) {
                    viewModel.request = URLRequest(url: url)
                }
            }
        }
        .navigationBarHidden(viewModel.sourceScreen == .default && discoveryType == .discovery)
        .navigationTitle(CoreLocalization.Mainscreen.discovery)
        .background(Theme.Colors.background.ignoresSafeArea())
        .onFirstAppear {
            if case let .courseDetail(pathID, _) = viewModel.sourceScreen {
                viewModel.router.showWebDiscoveryDetails(
                    pathID: pathID,
                    discoveryType: .courseDetail(pathID),
                    sourceScreen: .discovery
                )
            } else if case let .programDetails(pathID) = viewModel.sourceScreen {
                viewModel.router.showWebDiscoveryDetails(
                    pathID: pathID,
                    discoveryType: .programDetail(pathID),
                    sourceScreen: .discovery
                )
            }
            
            // Reseting the source screen
            viewModel.sourceScreen = .discovery
        }
    }
    
    private var sourceScreen: LogistrationSourceScreen {
        switch discoveryType {
        case .discovery:
            return .discovery
        case .courseDetail(let pathID):
            return .courseDetail(pathID, "")
        case .programDetail(let pathID):
            return .programDetails(pathID)
        }
    }
}

fileprivate extension String {
    func contains(find: String) -> Bool {
        return range(of: find) != nil
    }
}
