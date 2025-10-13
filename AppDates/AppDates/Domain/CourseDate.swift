//
//  CourseDate.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

public struct CourseDate: Identifiable, Sendable {
    public var id: String {
        var components: [String] = [
            courseName,
            title,
            String(Int(date.timeIntervalSince1970))
        ]
        if let courseId {
            components.append(courseId)
        }
        if let blockId {
            components.append(blockId)
        }
        if let order {
            components.append("order:\(order)")
        }
        return components.joined(separator: "|")
    }
    public let date: Date
    public let title: String
    public let courseName: String
    public let courseId: String?
    public let blockId: String?
    public let hasAccess: Bool
    public let order: Int?
    
    public init(
        date: Date,
        title: String,
        courseName: String,
        courseId: String? = nil,
        blockId: String? = nil,
        hasAccess: Bool = true,
        order: Int? = nil
    ) {
        self.date = date
        self.title = title
        self.courseName = courseName
        self.courseId = courseId
        self.blockId = blockId
        self.hasAccess = hasAccess
        self.order = order
    }
}
