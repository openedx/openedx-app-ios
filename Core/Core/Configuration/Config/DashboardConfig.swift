//
//  DashboardConfig.swift
//  Core
//
//  Created by  Stepanok Ivan on 23.04.2024.
//

import Foundation
import OEXFoundation

public enum DashboardConfigType: String {
    case gallery
    case list
}

private enum DashboardKeys: String, RawStringExtractable {
    case dashboardType = "TYPE"
}

// `@unchecked Sendable`: properties are set once in `init` and never mutated.
public class DashboardConfig: NSObject, @unchecked Sendable {
    public let type: DashboardConfigType

    init(dictionary: [String: AnyObject]) {
        type = (dictionary[DashboardKeys.dashboardType] as? String).flatMap {
            DashboardConfigType(rawValue: $0)
        } ?? .gallery
    }
}

private let key = "DASHBOARD"
extension Config {
    public var dashboard: DashboardConfig {
        DashboardConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}
