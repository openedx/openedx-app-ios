//

import UIKit

/**
 Applies keyboard dismissal tap to the whole view
 */

@MainActor
final class DismissKeyboardTapHandler: NSObject {
    var isEnabled: Bool {
        didSet {
            guard oldValue != isEnabled else {
                return
            }

            if isEnabled {
                let recognizer = makeTapGestureRecognizer()
                UIApplication
                    .shared
                    .oexKeyWindow?
                    .addGestureRecognizer(recognizer)
                tapRecognizer = recognizer
                return
            }

            if let recognizer = tapRecognizer {
                UIApplication
                    .shared
                    .oexKeyWindow?
                    .removeGestureRecognizer(recognizer)
                tapRecognizer = nil
            }
        }
    }

    private var tapRecognizer: UITapGestureRecognizer?

    private init(isEnabled: Bool) {
        self.isEnabled = isEnabled
    }

    static let shared: DismissKeyboardTapHandler = {
        DismissKeyboardTapHandler(isEnabled: false)
    }()

    // MARK: Tap Gesture

    private func makeTapGestureRecognizer() -> UITapGestureRecognizer {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tapRecognizer.delegate = self
        tapRecognizer.cancelsTouchesInView = false
        return tapRecognizer
    }

    @objc
    private func handleTap(_: UITapGestureRecognizer) {
        UIApplication.shared.endEditing()
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DismissKeyboardTapHandler: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        guard isEnabled,
              let view = touch.view else {
            return false
        }

        // SwiftUI still uses

        if view.isKind(of: UITextView.self) == true
            || view.isKind(of: UITextField.self) == true {
            return false
        }

        return true
    }

    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith _: UIGestureRecognizer
    ) -> Bool {
        guard isEnabled else {
            return false
        }

        return gestureRecognizer === tapRecognizer
    }
}
