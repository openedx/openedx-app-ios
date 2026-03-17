//
//  WebView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Swinject
import Core
import Theme

struct WebView: View {
    let url: String
    let localUrl: String?
    let injections: [WebviewInjection]
    let blockID: String
    var roundedBackgroundEnabled: Bool = true
    @State private var viewModel: WebUnitViewModel
    private let connectivity: ConnectivityProtocol
    
    init(
        url: String,
        localUrl: String?,
        injections: [WebviewInjection],
        blockID: String,
        roundedBackgroundEnabled: Bool = true,
        viewModel: WebUnitViewModel? = nil,
        connectivity: ConnectivityProtocol? = nil
    ) {
        self.url = url
        self.localUrl = localUrl
        self.injections = injections
        self.blockID = blockID
        self.roundedBackgroundEnabled = roundedBackgroundEnabled
        
        guard let resolvedViewModel = viewModel ?? Container.shared.resolve(WebUnitViewModel.self) else {
            fatalError("WebUnitViewModel is not registered in the DI container")
        }
        self._viewModel = State(initialValue: resolvedViewModel)
        
        guard let resolvedConnectivity = connectivity ?? Container.shared.resolve(ConnectivityProtocol.self) else {
            fatalError("ConnectivityProtocol is not registered in the DI container")
        }
        self.connectivity = resolvedConnectivity
    }
    
    var body: some View {
        VStack(spacing: 0) {
            WebUnitView(
                url: url,
                dataUrl: localUrl,
                viewModel: viewModel,
                connectivity: connectivity,
                injections: injections,
                blockID: blockID
            )
            if roundedBackgroundEnabled {
                Spacer(minLength: 5)
            }
        }
        .if(roundedBackgroundEnabled) { view in
            view.roundedBackgroundWeb(
                strokeColor: Theme.Colors.textInputUnfocusedStroke,
                maxIpadWidth: .infinity
            )
        }
    }
}
