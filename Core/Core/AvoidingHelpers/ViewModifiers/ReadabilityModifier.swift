//
//  ReadabilityModifier.swift
//  Core
//
//  Created by Vadim Kuznetsov on 28.02.24.
//
import SwiftUI

struct ReadabilityModifier: ViewModifier {
    @ScaledMetric private var unit: CGFloat = 20

    func body(content: Content) -> some View {
        GeometryReader { geometryProxy in
            content
                .padding(.horizontal, padding(for: geometryProxy.size.width))
        }
    }

    private func padding(for width: CGFloat) -> CGFloat {
        let idealWidth = 70 * unit / 2

        guard width >= idealWidth else {
            return 0
        }

        let padding = round((width - idealWidth) / 2)
        return padding
    }
}
