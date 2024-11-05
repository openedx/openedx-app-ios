//
//  PluginManager.swift
//  OpenEdX
//
//  Created by Ivan Stepanok on 15.10.2024.
//

import Foundation
import OEXFoundation

public class PluginManager {
    
    private(set) var analyticsServices: [AnalyticsService] = []
    
    public init() {}
    
    func addPlugin(analyticsService: AnalyticsService) {
        analyticsServices.append(analyticsService)
    }
}
