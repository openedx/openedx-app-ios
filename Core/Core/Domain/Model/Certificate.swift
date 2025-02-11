//
//  Certificate.swift
//  Core
//
//  Created by Vladimir Chekyrta on 12.10.2022.
//

import Foundation

public struct Certificate: Codable, Hashable, Sendable {
    public let url: String?
    
    public init(url: String?) {
        self.url = url
    }
}
