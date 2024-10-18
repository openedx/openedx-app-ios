// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import WhatsNew
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - WhatsNewAnalytics

open class WhatsNewAnalyticsMock: WhatsNewAnalytics, Mock {
    public init(sequencing sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst, stubbing stubbingPolicy: StubbingPolicy = .wrap, file: StaticString = #file, line: UInt = #line) {
        SwiftyMockyTestObserver.setup()
        self.sequencingPolicy = sequencingPolicy
        self.stubbingPolicy = stubbingPolicy
        self.file = file
        self.line = line
    }

    var matcher: Matcher = Matcher.default
    var stubbingPolicy: StubbingPolicy = .wrap
    var sequencingPolicy: SequencingPolicy = .lastWrittenResolvedFirst

    private var queue = DispatchQueue(label: "com.swiftymocky.invocations", qos: .userInteractive)
    private var invocations: [MethodType] = []
    private var methodReturnValues: [Given] = []
    private var methodPerformValues: [Perform] = []
    private var file: StaticString?
    private var line: UInt?

    public typealias PropertyStub = Given
    public typealias MethodStub = Given
    public typealias SubscriptStub = Given

    /// Convenience method - call setupMock() to extend debug information when failure occurs
    public func setupMock(file: StaticString = #file, line: UInt = #line) {
        self.file = file
        self.line = line
    }

    /// Clear mock internals. You can specify what to reset (invocations aka verify, givens or performs) or leave it empty to clear all mock internals
    public func resetMock(_ scopes: MockScope...) {
        let scopes: [MockScope] = scopes.isEmpty ? [.invocation, .given, .perform] : scopes
        if scopes.contains(.invocation) { invocations = [] }
        if scopes.contains(.given) { methodReturnValues = [] }
        if scopes.contains(.perform) { methodPerformValues = [] }
    }





    open func whatsnewPopup() {
        addInvocation(.m_whatsnewPopup)
		let perform = methodPerformValue(.m_whatsnewPopup) as? () -> Void
		perform?()
    }

    open func whatsnewDone(totalScreens: Int) {
        addInvocation(.m_whatsnewDone__totalScreens_totalScreens(Parameter<Int>.value(`totalScreens`)))
		let perform = methodPerformValue(.m_whatsnewDone__totalScreens_totalScreens(Parameter<Int>.value(`totalScreens`))) as? (Int) -> Void
		perform?(`totalScreens`)
    }

    open func whatsnewClose(totalScreens: Int, currentScreen: Int) {
        addInvocation(.m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(Parameter<Int>.value(`totalScreens`), Parameter<Int>.value(`currentScreen`)))
		let perform = methodPerformValue(.m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(Parameter<Int>.value(`totalScreens`), Parameter<Int>.value(`currentScreen`))) as? (Int, Int) -> Void
		perform?(`totalScreens`, `currentScreen`)
    }


