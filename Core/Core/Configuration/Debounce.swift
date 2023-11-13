//
//  Debounce.swift
//  Core
//
//  Created by Paul Maul on 17.02.2023.
//

import Foundation
import Combine

public struct Debounce<S: Scheduler> {
    public let scheduler: S
    public let dueTime: S.SchedulerTimeType.Stride
    
    public init(scheduler: S, dueTime: S.SchedulerTimeType.Stride) {
        self.scheduler = scheduler
        self.dueTime = dueTime
    }
}

public extension Debounce where S == RunLoop {
    static var searchDebounce: Debounce<S> {
        Debounce(scheduler: RunLoop.main, dueTime: .milliseconds(800))
    }
}

public extension Debounce where S == ImmediateScheduler {
    static var test: Debounce<S> {
        Debounce(scheduler: ImmediateScheduler.shared, dueTime: .zero)
    }
}
