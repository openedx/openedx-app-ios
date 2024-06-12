//
//  PaymentSnackbarModifierViewModel.swift
//  Core
//
//  Created by Vadim Kuznetsov on 11.06.24.
//

import Combine
import Foundation

class PaymentSnackbarModifierViewModel: ObservableObject {
    @Published var showPaymentSuccess: Bool = false
    var isOnScreen: Bool = false
    private var cancellations: [AnyCancellable] = []
    init() {
        NotificationCenter.default
            .publisher(for: .courseUpgradeCompletionNotification)
            .sink { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.isOnScreen {
                        self.showPaymentSuccess = true
                    }
                }
            }
            .store(in: &cancellations)
    }
}
