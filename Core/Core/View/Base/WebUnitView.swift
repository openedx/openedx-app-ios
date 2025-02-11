//
//  WebUnitView.swift
//  Core
//
//  Created by  Stepanok Ivan on 14.10.2022.
//

import SwiftUI
@_spi(Advanced) import SwiftUIIntrospect
import Theme

public struct WebUnitView: View {
    
    @StateObject private var viewModel: WebUnitViewModel
    @State private var isWebViewLoading = false
    
    private var url: String
    private var injections: [WebviewInjection]?
    private let connectivity: ConnectivityProtocol
    private var blockID: String
    @State private var isFileOpen: Bool = false
    @State private var dataUrl: String?
    @State private var fileUrl: String = ""
    
    public init(
        url: String,
        dataUrl: String?,
        viewModel: WebUnitViewModel,
        connectivity: ConnectivityProtocol,
        injections: [WebviewInjection]?,
        blockID: String
    ) {
        self._viewModel = .init(
            wrappedValue: viewModel
        )
        self.url = url
        self.dataUrl = dataUrl
        self.connectivity = connectivity
        self.injections = injections
        self.blockID = blockID
        
        if !self.connectivity.isInternetAvaliable, let dataUrl {
            self.url = dataUrl
        }
    }
    
    @ViewBuilder
    public var body: some View {
        // MARK: - Error Alert
        if viewModel.showError {
            VStack(spacing: 28) {
                Image(systemName: "nosign")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64)
                    .foregroundColor(Theme.Colors.textPrimary)
                Text(viewModel.errorMessage ?? "")
                    .foregroundColor(Theme.Colors.textPrimary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                Button(action: {
                    Task {
                        await viewModel.updateCookies(force: true)
                    }
                }, label: {
                    Text(CoreLocalization.View.Snackbar.tryAgainBtn)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Theme.Shapes.buttonShape.fill(.clear))
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                            .foregroundColor(Theme.Colors.accentColor)
                        )
                })
                .frame(width: 100)
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
        } else {
            ZStack(alignment: .center) {
                GeometryReader { reader in
                    ScrollView {
                        if viewModel.cookiesReady || dataUrl != nil {
                            WebView(
                                viewModel: .init(
                                    url: url,
                                    baseURL: viewModel.config.baseURL.absoluteString,
                                    openFile: { file in
                                        self.fileUrl = file
                                    },
                                    injections: injections
                                ),
                                isLoading: $isWebViewLoading,
                                refreshCookies: {
                                    await viewModel.updateCookies(
                                        force: true
                                    )
                                },
                                connectivity: connectivity,
                                message: { message in
                                    Task {
                                        await viewModel.syncManager.handleMessage(message: message, blockID: blockID)
                                    }
                                }
                            )
                            .frame(
                                width: reader.size.width,
                                height: reader.size.height
                            )
                        }
                    }
                    .scrollDisabled(true)
                    .onChange(of: self.fileUrl, perform: { file in
                        if file != "" {
                            self.isFileOpen = true
                        }
                    })
                    .sheet(isPresented: $isFileOpen, onDismiss: { self.fileUrl = ""; isFileOpen = false }, content: {
                        GeometryReader { reader2 in
                            ZStack(alignment: .topTrailing) {
                                ScrollView {
                                    FileWebView(viewModel: FileWebView.ViewModel(url: fileUrl))
                                        .frame(width: reader2.size.width, height: reader2.size.height)
                                }
                                Button(action: {
                                    isFileOpen = false
                                }, label: {
                                    ZStack {
                                        Circle().frame(width: 32, height: 32)
                                            .foregroundColor(.white)
                                            .shadow(color: .black.opacity(0.2), radius: 12)
                                        Image(systemName: "xmark").renderingMode(.template)
                                            .foregroundColor(.black)
                                    }.padding(16)
                                })
                            }
                        }
                    })
                    if viewModel.updatingCookies || isWebViewLoading {
                        VStack {
                            ProgressBar(size: 40, lineWidth: 8)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
            }.onFirstAppear {
                Task {
                    if dataUrl == nil {
                        await viewModel.updateCookies()
                    }
                }
            }
        }
    }
}
