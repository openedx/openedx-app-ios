//
//  LMSDirectoryLandingView.swift
//  Authorization
//
//  Created by Ivan Stepanok on 20.08.2026.
//

import SwiftUI
import Theme

/// The first screen of a multi-tenant build: which platform is this?
struct LMSDirectoryLandingView: View {
    @StateObject private var viewModel: LMSDirectoryViewModel

    init(viewModel: LMSDirectoryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            LMSDirectoryView(viewModel: viewModel)
                .padding(24)
        }
        .background(Theme.Colors.background.ignoresSafeArea())
        .navigationTitle(AuthLocalization.LmsDirectory.title)
    }
}
