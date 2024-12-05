//
//  CourseForSync.swift
//  Core
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import Foundation

// MARK: - CourseForSync
public struct CourseForSync: Identifiable, Sendable {
    public let id: UUID
    public let courseID: String
    public let name: String
    public var synced: Bool
    public var recentlyActive: Bool

    public init(id: UUID = UUID(), courseID: String, name: String, synced: Bool, recentlyActive: Bool) {
        self.id = id
        self.courseID = courseID
        self.name = name
        self.synced = synced
        self.recentlyActive = recentlyActive
    }
}

extension DataLayer.EnrollmentsStatus {
   public var domain: [CourseForSync] {
        self.compactMap {
            guard let courseID = $0.courseID,
                  let courseName = $0.courseName,
                  let recentlyActive = $0.recentlyActive else { return nil }
            return CourseForSync(
                id: UUID(),
                courseID: courseID,
                name: courseName,
                synced: false,
                recentlyActive: recentlyActive
            )
        }
    }
}

extension CourseForSync: Equatable {
    public static func == (lhs: CourseForSync, rhs: CourseForSync) -> Bool {
        return lhs.courseID == rhs.courseID &&
        lhs.name == rhs.name &&
        lhs.synced == rhs.synced &&
        lhs.recentlyActive == rhs.recentlyActive
    }
}
