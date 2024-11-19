//

import Combine
import SwiftUI

@MainActor
public extension Publishers {
    static var keyboardStatePublisher: AnyPublisher<KeyboardState, Never> {
        let notificationCenter: NotificationCenter = .default

        let keyboardWillHide: NotificationCenter.Publisher =
            notificationCenter.publisher(for: UIResponder.keyboardWillHideNotification)

        let keyboardWillChangeFrame: NotificationCenter.Publisher =
            notificationCenter.publisher(for: UIResponder.keyboardWillChangeFrameNotification)

        let keyboardWillShow: NotificationCenter.Publisher =
            notificationCenter.publisher(for: UIResponder.keyboardWillShowNotification)

        return Publishers.MergeMany(
            keyboardWillHide,
            keyboardWillChangeFrame,
            keyboardWillShow
        )
        .map { notification -> KeyboardState? in
            KeyboardState.from(notification: notification)
        }
        .replaceNil(with: .default)
        .removeDuplicates(by: { lhs, rhs -> Bool in
            lhs.height == rhs.height
        })
        .eraseToAnyPublisher()
    }
}
