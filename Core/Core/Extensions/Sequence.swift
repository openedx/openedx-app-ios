//
//  Sequence.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.11.2022.
//

import Foundation

public extension Sequence where Element: Hashable {
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
}
