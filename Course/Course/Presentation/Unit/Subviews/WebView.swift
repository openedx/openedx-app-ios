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
    let viewModel: CourseUnitViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            WebUnitView(url: url, viewModel: Container.shared.resolve(WebUnitViewModel.self)!)
            Spacer(minLength: 5)
        }
        .roundedBackgroundWeb(strokeColor: Theme.Colors.textInputUnfocusedStroke, maxIpadWidth: .infinity)
    }
}
