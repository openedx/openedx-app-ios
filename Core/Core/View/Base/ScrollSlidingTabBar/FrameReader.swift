//
//  FrameReader.swift
//  
//
//  Created by Eugene Yatsenko on 06/11/2023.
//

import SwiftUI

extension View {
    /// - Parameters:
    ///   - id: used to differentiate a view and its ancestor if they both call `readFrame`
    /// - Note: `onChange` maybe called with duplicated values
    public func readFrame(
        in space: CoordinateSpace,
        id: String = "shared",
        onChange: @escaping (CGRect) -> Void
    ) -> some View {
        background(
            GeometryReader { proxy in
                Color
                    .clear
                    .preference(
                        key: FramePreferenceKey.self,
                        value: [.init(space: space, id: id): proxy.frame(in: space)])
            }
        )
        .onPreferenceChange(FramePreferenceKey.self) {
            onChange($0[.init(space: space, id: id)] ?? .zero)
        }
    }
}

private struct FramePreferenceKey: PreferenceKey {
    nonisolated(unsafe) static var defaultValue: [PreferenceValueKey: CGRect] = [:]
    
    static func reduce(value: inout [PreferenceValueKey: CGRect], nextValue: () -> [PreferenceValueKey: CGRect]) {
        value.merge(nextValue()) { $1 }
    }
}

private struct PreferenceValueKey: Hashable {
    let space: CoordinateSpace
    let id: String
}
