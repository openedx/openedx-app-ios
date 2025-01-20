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
import OEXFoundation

public enum ProgramViewType: String, Equatable {
    case program
    case programDetail
}

public struct ProgramWebviewView: View {
    @State private var isLoading: Bool = true
    
    @StateObject private var viewModel: ProgramWebviewViewModel
    private var router: DiscoveryRouter
    private var viewType: ProgramViewType
    public var pathID: String
    
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
        self._viewModel = .init(wrappedValue: viewModel)
        self.router = router
        self.viewType = viewType
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
                            openFile: {_ in},
                            injections: [.colorInversionCss]
                        ),
                        isLoading: $isLoading,
                        refreshCookies: {
                            await viewModel.updateCookies(
                                force: true
                            )
                        },
                        navigationDelegate: viewModel,
                        connectivity: viewModel.connectivity,
                        webViewType: viewType.rawValue
                    )
                    .accessibilityIdentifier("program_webview")
                    
                    let shouldShowProgress = (
                        isLoading ||
                        viewModel.showProgress ||
                        viewModel.updatingCookies
                    )
                    if shouldShowProgress {
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
                }
                
                if viewModel.webViewError {
                    FullScreenErrorView(
                        type: viewModel.connectivity.isInternetAvaliable ? .generic : .noInternetWithReload
                    ) {
                        if viewModel.connectivity.isInternetAvaliable {
                            viewModel.webViewError = false
                            NotificationCenter.default.post(
                                name: Notification.Name(viewType.rawValue),
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
        .navigationBarHidden(viewType == .program)
        .navigationTitle(CoreLocalization.Mainscreen.programs)
        .background(Theme.Colors.background.ignoresSafeArea())
        .animation(.default, value: viewModel.showError)
    }
}

#if DEBUG
struct ProgramWebviewView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramWebviewView(
            viewModel: ProgramWebviewViewModel(
                router: DiscoveryRouterMock(),
                config: ConfigMock(),
                interactor: DiscoveryInteractor.mock,
                connectivity: Connectivity(),
                analytics: DiscoveryAnalyticsMock(),
                authInteractor: AuthInteractor.mock
            ),
            router: DiscoveryRouterMock(),
            viewType: .program,
            pathID: ""
        )
    }
}
#endif
