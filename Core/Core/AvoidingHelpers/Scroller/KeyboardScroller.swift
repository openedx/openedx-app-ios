//

import UIKit
import OEXFoundation

@MainActor
final class KeyboardScroller {
    static func scroll(
        keyboardState: KeyboardState,
        options: KeyboardScrollerOptions,
        partialAvoidingPadding: CGFloat
    ) {
        guard let activeResponder = UIResponder.currentFirstResponder as? UIView,
              let scrollView = activeResponder.enclosingScrollView() else {
            return
        }

        let scroller = KeyboardScroller(
            responder: activeResponder,
            scrollView: scrollView,
            options: options,
            state: keyboardState,
            partialAvoidingPadding: partialAvoidingPadding
        )

        scroller.updateScroll()
    }

    private var keyboardFrame: CGRect {
        state.frame
    }

    private let responder: UIView
    private let scrollView: UIScrollView
    private let options: KeyboardScrollerOptions
    private let globalWindow: UIWindow
    private let state: KeyboardState
    private let partialAvoidingPadding: CGFloat

    // MARK: Global Frames

    /// Intersection of keyboard frame and scrollView's global frame
    private var keyboardOverlay: CGRect = .zero
    private var scrollGlobalFrame: CGRect = .zero
    private var responderGlobalFrame: CGRect = .zero

    // MARK: Init

    private init(
        responder: UIView,
        scrollView: UIScrollView,
        options: KeyboardScrollerOptions,
        state: KeyboardState,
        partialAvoidingPadding: CGFloat
    ) {
        self.state = state
        self.responder = responder
        self.scrollView = scrollView
        self.options = options
        self.partialAvoidingPadding = partialAvoidingPadding

        globalWindow = UIApplication.shared.oexKeyWindow ?? UIWindow()
        calculateGlobalFrames()
    }

    // MARK: Avoiding

    func updateScroll() {
        scrollToActiveResponder()
    }

    private func scrollToActiveResponder() {
        guard keyboardFrame.height != 0 else {
            return
        }

        var desiredFrame = responder.convert(responder.bounds, to: scrollView)
        desiredFrame.size.height += options.spaceBetweenFieldAndKeyboard
        desiredFrame.origin.y -= partialAvoidingPadding

        var options = state.animationOptions
        options.update(with: .layoutSubviews)

        let completionBlock = self.options.onScrollEnd

        self.options.onScrollStart?()
        UIView.animate(
            withDuration: state.animationDuration,
            delay: 0,
            options: options,
            animations: { [weak self] in
                self?.scrollView.scrollRectToVisible(desiredFrame, animated: false)
            },
            completion: { _ in
                completionBlock?()
            }
        )
    }

    private func calculateGlobalFrames() {
        scrollGlobalFrame = globalWindow.convert(scrollView.frame, from: scrollView.superview)
        keyboardOverlay = scrollGlobalFrame.intersection(keyboardFrame)
        responderGlobalFrame = globalWindow.convert(responder.frame, from: responder.superview)
    }
}
