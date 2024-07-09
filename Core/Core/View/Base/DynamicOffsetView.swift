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
    @State private var collapseHeight: CGFloat = .zero
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>
    ) {
        self._coordinate = coordinate
        self._collapsed = collapsed
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
