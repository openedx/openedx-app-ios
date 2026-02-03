//
//  DateGroup.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import Foundation

public struct DateGroup: Identifiable {
    public let id: String
    public let type: DateGroupType
    public let dates: [CourseDate]
    
    public init(type: DateGroupType, dates: [CourseDate]) {
        self.id = type.text
        self.type = type
        self.dates = dates
    }
}
