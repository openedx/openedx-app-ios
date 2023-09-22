//
//  Data_UpdatesResponse.swift
//  Course
//
//  Created by  Stepanok Ivan on 28.02.2023.
//

import Foundation
import Core

public extension DataLayer {
    struct CourseUpdate: Codable {
        public let id: Int
        public let date: String
        public let content: String
        public let status: String?
    }
    typealias CourseUpdates = [CourseUpdate]
}

public extension DataLayer.CourseUpdate {
    var domain: CourseUpdate {
        CourseUpdate(id: id,
                     date: date,
                     content: content,
                     status: status)
    }
}
