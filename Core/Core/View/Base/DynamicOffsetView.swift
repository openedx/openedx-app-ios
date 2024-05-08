//
//  ResponsiveView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.03.2024.
//

import SwiftUI

public struct DynamicOffsetView: View {
    
    private let padHeight: CGFloat = 290
    private var collapsedHorizontalHeight: CGFloat {
        120 + (isUpgradeable ? 42+20 : 0)
    }
    private var collapsedVerticalHeight: CGFloat {
        100 + (isUpgradeable ? 42+20 : 0)
    }
    private var expandedHeight: CGFloat {
        240 + (isUpgradeable ? 42+20 : 0)
    }
    private let coordinateBoundaryLower: CGFloat = -115
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private let isUpgradeable: Bool
    
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @State private var collapseHeight: CGFloat = .zero
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        isUpgradeable: Bool
    ) {
        self._coordinate = coordinate
        self._collapsed = collapsed
        self.isUpgradeable = isUpgradeable
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
    
    private func changeCollapsedHeight() {
        collapseHeight = idiom == .pad
        ? padHeight
        : (
            collapsed
            ? (isHorizontal ? collapsedHorizontalHeight : collapsedVerticalHeight)
            : expandedHeight
        )
    }
}
