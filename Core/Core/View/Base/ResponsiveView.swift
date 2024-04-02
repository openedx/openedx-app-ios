//
//  ResponsiveView.swift
//  Core
//
//  Created by  Stepanok Ivan on 26.03.2024.
//

import SwiftUI

public struct ResponsiveView: View {
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(coordinate: Binding<CGFloat>, collapsed: Binding<Bool>) {
        self._coordinate = coordinate
        self._collapsed = collapsed
    }
    
    public var body: some View {
        VStack {}.frame(height: idiom == .pad ? 290 : (collapsed ? (isHorizontal ? 120 : 90) : 240))
            .overlay(
                GeometryReader { geometry -> Color in
                    guard idiom != .pad  else {
                        return Color.clear
                    }
                    guard !isHorizontal else {
                        coordinate = -115
                        return Color.clear
                    }
                    DispatchQueue.main.async {
                        let minY = geometry.frame(in: .global).minY
                        if minY >= -115 && minY <= 40 {
                            coordinate = minY
                        } else if minY <= -115 {
                            coordinate = -115
                        }
                    }
                    return Color.clear
                }
            )
    }
}
