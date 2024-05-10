//
//  Dictionary+JSON.swift
//  Core
//
//  Created by Vadim Kuznetsov on 13.03.24.
//

import Foundation

public extension Dictionary where Key == String, Value == String {
    func toJson() -> String? {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: self, options: []) else {
            return nil
        }

        return String(data: jsonData, encoding: .utf8)
    }
}
