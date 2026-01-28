// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import AppDates
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - AppDatesAnalytics

open class AppDatesAnalyticsMock: AppDatesAnalytics, Mock {
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





    open func mainDatesScreenViewed() {
        addInvocation(.m_mainDatesScreenViewed)
		let perform = methodPerformValue(.m_mainDatesScreenViewed) as? () -> Void
		perform?()
    }

    open func datesCourseClicked(courseId: String, courseName: String) {
        addInvocation(.m_datesCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_datesCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func datesSettingsClicked() {
        addInvocation(.m_datesSettingsClicked)
		let perform = methodPerformValue(.m_datesSettingsClicked) as? () -> Void
		perform?()
    }

    open func datesRefreshPulled() {
        addInvocation(.m_datesRefreshPulled)
		let perform = methodPerformValue(.m_datesRefreshPulled) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_mainDatesScreenViewed
        case m_datesCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_datesSettingsClicked
        case m_datesRefreshPulled

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_mainDatesScreenViewed, .m_mainDatesScreenViewed): return .match

            case (.m_datesCourseClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_datesCourseClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_datesSettingsClicked, .m_datesSettingsClicked): return .match

            case (.m_datesRefreshPulled, .m_datesRefreshPulled): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_mainDatesScreenViewed: return 0
            case let .m_datesCourseClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case .m_datesSettingsClicked: return 0
            case .m_datesRefreshPulled: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_mainDatesScreenViewed: return ".mainDatesScreenViewed()"
            case .m_datesCourseClicked__courseId_courseIdcourseName_courseName: return ".datesCourseClicked(courseId:courseName:)"
            case .m_datesSettingsClicked: return ".datesSettingsClicked()"
            case .m_datesRefreshPulled: return ".datesRefreshPulled()"
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

        public static func mainDatesScreenViewed() -> Verify { return Verify(method: .m_mainDatesScreenViewed)}
        public static func datesCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_datesCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func datesSettingsClicked() -> Verify { return Verify(method: .m_datesSettingsClicked)}
        public static func datesRefreshPulled() -> Verify { return Verify(method: .m_datesRefreshPulled)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func mainDatesScreenViewed(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_mainDatesScreenViewed, performs: perform)
        }
        public static func datesCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_datesCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func datesSettingsClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_datesSettingsClicked, performs: perform)
        }
        public static func datesRefreshPulled(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_datesRefreshPulled, performs: perform)
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

// MARK: - DatesInteractorProtocol

open class DatesInteractorProtocolMock: DatesInteractorProtocol, Mock {
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





