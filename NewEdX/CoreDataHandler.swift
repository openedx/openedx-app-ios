//
//  CoreDataHandler.swift
//  NewEdX
//
//  Created by  Stepanok Ivan on 09.02.2023.
//

import Foundation
import Core
import Dashboard
import Discovery
import Course

class CoreDataHandler: CoreDataHandlerProtocol {
    
    private let dashboardPersistence: DashboardPersistenceProtocol
    private let discoveryPersistence: DiscoveryPersistenceProtocol
    private let coursePersistence: CoursePersistenceProtocol
    
    init(dashboardPersistence: DashboardPersistenceProtocol,
         discoveryPersistence: DiscoveryPersistenceProtocol,
         coursePersistence: CoursePersistenceProtocol) {
        self.dashboardPersistence = dashboardPersistence
        self.discoveryPersistence = discoveryPersistence
        self.coursePersistence = coursePersistence
    }
    
    func clear() {
        dashboardPersistence.clear()
        discoveryPersistence.clear()
        coursePersistence.clear()
    }
}
