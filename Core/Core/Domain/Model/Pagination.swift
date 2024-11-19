//
//  Pagination.swift
//  Core
//
//  Created by Vladimir Chekyrta on 25.05.2023.
//

import Foundation

public struct Pagination: Sendable {
    public let next: String?
    public let previous: String?
    public let count: Int
    public let numPages: Int
    
    public init(next: String?, previous: String?, count: Int, numPages: Int) {
        self.next = next
        self.previous = previous
        self.count = count
        self.numPages = numPages
    }
}
