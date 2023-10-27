//
//  SnackBarErrorView.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI

public struct SnackBarErrorView: View {

    public init(
        showError: Bool,
        errorMessage: String?,
        onHide: @escaping () -> Void
    ) {
        self.showError = showError
        self.errorMessage = errorMessage
        self.onHide = onHide
    }

    public var showError: Bool
    public var errorMessage: String?
    public let onHide: () -> Void

    public var body: some View {
        if showError {
            VStack {
                Spacer()
                SnackBarView(message: errorMessage)
            }
            .transition(.move(edge: .bottom))
            .onTapGesture {
                onHide()
            }
            .onAppear {
                doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                    onHide()
                }
            }
        }
    }
}
