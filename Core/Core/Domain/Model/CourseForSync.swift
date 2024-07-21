//
//  CourseForSync.swift
//  Core
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import Foundation

// MARK: - CourseForSync
public struct CourseForSync: Identifiable {
    public let id: UUID
    public let courseID: String
    public let name: String
    public var synced: Bool
    public var active: Bool

    public init(id: UUID = UUID(), courseID: String, name: String, synced: Bool, active: Bool) {
        self.id = id
        self.courseID = courseID
        self.name = name
        self.synced = synced
        self.active = active
    }
}

extension DataLayer.EnrollmentsStatus {
   public var domain: [CourseForSync] {
        self.compactMap {
            guard let courseID = $0.courseID,
                  let courseName = $0.courseName,
                  let isActive = $0.isActive else { return nil }
            return CourseForSync(
                id: UUID(),
                courseID: courseID,
                name: courseName,
                synced: false,
                active: isActive
            )
        }
    }
}

