//
//  DispatchQueue+App.swift
//  Core
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import Foundation

public func doAfter(_ delay: TimeInterval? = nil, _ closure: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + (delay ?? 0), execute: closure)
}

public func dispatchQueueMain(_ closure: @escaping () -> Void) {
    DispatchQueue.main.async(execute: closure)
}
