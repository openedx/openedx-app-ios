//
//  CoreDataHandlerProtocol.swift
//  Core
//
//  Created by  Stepanok Ivan on 09.02.2023.
//

import Foundation
@preconcurrency import CoreData

public protocol CoreDataHandlerProtocol: Sendable {
    func clear() async
}
