//
//  ResponsiveView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.03.2024.
//

import SwiftUI

public struct DynamicOffsetView: View {
    
    private let padHeight: CGFloat = 290
    private let collapsedHorizontalHeight: CGFloat = 120
    private let collapsedVerticalHeight: CGFloat = 100
    private var expandedHeight: CGFloat {
        let topInset = UIApplication.shared.windowInsets.top
        guard topInset > 0 else {
            return 240
        }
        return 300 - topInset
    }
    private let coordinateBoundaryLower: CGFloat = -115
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var viewHeight: CGFloat
    @State private var collapseHeight: CGFloat = .zero
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        shouldShowUpgradeButton: Binding<Bool>,
        shouldHideMenuBar: Binding<Bool>
    ) {
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
        self._shouldShowUpgradeButton = shouldShowUpgradeButton
        self._shouldHideMenuBar = shouldHideMenuBar
    }
    
    public var body: some View {
        VStack {
        }
        .frame(height: collapseHeight)
        .overlay(
            GeometryReader { geometry -> Color in
                guard idiom != .pad else {
                    return .clear
                }
                guard !isHorizontal else {
                    coordinate = coordinateBoundaryLower
                    return .clear
                }
                DispatchQueue.main.async {
                    coordinate = geometry.frame(in: .global).minY
                }
                return .clear
            }
        )
        .onAppear {
            changeCollapsedHeight()
        }
        .onChange(of: collapsed) { collapsed in
            if !collapsed {
                changeCollapsedHeight()
            }
        }
        .onChange(of: isHorizontal) { isHorizontal in
            if isHorizontal {
                collapsed = true
            }
            changeCollapsedHeight()
        }
    }
    
    private func collapsedHorizontalHeight(shouldHideMenuBar: Bool) -> CGFloat {
        120 - (shouldHideMenuBar ? 50 : 0)
    }
    
    private func expandedHeight(shouldShowUpgradeButton: Bool, shouldHideMenuBar: Bool) -> CGFloat {
        240 + (shouldShowUpgradeButton ? 63 : 0) - (shouldHideMenuBar ? 80 : 0)
    }

    private func changeCollapsedHeight(
        collapsed: Bool,
        isHorizontal: Bool,
        shouldShowUpgradeButton: Bool,
        shouldHideMenuBar: Bool
    ) {
        if idiom == .pad {
            collapseHeight = padHeight
        } else if collapsed {
            if isHorizontal {
                collapseHeight = collapsedHorizontalHeight(shouldHideMenuBar: shouldHideMenuBar)
            } else {
                collapseHeight = collapsedVerticalHeight
            }
        } else {
            collapseHeight = expandedHeight(
                shouldShowUpgradeButton: shouldShowUpgradeButton,
                shouldHideMenuBar: shouldHideMenuBar
            )
        }
        viewHeight = collapseHeight
    }
}
