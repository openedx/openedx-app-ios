//
//  ErrorAlertView.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.05.2024.
//

import SwiftUI
import Theme

public struct ErrorAlertView: View {
    
    @Binding var errorMessage: String?
    
    public init(errorMessage: Binding<String?>) {
        self._errorMessage = errorMessage
    }
    
    public var body: some View {
        VStack {
            Spacer()
            SnackBarView(message: errorMessage)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Theme.Timeout.snackbarMessageLongTimeout) {
                        errorMessage = nil
                    }
                }
        }
    }
}

#Preview {
    ErrorAlertView(errorMessage: .constant("Error message"))
}
