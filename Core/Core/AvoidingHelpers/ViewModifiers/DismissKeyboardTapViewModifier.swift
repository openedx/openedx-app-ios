//

import SwiftUI

private struct DismissKeyboardTapViewModifier: ViewModifier {
    let isForced: Bool

    func body(content: Content) -> some View {
        content.simultaneousGesture(tapGesture)
    }

    private var tapGesture: some Gesture {
        TapGesture()
            .onEnded { _ in
                UIApplication.shared.endEditing(force: isForced)
            }
    }
}

public extension View {
    func addTapToEndEditing(isForced: Bool = true) -> some View {
        modifier(DismissKeyboardTapViewModifier(isForced: isForced))
    }
}
