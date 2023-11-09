//
//  CustomDisclosureGroup.swift
//  Core
//
//  Created by Eugene Yatsenko on 09.11.2023.
//

import SwiftUI

public struct CustomDisclosureGroup<Header: View, Content: View>: View {

    @Binding var isExpanded: Bool

    private var onClick: () -> Void
    private var animation: Animation?
    private let header: Header
    private let content: Content

    public init(
        animation: Animation?,
        isExpanded: Binding<Bool>,
        onClick: @escaping () -> Void,
        header: (_ isExpanded: Bool) -> Header,
        content: () -> Content
    ) {
        self.onClick = onClick
        self._isExpanded = isExpanded
        self.animation = animation
        self.header = header(isExpanded.wrappedValue)
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            header
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(animation) {
                        onClick()
                    }
                }
            if isExpanded {
                content
            }
        }
        .clipped()
    }
}
