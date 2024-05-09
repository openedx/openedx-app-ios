//
//  DashboardConfig.swift
//  Core
//
//  Created by  Stepanok Ivan on 23.04.2024.
//

import Foundation

public enum DashboardConfigType: String {
    case learn
    case dashboard
}

private enum DashboardKeys: String, RawStringExtractable {
    case dashboardType = "TYPE"
}

public class DashboardConfig: NSObject {
    public let type: DashboardConfigType
    
    init(dictionary: [String: AnyObject]) {
        type = (dictionary[DashboardKeys.dashboardType] as? String).flatMap {
            DashboardConfigType(rawValue: $0)
        } ?? .learn
    }
}

private let key = "DASHBOARD"
extension Config {
    public var dashboard: DashboardConfig {
        DashboardConfig(dictionary: self[key] as? [String: AnyObject] ?? [:])
    }
}
