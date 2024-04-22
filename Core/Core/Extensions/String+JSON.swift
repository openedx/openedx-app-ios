//
//  String+JSON.swift
//  Core
//
//  Created by Vadim Kuznetsov on 13.03.24.
//

import Foundation

public extension String {
    public func jsonStringToDictionary() -> [String: Any]? {
        guard let jsonData = self.data(using: .utf8) else {
            return nil
        }
        
        guard let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []),
              let dictionary = jsonObject as? [String: Any] else {
            return nil
        }
        
        return dictionary
    }
}
