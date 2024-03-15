//
//  RawStringExtactable.swift
//  Core
//
//  Created by SaeedBashir on 12/18/23.
//

import Foundation

public protocol RawStringExtractable {
    var rawValue: String { get }
}

public protocol DictionaryExtractionExtension {
    associatedtype Key
    associatedtype Value
    subscript(key: Key) -> Value? { get }
}

extension Dictionary: DictionaryExtractionExtension {}

public extension DictionaryExtractionExtension where Self.Key == String {
    
    subscript(key: RawStringExtractable) -> Value? {
        return self[key.rawValue]
    }
}
