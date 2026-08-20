//
//  LMSDirectoryLandingView.swift
//  Authorization
//
//  The first screen of a multi-tenant build: which platform is this?
//

import SwiftUI
import Theme

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
