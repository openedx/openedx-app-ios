//
//  CalendarSettings.swift
//  Profile
//
//  Created by  Stepanok Ivan on 03.06.2024.
//

import UIKit

public struct CalendarSettings: Codable {
    public var colorSelection: String
    public var calendarName: String?
    public var accountSelection: String
    public var courseCalendarSync: Bool
    public var useRelativeDates: Bool
    
    public init(
        colorSelection: String,
        calendarName: String?,
        accountSelection: String,
        courseCalendarSync: Bool,
        useRelativeDates: Bool
    ) {
        self.colorSelection = colorSelection
        self.calendarName = calendarName
        self.accountSelection = accountSelection
        self.courseCalendarSync = courseCalendarSync
        self.useRelativeDates = useRelativeDates
    }
    
    enum CodingKeys: String, CodingKey {
        case colorSelection
        case calendarName
        case accountSelection
        case courseCalendarSync
        case useRelativeDates
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.colorSelection = try container.decode(String.self, forKey: .colorSelection)
        self.calendarName = try container.decode(String.self, forKey: .calendarName)
        self.accountSelection = try container.decode(String.self, forKey: .accountSelection)
        self.courseCalendarSync = try container.decode(Bool.self, forKey: .courseCalendarSync)
        self.useRelativeDates = try container.decode(Bool.self, forKey: .useRelativeDates)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(colorSelection, forKey: .colorSelection)
        try container.encode(calendarName, forKey: .calendarName)
        try container.encode(accountSelection, forKey: .accountSelection)
        try container.encode(courseCalendarSync, forKey: .courseCalendarSync)
        try container.encode(useRelativeDates, forKey: .useRelativeDates)
    }
}
