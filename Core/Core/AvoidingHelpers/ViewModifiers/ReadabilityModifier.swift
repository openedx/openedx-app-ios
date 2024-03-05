//
//  ReadabilityModifier.swift
//  Core
//
//  Created by Vadim Kuznetsov on 28.02.24.
//
import SwiftUI

public struct ReadabilityHelper {
    static let unitSize: CGFloat = 20
    
    public static func padding(containerWidth: CGFloat, unitWidth: CGFloat) -> CGFloat {
        let idealWidth = 70 * unitWidth / 2

        guard containerWidth >= idealWidth else {
            return 0
        }

        let padding = round((containerWidth - idealWidth) / 2)
        return padding
    }
}

struct ReadabilityModifier: ViewModifier {
    @ScaledMetric(relativeTo: .body) private var unit: CGFloat = ReadabilityHelper.unitSize
    var width: CGFloat?

    func body(content: Content) -> some View {
        if let width = width {
            content
                .padding(.horizontal, padding(for: width))
        } else {
            GeometryReader { geometryProxy in
                content
                    .padding(.horizontal, padding(for: geometryProxy.size.width))
            }
        }
    }

    private func padding(for width: CGFloat) -> CGFloat {
        return ReadabilityHelper.padding(containerWidth: width, unitWidth: unit)
    }
}
