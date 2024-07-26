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
    
    @State private var isOnTheScreen: Bool = false
    public init(
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>
    ) {
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
    }
    
    public var body: some View {
        VStack {
        }
        .frame(height: collapseHeight)
        .overlay(
            GeometryReader { geometry -> Color in
                if !isOnTheScreen {
                    return .clear
                }
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
            isOnTheScreen = true
            changeCollapsedHeight(collapsed: collapsed, isHorizontal: isHorizontal)
        }
        .onDisappear {
            isOnTheScreen = false
        }
        .onChange(of: collapsed) { collapsed in
            if !collapsed {
                changeCollapsedHeight(collapsed: collapsed, isHorizontal: isHorizontal)
            }
        }
        .onChange(of: isHorizontal) { isHorizontal in
            if isHorizontal {
                collapsed = true
            }
            changeCollapsedHeight(collapsed: collapsed, isHorizontal: isHorizontal)
        }
    }
    
    private func collapsedHorizontalHeight(shouldHideMenuBar: Bool) -> CGFloat {
        120 - (shouldHideMenuBar ? 50 : 0)
    }
    
    private func expandedHeight(shouldShowUpgradeButton: Bool, shouldHideMenuBar: Bool) -> CGFloat {
        expandedHeight + (shouldShowUpgradeButton ? 63 : 0) - (shouldHideMenuBar ? 80 : 0)
    }

    private func changeCollapsedHeight(
        collapsed: Bool,
        isHorizontal: Bool
    ) {
        if idiom == .pad {
            collapseHeight = padHeight + (shouldShowUpgradeButton ? 63 : 0) - (shouldHideMenuBar ? 80 : 0)
        } else if collapsed {
            if isHorizontal {
                collapseHeight = collapsedHorizontalHeight
            } else {
                collapseHeight = collapsedVerticalHeight
            }
        } else {
            collapseHeight = 240
        }
        viewHeight = collapseHeight
    }
}
