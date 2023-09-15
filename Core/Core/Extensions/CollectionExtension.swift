//
//  CollectionExtension.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.12.2022.
//

import Foundation

public extension Collection {
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
