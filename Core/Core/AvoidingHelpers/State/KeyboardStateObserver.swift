//

import Combine

@MainActor
final class KeyboardStateObserver: ObservableObject {
    @Published private(set) var keyboardState: KeyboardState = .default

    private var subscription: AnyCancellable?

    init() {
        subscription = Publishers.keyboardStatePublisher
            .sink(receiveValue: { [weak self] state in
                self?.keyboardState = state
            })
    }
}
