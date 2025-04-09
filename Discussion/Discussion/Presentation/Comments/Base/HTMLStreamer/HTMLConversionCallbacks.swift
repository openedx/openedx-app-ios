//
//  HTMLConversionCallbacks.swift
//  HTMLStreamer
//
//  Created by Shadowfacts on 12/22/23.
//

import Foundation

public protocol HTMLConversionCallbacks {
    static func makeURL(string: String) -> URL?
    static func elementAction(name: String, attributes: [Attribute]) -> ElementAction
}

public enum ElementAction: Equatable {
    case `default`
    case skip
    case replace(String)
    case append(String)
}

public extension HTMLConversionCallbacks {
    static func makeURL(string: String) -> URL? {
        URL(string: string)
    }
    static func elementAction(name: String, attributes: [Attribute]) -> ElementAction {
        .default
    }
}

public struct DefaultCallbacks: HTMLConversionCallbacks {
}
