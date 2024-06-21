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
        public let isActive: Bool?
        
        public enum CodingKeys: String, CodingKey {
            case courseID = "course_id"
            case courseName = "course_name"
            case isActive = "is_active"
        }
        
        public init(courseID: String?, courseName: String?, isActive: Bool?) {
            self.courseID = courseID
            self.courseName = courseName
            self.isActive = isActive
        }
    }
    
    public typealias EnrollmentsStatus = [EnrollmentsStatusElement]
}
