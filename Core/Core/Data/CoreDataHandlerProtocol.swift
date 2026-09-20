//
//  CoreDataHandlerProtocol.swift
//  Core
//
//  Created by  Stepanok Ivan on 09.02.2023.
//

import Foundation

public protocol CoreDataHandlerProtocol: Sendable {
    /// Destroys and rebuilds the whole persistent store -- every instance's data, gone.
    func clear() async

    /// Batch-deletes only `instanceKey`'s rows, leaving other instances' data intact.
    func clear(instanceKey: String) async
}
