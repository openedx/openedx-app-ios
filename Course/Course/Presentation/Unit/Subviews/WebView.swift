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
    
    init(
        url: String,
        localUrl: String?,
        injections: [WebviewInjection],
        blockID: String,
        roundedBackgroundEnabled: Bool = true,
        viewModel: WebUnitViewModel? = nil
    ) {
        self.url = url
        self.localUrl = localUrl
        self.injections = injections
        self.blockID = blockID
        self.roundedBackgroundEnabled = roundedBackgroundEnabled
        let resolvedViewModel = viewModel ?? Container.shared.resolve(WebUnitViewModel.self)!
        self._viewModel = State(initialValue: resolvedViewModel)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            WebUnitView(
                url: url,
                dataUrl: localUrl,
                viewModel: viewModel,
                connectivity: Connectivity(config: ConfigMock()),
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
