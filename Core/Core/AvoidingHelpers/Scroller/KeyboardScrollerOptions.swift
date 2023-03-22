//

import UIKit

public struct KeyboardScrollerOptions {
    /// Space between keyboard's top and input responder's bottom
    public let spaceBetweenFieldAndKeyboard: CGFloat
    public let onScrollStart: (() -> Void)?
    public let onScrollEnd: (() -> Void)?

    public init(
        spaceBetweenFieldAndKeyboard: CGFloat = 20.0,
        onScrollStart: (() -> Void)? = nil,
        onScrollEnd: (() -> Void)? = nil
    ) {
        self.spaceBetweenFieldAndKeyboard = spaceBetweenFieldAndKeyboard
        self.onScrollStart = onScrollStart
        self.onScrollEnd = onScrollEnd
    }
}
