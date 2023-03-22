//

import SwiftUI

struct KeyboardAvoidingViewControllerRepr<Content: View>: UIViewControllerRepresentable {
    private let partialAvoidingPadding: CGFloat
    private let content: () -> Content

    /**
     - parameter partialAvoidingPadding: content height below avoiding area for partial keyboard avoiding
     */
    init(partialAvoidingPadding: CGFloat, @ViewBuilder _ content: @escaping () -> Content) {
        self.partialAvoidingPadding = partialAvoidingPadding
        self.content = content
    }

    func makeUIViewController(context _: Context) -> KeyboardAvoidingViewController<Content> {
        let viewController = KeyboardAvoidingViewController(
            partialAvoidingPadding: partialAvoidingPadding,
            rootView: content()
        )

        viewController.view.layoutIfNeeded()

        return viewController
    }

    func updateUIViewController(_ viewController: KeyboardAvoidingViewController<Content>, context _: Context) {
        viewController.bottomPadding = partialAvoidingPadding
    }
}
