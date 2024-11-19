//
//  CourseUpdate.swift
//  Course
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import Foundation

public struct CourseUpdate: Hashable, Sendable {
    public let id: Int
    public let date: String
    public var content: String
    public let status: String?
    
    public init(id: Int, date: String, content: String, status: String?) {
        self.id = id
        self.date = date
        self.content = content
        self.status = status
    }
}
