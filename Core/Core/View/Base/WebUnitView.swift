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

    public init(
        url: String,
        viewModel: WebUnitViewModel,
        injections: [WebviewInjection]?
    ) {
        self._viewModel = .init(
            wrappedValue: viewModel
        )
        self.url = url
        self.injections = injections
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
                        if viewModel.cookiesReady {
                            WebView(
                                viewModel: .init(
                                    url: url,
                                    baseURL: viewModel.config.baseURL.absoluteString,
                                    injections: injections
                                ),
                                isLoading: $isWebViewLoading,
                                refreshCookies: {
                                    await viewModel.updateCookies(
                                        force: true
                                    )
                                },
                                isAddAjaxCallbackScript: true
                            )
                            .frame(
                                width: reader.size.width,
                                height: reader.size.height
                            )
                        }
                    }
                    .introspect(.scrollView, on: .iOS(.v15...), customize: { scrollView in
                        scrollView.isScrollEnabled = false
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
                    await viewModel.updateCookies()
                }
            }
        }
    }
}
