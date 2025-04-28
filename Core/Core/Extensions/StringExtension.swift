//
//  StringExtension.swift
//  Core
//
//  Created by Ivan Stepanok on 24.04.2025.
//

import Foundation

public extension String {
    func isAppVersionGreater(than otherVersion: String) -> Bool {
        let v1 = self.split(separator: ".").compactMap { Int($0) }
        let v2 = otherVersion.split(separator: ".").compactMap { Int($0) }
        let maxCount = max(v1.count, v2.count)
        for i in 0..<maxCount {
            let part1 = i < v1.count ? v1[i] : 0
            let part2 = i < v2.count ? v2[i] : 0
            if part1 != part2 {
                return part1 > part2
            }
        }
        return false // equal or less
    }
}
