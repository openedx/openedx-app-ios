//
//  AuthAlertView.swift
//  Authorization
//
//  Created by Eugene Yatsenko on 27.10.2023.
//

import SwiftUI
import Core

struct AuthAlertView: View {

    public init(
        showAlert: Bool,
        alertMessage: String?,
        onHide: @escaping () -> Void
    ) {
        self.showAlert = showAlert
        self.alertMessage = alertMessage
        self.onHide = onHide
    }

    public var showAlert: Bool
    public var alertMessage: String?
    public let onHide: () -> Void

    var body: some View {
        if showAlert {
            VStack {
                Text(alertMessage ?? "")
                    .shadowCardStyle(
                        bgColor: Theme.Colors.accentColor,
                        textColor: .white
                    )
                    .padding(.top, 80)
                Spacer()
            }
            .transition(.move(edge: .top))
            .onAppear {
                doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                    onHide()
                }
            }
        }
    }
}
