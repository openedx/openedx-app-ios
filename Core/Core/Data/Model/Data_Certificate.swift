//
//  Data_Certificate.swift
//  Core
//
//  Created by Vladimir Chekyrta on 18.12.2023.
//

import Foundation

public extension DataLayer {
    struct Certificate: Codable, Sendable {
        public let url: String?
        
        public init(url: String?) {
            self.url = url
        }
    }
}

public extension DataLayer.Certificate {
    var domain: Certificate {
        return Certificate(url: url ?? "")
    }
}
