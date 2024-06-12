//
//  PaymentSnackbarModifier.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import SwiftUI
import Theme

public struct PaymentSnackbarModifier: ViewModifier {
    @StateObject var viewModel: PaymentSnackbarModifierViewModel = .init()
    public func body(content: Content) -> some View {
            content
                .onAppear {
                    viewModel.isOnScreen = true
                }
                .onDisappear {
                    viewModel.isOnScreen = false
                }
                .overlay(alignment: .bottom) {
                    ZStack(alignment: .bottom) {
                        if viewModel.showPaymentSuccess {
                            PaymentSnakbarView()
                                .transition(.move(edge: .bottom))
                                .onAppear {
                                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                        viewModel.showPaymentSuccess = false
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    .animation(.easeInOut, value: viewModel.showPaymentSuccess)
                    .allowsHitTesting(false)
                    .accessibilityHidden(true)
            }
    }
}

extension View {
    public func paymentSnackbar() -> some View {
        modifier(PaymentSnackbarModifier())
    }
}
