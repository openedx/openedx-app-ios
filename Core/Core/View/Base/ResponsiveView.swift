//
//  ResponsiveView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.03.2024.
//

import SwiftUI

public struct ResponsiveView: View {
    
    private let padHeight: CGFloat = 290
    private let collapsedHorizontalHeight: CGFloat = 120
    private let collapsedVerticalHeight: CGFloat = 100
    private let expandedHeight: CGFloat = 240
    private let coordinateBoundaryLower: CGFloat = -115
    
    @State var lastHeight: CGFloat = 240
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @State private var isActiveView: Bool = false
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
            : (collapsed ? (isHorizontal ? collapsedHorizontalHeight : collapsedVerticalHeight) : expandedHeight)
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
                    coordinate = geometry.frame(in: .global).minY
                }
                return Color.clear
            }
        )
    }
}
