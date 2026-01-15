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
    
    var body: some View {
        VStack(spacing: 0) {
            WebUnitView(
                url: url,
                dataUrl: localUrl,
                viewModel: Container.shared.resolve(WebUnitViewModel.self)!,
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
