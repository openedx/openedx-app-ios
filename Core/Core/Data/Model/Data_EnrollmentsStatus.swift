//
//  Data_EnrollmentsStatus.swift
//  Core
//
//  Created by  Stepanok Ivan on 28.05.2024.
//

import Foundation

extension DataLayer {
    // MARK: - EnrollmentsStatusElement
    public struct EnrollmentsStatusElement: Codable {
        public let courseID: String?
        public let courseName: String?
        public let recentlyActive: Bool?
        
        public enum CodingKeys: String, CodingKey {
            case courseID = "course_id"
            case courseName = "course_name"
            case recentlyActive = "recently_active"
        }
        
        public init(courseID: String?, courseName: String?, recentlyActive: Bool?) {
            self.courseID = courseID
            self.courseName = courseName
            self.recentlyActive = recentlyActive
        }
    }
    
    public typealias EnrollmentsStatus = [EnrollmentsStatusElement]
}
