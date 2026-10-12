//
//  LayoutEnvironment.swift
//  Core
//

import SwiftUI

public extension EnvironmentValues {

    var isHorizontalLayout: Bool {
        verticalSizeClass == .compact
    }

    var layoutIdiom: UIUserInterfaceIdiom {
        horizontalSizeClass == .regular && verticalSizeClass == .regular ? .pad : .phone
    }
}

public extension View {
    func minimumTopSafeArea(_ minimum: CGFloat = 20) -> some View {
        modifier(MinimumTopSafeAreaModifier(minimum: minimum))
    }
}

private struct MinimumTopSafeAreaModifier: ViewModifier {
    let minimum: CGFloat
    @Environment(\.isHorizontalLayout) private var isHorizontalLayout
    @State private var topInset: CGFloat?

    func body(content: Content) -> some View {
        content
            .safeAreaPadding(.top, extraTopInset)
            .background {
                Color.clear
                    .onGeometryChange(for: CGFloat.self) { proxy in
                        proxy.safeAreaInsets.top
                    } action: { newValue in
                        topInset = newValue
                    }
            }
    }

    private var extraTopInset: CGFloat {
        guard !isHorizontalLayout, let topInset else { return 0 }
        return max(0, minimum - topInset)
    }
}
