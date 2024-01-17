//
//  DropdownAnimationModifier.swift
//  Course
//
//  Created by Vadim Kuznetsov on 5.12.23.
//

import SwiftUI

struct DropdownAnimationModifier<V>: ViewModifier where V: Equatable {
    var isActive: Bool
    var value: V
    func body(content: Content) -> some View {
        if isActive {
            content
                .animation(.easeOut(duration: 0.2), value: value)
        } else {
            content
        }
    }
}

struct DropdownArrowRotationModifier: ViewModifier {
    var value: Bool
    func body(content: Content) -> some View {
        content
            .rotationEffect(value ? .degrees(90) : .degrees(0))
            .animation(.easeOut(duration: 0.2), value: value)
    }
}

extension View {
    func dropdownAnimation<V>(isActive: Bool, value: V) -> some View where V: Equatable {
        modifier(DropdownAnimationModifier(isActive: isActive, value: value))
    }

    func dropdownArrowRotationAnimation(value: Bool) -> some View {
        modifier(DropdownArrowRotationModifier(value: value))
    }
}
