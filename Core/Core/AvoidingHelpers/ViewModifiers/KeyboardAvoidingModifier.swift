//

import Combine
import SwiftUI

public class KeyboardScrollInvocator: ObservableObject {
    var triggerSubject = PassthroughSubject<Bool, Never>()
    
    public func scrollToActiveInput() {
        triggerSubject.send(true)
    }
}

private struct KeyboardAvoidingModifier: ViewModifier {
    private let scrollerOptions: KeyboardScrollerOptions?
    private let partialAvoidingPadding: CGFloat
    private let dismissKeyboardByTap: Bool
    private let onProvideScrollInvocator: ((KeyboardScrollInvocator) -> Void)?
    
    @StateObject private var keyboardObserver = KeyboardStateObserver()
    @StateObject private var scrollInvocator = KeyboardScrollInvocator()
    
    init(
        scrollerOptions: KeyboardScrollerOptions?,
        partialAvoidingPadding: CGFloat,
        dismissKeyboardByTap: Bool,
        onProvideScrollInvocator: ((KeyboardScrollInvocator) -> Void)?
    ) {
        self.scrollerOptions = scrollerOptions
        self.partialAvoidingPadding = partialAvoidingPadding
        self.dismissKeyboardByTap = dismissKeyboardByTap
        self.onProvideScrollInvocator = onProvideScrollInvocator
    }
    
    func body(content: Content) -> some View {
        KeyboardAvoidingViewControllerRepr(partialAvoidingPadding: partialAvoidingPadding) {
            content
                .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        
        // for fields
        .onReceive(keyboardObserver.$keyboardState.receive(on: DispatchQueue.main)) { state in
            if state.height == 0 {
                DismissKeyboardTapHandler.shared.isEnabled = false
                return
            }
            
            // Applied to the whole UIWindow. Use addTapToEndEditing() modifier to apply locally.
            if dismissKeyboardByTap {
                DismissKeyboardTapHandler.shared.isEnabled = true
            }
            
            if let options = scrollerOptions {
                KeyboardScroller.scroll(
                    keyboardState: state,
                    options: options,
                    partialAvoidingPadding: partialAvoidingPadding
                )
            }
        }
        .onReceive(scrollInvocator.triggerSubject) { _ in
            guard !keyboardObserver.keyboardState.height.isZero,
                  let options = scrollerOptions else {
                return
            }
            
            KeyboardScroller.scroll(
                keyboardState: keyboardObserver.keyboardState,
                options: options,
                partialAvoidingPadding: partialAvoidingPadding
            )
        }
        .onAppear {
            onProvideScrollInvocator?(scrollInvocator)
        }
    }
}

public extension View {
    /**
     Avoid keyboard with non-scrollable content
     - parameter partialAvoidingPadding: Height of content below avoiding area for partial keyboard avoiding
     - parameter dismissKeyboardByTap: Apply dismissal tap to the whole window
     */
    func avoidKeyboard(
        partialAvoidingPadding: CGFloat = 0,
        dismissKeyboardByTap: Bool = false
    ) -> some View {
        modifier(KeyboardAvoidingModifier(
            scrollerOptions: nil,
            partialAvoidingPadding: partialAvoidingPadding,
            dismissKeyboardByTap: dismissKeyboardByTap,
            onProvideScrollInvocator: nil
        ))
    }
    
    /**
     Avoid keyboard with scrollable content
     - parameter scrollerOptions: Specify scroller parameters such as distance
     between responder's bottom and keyboard top.
     Create manually if you want to track scroll events
     - parameter partialAvoidingPadding: Height of content below avoiding area for partial keyboard avoiding
     - parameter dismissKeyboardByTap: Apply dismissal tap to the whole window
     - parameter scrollInvocator: Store it as weak value to trigger scroll when keyboard is present
     */
    func scrollAvoidKeyboard(
        scrollerOptions: KeyboardScrollerOptions = .init(),
        partialAvoidingPadding: CGFloat = 0,
        dismissKeyboardByTap: Bool = false,
        onProvideScrollInvocator: ((KeyboardScrollInvocator) -> Void)? = nil
    ) -> some View {
        modifier(KeyboardAvoidingModifier(
            scrollerOptions: scrollerOptions,
            partialAvoidingPadding: partialAvoidingPadding,
            dismissKeyboardByTap: dismissKeyboardByTap,
            onProvideScrollInvocator: onProvideScrollInvocator
        ))
    }
}