    fileprivate enum MethodType {
        case m_whatsnewPopup
        case m_whatsnewDone__totalScreens_totalScreens(Parameter<Int>)
        case m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(Parameter<Int>, Parameter<Int>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_whatsnewPopup, .m_whatsnewPopup): return .match

            case (.m_whatsnewDone__totalScreens_totalScreens(let lhsTotalscreens), .m_whatsnewDone__totalScreens_totalScreens(let rhsTotalscreens)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTotalscreens, rhs: rhsTotalscreens, with: matcher), lhsTotalscreens, rhsTotalscreens, "totalScreens"))
				return Matcher.ComparisonResult(results)

            case (.m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(let lhsTotalscreens, let lhsCurrentscreen), .m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(let rhsTotalscreens, let rhsCurrentscreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTotalscreens, rhs: rhsTotalscreens, with: matcher), lhsTotalscreens, rhsTotalscreens, "totalScreens"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCurrentscreen, rhs: rhsCurrentscreen, with: matcher), lhsCurrentscreen, rhsCurrentscreen, "currentScreen"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_whatsnewPopup: return 0
            case let .m_whatsnewDone__totalScreens_totalScreens(p0): return p0.intValue
            case let .m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_whatsnewPopup: return ".whatsnewPopup()"
            case .m_whatsnewDone__totalScreens_totalScreens: return ".whatsnewDone(totalScreens:)"
            case .m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen: return ".whatsnewClose(totalScreens:currentScreen:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func whatsnewPopup() -> Verify { return Verify(method: .m_whatsnewPopup)}
        public static func whatsnewDone(totalScreens: Parameter<Int>) -> Verify { return Verify(method: .m_whatsnewDone__totalScreens_totalScreens(`totalScreens`))}
        public static func whatsnewClose(totalScreens: Parameter<Int>, currentScreen: Parameter<Int>) -> Verify { return Verify(method: .m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(`totalScreens`, `currentScreen`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func whatsnewPopup(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_whatsnewPopup, performs: perform)
        }
        public static func whatsnewDone(totalScreens: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_whatsnewDone__totalScreens_totalScreens(`totalScreens`), performs: perform)
        }
        public static func whatsnewClose(totalScreens: Parameter<Int>, currentScreen: Parameter<Int>, perform: @escaping (Int, Int) -> Void) -> Perform {
            return Perform(method: .m_whatsnewClose__totalScreens_totalScreenscurrentScreen_currentScreen(`totalScreens`, `currentScreen`), performs: perform)
        }
    }

    public func given(_ method: Given) {
        methodReturnValues.append(method)
    }

    public func perform(_ method: Perform) {
        methodPerformValues.append(method)
        methodPerformValues.sort { $0.method.intValue() < $1.method.intValue() }
    }

    public func verify(_ method: Verify, count: Count = Count.moreOrEqual(to: 1), file: StaticString = #file, line: UInt = #line) {
        let fullMatches = matchingCalls(method, file: file, line: line)
        let success = count.matches(fullMatches)
        let assertionName = method.method.assertionName()
        let feedback: String = {
            guard !success else { return "" }
            return Utils.closestCallsMessage(
                for: self.invocations.map { invocation in
                    matcher.set(file: file, line: line)
                    defer { matcher.clearFileAndLine() }
                    return MethodType.compareParameters(lhs: invocation, rhs: method.method, matcher: matcher)
                },
                name: assertionName
            )
        }()
        MockyAssert(success, "Expected: \(count) invocations of `\(assertionName)`, but was: \(fullMatches).\(feedback)", file: file, line: line)
    }

    private func addInvocation(_ call: MethodType) {
        self.queue.sync { invocations.append(call) }
    }
    private func methodReturnValue(_ method: MethodType) throws -> StubProduct {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let candidates = sequencingPolicy.sorted(methodReturnValues, by: { $0.method.intValue() > $1.method.intValue() })
        let matched = candidates.first(where: { $0.isValid && MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch })
        guard let product = matched?.getProduct(policy: self.stubbingPolicy) else { throw MockError.notStubed }
        return product
    }
    private func methodPerformValue(_ method: MethodType) -> Any? {
        matcher.set(file: self.file, line: self.line)
        defer { matcher.clearFileAndLine() }
        let matched = methodPerformValues.reversed().first { MethodType.compareParameters(lhs: $0.method, rhs: method, matcher: matcher).isFullMatch }
        return matched?.performs
    }
    private func matchingCalls(_ method: MethodType, file: StaticString?, line: UInt?) -> [MethodType] {
        matcher.set(file: file ?? self.file, line: line ?? self.line)
        defer { matcher.clearFileAndLine() }
        return invocations.filter { MethodType.compareParameters(lhs: $0, rhs: method, matcher: matcher).isFullMatch }
    }
    private func matchingCalls(_ method: Verify, file: StaticString?, line: UInt?) -> Int {
        return matchingCalls(method.method, file: file, line: line).count
    }
    private func givenGetterValue<T>(_ method: MethodType, _ message: String) -> T {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            onFatalFailure(message)
            Failure(message)
        }
    }
    private func optionalGivenGetterValue<T>(_ method: MethodType, _ message: String) -> T? {
        do {
            return try methodReturnValue(method).casted()
        } catch {
            return nil
        }
    }
    private func onFatalFailure(_ message: String) {
        guard let file = self.file, let line = self.line else { return } // Let if fail if cannot handle gratefully
        SwiftyMockyTestObserver.handleFatalError(message: message, file: file, line: line)
    }
}

