//
//  Protected.swift
//  Core
//
//  Created by Ivan Stepanok on 14.11.2024.
//

import Foundation

private protocol Lock: Sendable {
    func lock()
    func unlock()
}

extension Lock {
    /// Executes a closure returning a value while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    ///
    /// - Returns:           The value the closure generated.
    func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock(); defer { unlock() }
        return try closure()
    }

    /// Execute a closure while acquiring the lock.
    ///
    /// - Parameter closure: The closure to run.
    func around(_ closure: () throws -> Void) rethrows {
        lock(); defer { unlock() }
        try closure()
    }
}

#if canImport(Darwin)
// Number of Apple engineers who insisted on inspecting this: 5
/// An `os_unfair_lock` wrapper.
final class UnfairLock: Lock, @unchecked Sendable {
    private let unfairLock: os_unfair_lock_t

    init() {
        unfairLock = .allocate(capacity: 1)
        unfairLock.initialize(to: os_unfair_lock())
    }

    deinit {
        unfairLock.deinitialize(count: 1)
        unfairLock.deallocate()
    }

    fileprivate func lock() {
        os_unfair_lock_lock(unfairLock)
    }

    fileprivate func unlock() {
        os_unfair_lock_unlock(unfairLock)
    }
}

#elseif canImport(Foundation)
extension NSLock: Lock {}
#else
#error("This platform needs a Lock-conforming type without Foundation.")
#endif

/// A thread-safe wrapper around a value.
@dynamicMemberLookup
public final class Protected<Value>: Sendable {
    #if canImport(Darwin)
    private let lock = UnfairLock()
    #elseif canImport(Foundation)
    private let lock = NSLock()
    #else
    #error("This platform needs a Lock-conforming type without Foundation.")
    #endif
    #if compiler(>=6)
    private nonisolated(unsafe) var value: Value
    #else
    private var value: Value
    #endif

    public init(_ value: Value) {
        self.value = value
    }

    /// Synchronously read or transform the contained value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The return value of the closure passed.
    func read<U>(_ closure: (Value) throws -> U) rethrows -> U {
        try lock.around { try closure(self.value) }
    }

    /// Synchronously modify the protected value.
    ///
    /// - Parameter closure: The closure to execute.
    ///
    /// - Returns:           The modified value.
    @discardableResult
    func write<U>(_ closure: (inout Value) throws -> U) rethrows -> U {
        try lock.around { try closure(&self.value) }
    }

    /// Synchronously update the protected value.
    ///
    /// - Parameter value: The `Value`.
    func write(_ value: Value) {
        write { $0 = value }
    }

    public subscript<Property>(dynamicMember keyPath: WritableKeyPath<Value, Property>) -> Property {
        get { lock.around { value[keyPath: keyPath] } }
        set { lock.around { value[keyPath: keyPath] = newValue } }
    }

    public subscript<Property>(dynamicMember keyPath: KeyPath<Value, Property>) -> Property {
        lock.around { value[keyPath: keyPath] }
    }
}

extension Protected: Equatable where Value: Equatable {
    public static func == (lhs: Protected<Value>, rhs: Protected<Value>) -> Bool {
        lhs.read { left in rhs.read { right in left == right }}
    }
}

extension Protected: Hashable where Value: Hashable {
     public func hash(into hasher: inout Hasher) {
        read { hasher.combine($0) }
    }
}
