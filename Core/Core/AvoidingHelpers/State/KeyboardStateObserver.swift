//

import SwiftUI

@MainActor
@Observable
final class KeyboardStateObserver {
    private(set) var keyboardState: KeyboardState = .default

    private var observers: [NSObjectProtocol] = []

    init() {
        let notificationCenter = NotificationCenter.default

        // Observe keyboard will show
        let showObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }

            if let state = KeyboardState.from(notification: notification) {
                self.updateState(state)
            }
        }

        // Observe keyboard will change frame
        let changeObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillChangeFrameNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            // Extract data from notification synchronously on main queue
            if let state = KeyboardState.from(notification: notification) {
                self.updateState(state)
            }
        }

        // Observe keyboard will hide
        let hideObserver = notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let self = self else { return }
            // Extract data from notification synchronously on main queue
            if let state = KeyboardState.from(notification: notification) {
                self.updateState(state)
            }
        }

        observers = [showObserver, changeObserver, hideObserver]
    }

    private func updateState(_ newState: KeyboardState) {
        // Remove duplicates (same as removeDuplicates in Combine)
        guard newState.height != keyboardState.height else { return }
        keyboardState = newState
    }

    @MainActor
    deinit {
        observers.forEach { NotificationCenter.default.removeObserver($0) }
    }
}
