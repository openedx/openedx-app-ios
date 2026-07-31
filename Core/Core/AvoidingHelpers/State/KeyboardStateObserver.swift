//

import SwiftUI

@MainActor
@Observable
final class KeyboardStateObserver {
    private(set) var keyboardState: KeyboardState = .default

    nonisolated(unsafe) private var observers: [NSObjectProtocol] = []

    init() {
        let notificationCenter = NotificationCenter.default

        // Observe keyboard will show
        let showObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            
            let notificationData = NotificationData(from: notification)
            
            Task { @MainActor in
                if let state = KeyboardState.from(notificationData: notificationData) {
                    self.updateState(state)
                }
            }
        }

        let changeObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            
            // Extract notification data in nonisolated context
            let notificationData = NotificationData(from: notification)
            
            Task { @MainActor in
                if let state = KeyboardState.from(notificationData: notificationData) {
                    self.updateState(state)
                }
            }
        }

        let hideObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            
            let notificationData = NotificationData(from: notification)
            
            Task { @MainActor in
                if let state = KeyboardState.from(notificationData: notificationData) {
                    self.updateState(state)
                }
            }
        }

        observers = [showObserver, changeObserver, hideObserver]
    }

    private func updateState(_ newState: KeyboardState) {
        // Remove duplicates (same as removeDuplicates in Combine)
        guard newState.height != keyboardState.height else { return }
        keyboardState = newState
    }

    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
