//

import Combine
import SwiftUI
import UIKit

/// A view controller that embeds a SwiftUI view, adjusting it's layout for
/// the on-screen keyboard.

final class KeyboardAvoidingViewController<Content: View>: UIViewController {
    private let rootView: Content

    private var hostingController: UIHostingController<Content>
    private var bottomConstraint: NSLayoutConstraint?
    private var keyboardStateCancellable: AnyCancellable?
    private var keyboardState: KeyboardState = .default

    var bottomPadding: CGFloat = 0 {
        didSet {
            guard bottomPadding != oldValue else {
                return
            }

            updateBottomConstraint(state: keyboardState)
        }
    }

    /**
     - parameter partialAvoidingPadding: content height below avoiding area for partial keyboard avoiding
     */
    init(partialAvoidingPadding: CGFloat, rootView: Content) {
        self.rootView = rootView
        bottomPadding = partialAvoidingPadding
        hostingController = UIHostingController(rootView: rootView)
        hostingController.view.backgroundColor = .clear

        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    @objc dynamic required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        bootstrapViewController()
    }

    private func bootstrapViewController() {
        view.backgroundColor = .clear
        setupLayout()
        subscribeToKeyboardPublisher()
    }

    private func setupLayout() {
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)

        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        let bottomConstraint = view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor)
        let leadingConstraint = view.leadingAnchor.constraint(equalTo: hostingController.view.leadingAnchor)
        let trailingConstraint = view.trailingAnchor.constraint(equalTo: hostingController.view.trailingAnchor)
        let topConstraint = view.topAnchor.constraint(equalTo: hostingController.view.topAnchor)

        NSLayoutConstraint.activate([
            leadingConstraint,
            trailingConstraint,
            topConstraint,
            bottomConstraint
        ])

        self.bottomConstraint = bottomConstraint
    }

    private func subscribeToKeyboardPublisher() {
        keyboardStateCancellable = Publishers.keyboardStatePublisher
            .sink { [weak self] state in
                self?.updateBottomConstraint(state: state)
            }
    }

    private func updateBottomConstraint(state: KeyboardState) {
        guard presentedViewController == nil else {
            return
        }

        keyboardState = state

        var options = state.animationOptions
        options.update(with: .layoutSubviews)

        var contentAbsoluteFrame = view.convert(view.frame, to: nil)
        contentAbsoluteFrame = contentAbsoluteFrame.insetBy(dx: 0, dy: -bottomPadding)

        let intersection = contentAbsoluteFrame.intersection(state.frame)
        let offset = state.frame.height == 0 ? 0 : intersection.height
        let keyboardHeight = max(0, offset)

        bottomConstraint?.constant = keyboardHeight

        UIView.animate(
            withDuration: state.animationDuration,
            delay: 0.0,
            options: options,
            animations: { [weak self] in
                self?.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
}