    open func getCourseDates(page: Int) throws -> ([CourseDate], String?) {
        addInvocation(.m_getCourseDates__page_page(Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getCourseDates__page_page(Parameter<Int>.value(`page`))) as? (Int) -> Void
		perform?(`page`)
		var __value: ([CourseDate], String?)
		do {
		    __value = try methodReturnValue(.m_getCourseDates__page_page(Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDates(page: Int). Use given")
			Failure("Stub return value not specified for getCourseDates(page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseDatesOffline(limit: Int?, offset: Int?) throws -> [CourseDate] {
        addInvocation(.m_getCourseDatesOffline__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`)))
		let perform = methodPerformValue(.m_getCourseDatesOffline__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`))) as? (Int?, Int?) -> Void
		perform?(`limit`, `offset`)
		var __value: [CourseDate]
		do {
		    __value = try methodReturnValue(.m_getCourseDatesOffline__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDatesOffline(limit: Int?, offset: Int?). Use given")
			Failure("Stub return value not specified for getCourseDatesOffline(limit: Int?, offset: Int?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func resetAllRelativeCourseDeadlines() throws {
        addInvocation(.m_resetAllRelativeCourseDeadlines)
		let perform = methodPerformValue(.m_resetAllRelativeCourseDeadlines) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resetAllRelativeCourseDeadlines).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_getCourseDates__page_page(Parameter<Int>)
        case m_getCourseDatesOffline__limit_limitoffset_offset(Parameter<Int?>, Parameter<Int?>)
        case m_resetAllRelativeCourseDeadlines

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseDates__page_page(let lhsPage), .m_getCourseDates__page_page(let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDatesOffline__limit_limitoffset_offset(let lhsLimit, let lhsOffset), .m_getCourseDatesOffline__limit_limitoffset_offset(let rhsLimit, let rhsOffset)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLimit, rhs: rhsLimit, with: matcher), lhsLimit, rhsLimit, "limit"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOffset, rhs: rhsOffset, with: matcher), lhsOffset, rhsOffset, "offset"))
				return Matcher.ComparisonResult(results)

            case (.m_resetAllRelativeCourseDeadlines, .m_resetAllRelativeCourseDeadlines): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseDates__page_page(p0): return p0.intValue
            case let .m_getCourseDatesOffline__limit_limitoffset_offset(p0, p1): return p0.intValue + p1.intValue
            case .m_resetAllRelativeCourseDeadlines: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseDates__page_page: return ".getCourseDates(page:)"
            case .m_getCourseDatesOffline__limit_limitoffset_offset: return ".getCourseDatesOffline(limit:offset:)"
            case .m_resetAllRelativeCourseDeadlines: return ".resetAllRelativeCourseDeadlines()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseDates(page: Parameter<Int>, willReturn: ([CourseDate], String?)...) -> MethodStub {
            return Given(method: .m_getCourseDates__page_page(`page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDatesOffline(limit: Parameter<Int?>, offset: Parameter<Int?>, willReturn: [CourseDate]...) -> MethodStub {
            return Given(method: .m_getCourseDatesOffline__limit_limitoffset_offset(`limit`, `offset`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDates(page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDates__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDates(page: Parameter<Int>, willProduce: (StubberThrows<([CourseDate], String?)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDates__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([CourseDate], String?)).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDatesOffline(limit: Parameter<Int?>, offset: Parameter<Int?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDatesOffline__limit_limitoffset_offset(`limit`, `offset`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDatesOffline(limit: Parameter<Int?>, offset: Parameter<Int?>, willProduce: (StubberThrows<[CourseDate]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDatesOffline__limit_limitoffset_offset(`limit`, `offset`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseDate]).self)
			willProduce(stubber)
			return given
        }
        public static func resetAllRelativeCourseDeadlines(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetAllRelativeCourseDeadlines, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetAllRelativeCourseDeadlines(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetAllRelativeCourseDeadlines, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseDates(page: Parameter<Int>) -> Verify { return Verify(method: .m_getCourseDates__page_page(`page`))}
        public static func getCourseDatesOffline(limit: Parameter<Int?>, offset: Parameter<Int?>) -> Verify { return Verify(method: .m_getCourseDatesOffline__limit_limitoffset_offset(`limit`, `offset`))}
        public static func resetAllRelativeCourseDeadlines() -> Verify { return Verify(method: .m_resetAllRelativeCourseDeadlines)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseDates(page: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_getCourseDates__page_page(`page`), performs: perform)
        }
        public static func getCourseDatesOffline(limit: Parameter<Int?>, offset: Parameter<Int?>, perform: @escaping (Int?, Int?) -> Void) -> Perform {
            return Perform(method: .m_getCourseDatesOffline__limit_limitoffset_offset(`limit`, `offset`), performs: perform)
        }
        public static func resetAllRelativeCourseDeadlines(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetAllRelativeCourseDeadlines, performs: perform)
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

// MARK: - DatesPersistenceProtocol

open class DatesPersistenceProtocolMock: DatesPersistenceProtocol, Mock {
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





    open func loadCourseDates(limit: Int?, offset: Int?) throws -> [CourseDate] {
        addInvocation(.m_loadCourseDates__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`)))
		let perform = methodPerformValue(.m_loadCourseDates__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`))) as? (Int?, Int?) -> Void
		perform?(`limit`, `offset`)
		var __value: [CourseDate]
		do {
		    __value = try methodReturnValue(.m_loadCourseDates__limit_limitoffset_offset(Parameter<Int?>.value(`limit`), Parameter<Int?>.value(`offset`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for loadCourseDates(limit: Int?, offset: Int?). Use given")
			Failure("Stub return value not specified for loadCourseDates(limit: Int?, offset: Int?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func saveCourseDates(dates: [CourseDate], startIndex: Int) {
        addInvocation(.m_saveCourseDates__dates_datesstartIndex_startIndex(Parameter<[CourseDate]>.value(`dates`), Parameter<Int>.value(`startIndex`)))
		let perform = methodPerformValue(.m_saveCourseDates__dates_datesstartIndex_startIndex(Parameter<[CourseDate]>.value(`dates`), Parameter<Int>.value(`startIndex`))) as? ([CourseDate], Int) -> Void
		perform?(`dates`, `startIndex`)
    }

    open func clearAllCourseDates() {
        addInvocation(.m_clearAllCourseDates)
		let perform = methodPerformValue(.m_clearAllCourseDates) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_loadCourseDates__limit_limitoffset_offset(Parameter<Int?>, Parameter<Int?>)
        case m_saveCourseDates__dates_datesstartIndex_startIndex(Parameter<[CourseDate]>, Parameter<Int>)
        case m_clearAllCourseDates

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_loadCourseDates__limit_limitoffset_offset(let lhsLimit, let lhsOffset), .m_loadCourseDates__limit_limitoffset_offset(let rhsLimit, let rhsOffset)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLimit, rhs: rhsLimit, with: matcher), lhsLimit, rhsLimit, "limit"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOffset, rhs: rhsOffset, with: matcher), lhsOffset, rhsOffset, "offset"))
				return Matcher.ComparisonResult(results)

            case (.m_saveCourseDates__dates_datesstartIndex_startIndex(let lhsDates, let lhsStartindex), .m_saveCourseDates__dates_datesstartIndex_startIndex(let rhsDates, let rhsStartindex)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDates, rhs: rhsDates, with: matcher), lhsDates, rhsDates, "dates"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsStartindex, rhs: rhsStartindex, with: matcher), lhsStartindex, rhsStartindex, "startIndex"))
				return Matcher.ComparisonResult(results)

            case (.m_clearAllCourseDates, .m_clearAllCourseDates): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_loadCourseDates__limit_limitoffset_offset(p0, p1): return p0.intValue + p1.intValue
            case let .m_saveCourseDates__dates_datesstartIndex_startIndex(p0, p1): return p0.intValue + p1.intValue
            case .m_clearAllCourseDates: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_loadCourseDates__limit_limitoffset_offset: return ".loadCourseDates(limit:offset:)"
            case .m_saveCourseDates__dates_datesstartIndex_startIndex: return ".saveCourseDates(dates:startIndex:)"
            case .m_clearAllCourseDates: return ".clearAllCourseDates()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func loadCourseDates(limit: Parameter<Int?>, offset: Parameter<Int?>, willReturn: [CourseDate]...) -> MethodStub {
            return Given(method: .m_loadCourseDates__limit_limitoffset_offset(`limit`, `offset`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func loadCourseDates(limit: Parameter<Int?>, offset: Parameter<Int?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_loadCourseDates__limit_limitoffset_offset(`limit`, `offset`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func loadCourseDates(limit: Parameter<Int?>, offset: Parameter<Int?>, willProduce: (StubberThrows<[CourseDate]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_loadCourseDates__limit_limitoffset_offset(`limit`, `offset`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseDate]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func loadCourseDates(limit: Parameter<Int?>, offset: Parameter<Int?>) -> Verify { return Verify(method: .m_loadCourseDates__limit_limitoffset_offset(`limit`, `offset`))}
        public static func saveCourseDates(dates: Parameter<[CourseDate]>, startIndex: Parameter<Int>) -> Verify { return Verify(method: .m_saveCourseDates__dates_datesstartIndex_startIndex(`dates`, `startIndex`))}
        public static func clearAllCourseDates() -> Verify { return Verify(method: .m_clearAllCourseDates)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func loadCourseDates(limit: Parameter<Int?>, offset: Parameter<Int?>, perform: @escaping (Int?, Int?) -> Void) -> Perform {
            return Perform(method: .m_loadCourseDates__limit_limitoffset_offset(`limit`, `offset`), performs: perform)
        }
        public static func saveCourseDates(dates: Parameter<[CourseDate]>, startIndex: Parameter<Int>, perform: @escaping ([CourseDate], Int) -> Void) -> Perform {
            return Perform(method: .m_saveCourseDates__dates_datesstartIndex_startIndex(`dates`, `startIndex`), performs: perform)
        }
        public static func clearAllCourseDates(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_clearAllCourseDates, performs: perform)
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

