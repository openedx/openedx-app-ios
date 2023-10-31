//
//  SnackBarErrorView.swift
//  Core
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI

public struct SnackBarErrorView: View {

    @Environment(\.dismiss) var dismiss

    public init(
        errorMessage: String?,
        onDismiss: (() -> Void)? = nil
    ) {
        self.errorMessage = errorMessage
        self.onDismiss = onDismiss
    }

    public var errorMessage: String?
    public let onDismiss: (() -> Void)?

    public var body: some View {
        VStack {
            Spacer()
            SnackBarView(message: errorMessage)
        }
        .transition(.move(edge: .bottom))
        .onTapGesture {
            onDismiss?()
        }
        .onAppear {
            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                dismiss()
                onDismiss?()
            }
        }
    }
}
