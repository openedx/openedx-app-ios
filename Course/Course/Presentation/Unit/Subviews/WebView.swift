//
//  WebView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Swinject
import Core

struct WebView: View {
    let url: String
    let viewModel: CourseUnitViewModel
    
    var body: some View {
        VStack {
            WebUnitView(url: url, viewModel: Container.shared.resolve(WebUnitViewModel.self)!)
            Spacer(minLength: 100)
        }
        .contrast(1.08)
        .padding(.top, -6)
        .roundedBackground(strokeColor: .clear, maxIpadWidth: .infinity)
    }
}
