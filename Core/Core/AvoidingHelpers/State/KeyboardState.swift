//

import SwiftUI
import UIKit

public struct KeyboardState: Sendable {
    public let animationDuration: TimeInterval

    /// Keyboard notification return a private curve value - 7.
    /// We are unable to create UIView.AnimationCurve from this value,
    /// but still need curve value to create UIView.AnimationOptions
    public let animationCurve: Int

    /// Zero when keyboard will be or is hidden
    public let frame: CGRect

    public var height: CGFloat {
        frame.height
    }

    public var animationOptions: UIView.AnimationOptions {
        UIView.AnimationOptions(rawValue: UInt(animationCurve << 16))
    }
}

// MARK: - Static

@MainActor
extension KeyboardState {
    static let `default` = KeyboardState(
        animationDuration: 0,
        animationCurve: 0,
        frame: .zero
    )

    static func from(notification: Notification) -> KeyboardState? {
        return from(
            notification: notification,
            screen: .main
        )
    }

    static func from(
        notification: Notification,
        screen: UIScreen
    ) -> KeyboardState? {
        guard
            expectedNotificationNames.contains(notification.name),
            let userInfo = notification.userInfo else {
            return nil
        }

        let animationDuration = Self.animationDuration(from: userInfo)
        let animationCurve = Self.animationCurve(from: userInfo)

        let frame = Self.keyboardFrame(from: userInfo, screen: screen)

        return KeyboardState(
            animationDuration: animationDuration,
            animationCurve: animationCurve,
            frame: frame
        )
    }

    private static var expectedNotificationNames: [Notification.Name] {
        [
            UIWindow.keyboardWillShowNotification,
            UIWindow.keyboardWillHideNotification,
            UIWindow.keyboardWillChangeFrameNotification
        ]
    }

    private static func animationDuration(from userInfo: [AnyHashable: Any]) -> Double {
        guard let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber else {
            // Apple default value
            return  0.25
        }

        return animationDuration.doubleValue
    }

    private static func animationCurve(from userInfo: [AnyHashable: Any]) -> Int {
        guard let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return 0
        }

        return curveValue
    }

    private static func keyboardFrame(
        from userInfo: [AnyHashable: Any],
        screen: UIScreen
    ) -> CGRect {
        guard let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return .zero
        }

        let screenBounds = screen.bounds
        let intersection = screenBounds.intersection(keyboardFrame)

        if intersection.isNull || intersection.height == 0 {
            return .zero
        }

        return intersection
    }
}
