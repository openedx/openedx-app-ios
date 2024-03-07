//
//  Sequence+Extensions.swift
//  Core
//
//  Created by Eugene Yatsenko on 28.02.2024.
//

import Foundation

public extension Sequence {
    func firstAs<T>(_ type: T.Type = T.self) -> T? {
        first { $0 is T } as? T
    }
}
