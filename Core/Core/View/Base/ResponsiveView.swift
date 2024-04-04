//
//  ResponsiveView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.03.2024.
//

import SwiftUI

public struct ResponsiveView: View {
    
    private let padHeight: CGFloat = 290
    private let collapsedHorizontalHeight: CGFloat = 120
    private let collapsedVerticalHeight: CGFloat = 90
    private let expandedHeight: CGFloat = 240
    private let coordinateBoundaryLower: CGFloat = -115
    private let coordinateBoundaryUpper: CGFloat = 40
    
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(coordinate: Binding<CGFloat>, collapsed: Binding<Bool>) {
        self._coordinate = coordinate
        self._collapsed = collapsed
    }
    
    public var body: some View {
        VStack {
        }.frame(
            height: idiom == .pad
            ? padHeight
            : (
                collapsed ? (
                    isHorizontal ? collapsedHorizontalHeight : collapsedVerticalHeight
                ) : expandedHeight
            )
        )
        .overlay(
            GeometryReader { geometry -> Color in
                guard idiom != .pad else {
                    return Color.clear
                }
                guard !isHorizontal else {
                    coordinate = coordinateBoundaryLower
                    return Color.clear
                }
                DispatchQueue.main.async {
                    let minY = geometry.frame(in: .global).minY
                    if minY >= coordinateBoundaryLower && minY <= coordinateBoundaryUpper {
                        coordinate = minY
                    } else if minY <= coordinateBoundaryLower {
                        coordinate = coordinateBoundaryLower
                    }
                }
                return Color.clear
            }
        )
    }
}
