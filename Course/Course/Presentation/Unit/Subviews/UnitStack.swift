//
//  UnitStack.swift
//  Course
//
//  Created by Vadim Kuznetsov on 23.01.24.
//

import SwiftUI

public struct UnitAlignment: Equatable {
    var horizontalAlignment: VerticalAlignment
    var verticalAlignment: HorizontalAlignment
}

public struct UnitStack<Content>: View where Content: View {
    let alignment: UnitAlignment
    let spacing: CGFloat?
    let pinnedViews: PinnedScrollableViews
    let content: () -> Content
    var isVerticalNavigation: Bool
    
    public init(
        isVerticalNavigation: Bool,
        alignment: UnitAlignment,
        spacing: CGFloat? = nil,
        pinnedViews: PinnedScrollableViews = .init(),
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.isVerticalNavigation = isVerticalNavigation
        self.alignment = alignment
        self.spacing = spacing
        self.pinnedViews = pinnedViews
        self.content = content
    }

    public var body: some View {
        if isVerticalNavigation {
            LazyVStack(
                alignment: alignment.verticalAlignment,
                spacing: spacing,
                pinnedViews: pinnedViews,
                content: content
            )
        } else {
            LazyHStack(
                alignment: alignment.horizontalAlignment,
                spacing: spacing,
                pinnedViews: pinnedViews,
                content: content
            )
        }
    }
}
#if DEBUG
#Preview {
    VStack {
        let alignment = UnitAlignment(horizontalAlignment: .top, verticalAlignment: .leading)
        UnitStack(isVerticalNavigation: true, alignment: alignment) {
            Text("First element")
            Text("Second element")
        }
        Divider()
        UnitStack(isVerticalNavigation: false, alignment: alignment) {
            Text("First element")
            Text("Second element")
        }
    }
}
#endif
