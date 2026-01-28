// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Dashboard
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - DashboardAnalytics

open class DashboardAnalyticsMock: DashboardAnalytics, Mock {
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





    open func dashboardCourseClicked(courseID: String, courseName: String) {
        addInvocation(.m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseID`, `courseName`)
    }

    open func mainProgramsClicked() {
        addInvocation(.m_mainProgramsClicked)
		let perform = methodPerformValue(.m_mainProgramsClicked) as? () -> Void
		perform?()
    }

    open func mainCoursesClicked() {
        addInvocation(.m_mainCoursesClicked)
		let perform = methodPerformValue(.m_mainCoursesClicked) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_mainProgramsClicked
        case m_mainCoursesClicked

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_mainProgramsClicked, .m_mainProgramsClicked): return .match

            case (.m_mainCoursesClicked, .m_mainCoursesClicked): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case .m_mainProgramsClicked: return 0
            case .m_mainCoursesClicked: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_dashboardCourseClicked__courseID_courseIDcourseName_courseName: return ".dashboardCourseClicked(courseID:courseName:)"
            case .m_mainProgramsClicked: return ".mainProgramsClicked()"
            case .m_mainCoursesClicked: return ".mainCoursesClicked()"
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

        public static func dashboardCourseClicked(courseID: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(`courseID`, `courseName`))}
        public static func mainProgramsClicked() -> Verify { return Verify(method: .m_mainProgramsClicked)}
        public static func mainCoursesClicked() -> Verify { return Verify(method: .m_mainCoursesClicked)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func dashboardCourseClicked(courseID: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_dashboardCourseClicked__courseID_courseIDcourseName_courseName(`courseID`, `courseName`), performs: perform)
        }
        public static func mainProgramsClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_mainProgramsClicked, performs: perform)
        }
        public static func mainCoursesClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_mainCoursesClicked, performs: perform)
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

// MARK: - DashboardInteractorProtocol

open class DashboardInteractorProtocolMock: DashboardInteractorProtocol, Mock {
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





    open func getEnrollments(page: Int) throws -> [CourseItem] {
        addInvocation(.m_getEnrollments__page_page(Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getEnrollments__page_page(Parameter<Int>.value(`page`))) as? (Int) -> Void
		perform?(`page`)
		var __value: [CourseItem]
		do {
		    __value = try methodReturnValue(.m_getEnrollments__page_page(Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getEnrollments(page: Int). Use given")
			Failure("Stub return value not specified for getEnrollments(page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getEnrollmentsOffline() throws -> [CourseItem] {
        addInvocation(.m_getEnrollmentsOffline)
		let perform = methodPerformValue(.m_getEnrollmentsOffline) as? () -> Void
		perform?()
		var __value: [CourseItem]
		do {
		    __value = try methodReturnValue(.m_getEnrollmentsOffline).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getEnrollmentsOffline(). Use given")
			Failure("Stub return value not specified for getEnrollmentsOffline(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getPrimaryEnrollment(pageSize: Int) throws -> PrimaryEnrollment {
        addInvocation(.m_getPrimaryEnrollment__pageSize_pageSize(Parameter<Int>.value(`pageSize`)))
		let perform = methodPerformValue(.m_getPrimaryEnrollment__pageSize_pageSize(Parameter<Int>.value(`pageSize`))) as? (Int) -> Void
		perform?(`pageSize`)
		var __value: PrimaryEnrollment
		do {
		    __value = try methodReturnValue(.m_getPrimaryEnrollment__pageSize_pageSize(Parameter<Int>.value(`pageSize`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getPrimaryEnrollment(pageSize: Int). Use given")
			Failure("Stub return value not specified for getPrimaryEnrollment(pageSize: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getPrimaryEnrollmentOffline() throws -> PrimaryEnrollment {
        addInvocation(.m_getPrimaryEnrollmentOffline)
		let perform = methodPerformValue(.m_getPrimaryEnrollmentOffline) as? () -> Void
		perform?()
		var __value: PrimaryEnrollment
		do {
		    __value = try methodReturnValue(.m_getPrimaryEnrollmentOffline).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getPrimaryEnrollmentOffline(). Use given")
			Failure("Stub return value not specified for getPrimaryEnrollmentOffline(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getAllCourses(filteredBy: String, page: Int) throws -> PrimaryEnrollment {
        addInvocation(.m_getAllCourses__filteredBy_filteredBypage_page(Parameter<String>.value(`filteredBy`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getAllCourses__filteredBy_filteredBypage_page(Parameter<String>.value(`filteredBy`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`filteredBy`, `page`)
		var __value: PrimaryEnrollment
		do {
		    __value = try methodReturnValue(.m_getAllCourses__filteredBy_filteredBypage_page(Parameter<String>.value(`filteredBy`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getAllCourses(filteredBy: String, page: Int). Use given")
			Failure("Stub return value not specified for getAllCourses(filteredBy: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getEnrollments__page_page(Parameter<Int>)
        case m_getEnrollmentsOffline
        case m_getPrimaryEnrollment__pageSize_pageSize(Parameter<Int>)
        case m_getPrimaryEnrollmentOffline
        case m_getAllCourses__filteredBy_filteredBypage_page(Parameter<String>, Parameter<Int>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getEnrollments__page_page(let lhsPage), .m_getEnrollments__page_page(let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getEnrollmentsOffline, .m_getEnrollmentsOffline): return .match

            case (.m_getPrimaryEnrollment__pageSize_pageSize(let lhsPagesize), .m_getPrimaryEnrollment__pageSize_pageSize(let rhsPagesize)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPagesize, rhs: rhsPagesize, with: matcher), lhsPagesize, rhsPagesize, "pageSize"))
				return Matcher.ComparisonResult(results)

            case (.m_getPrimaryEnrollmentOffline, .m_getPrimaryEnrollmentOffline): return .match

            case (.m_getAllCourses__filteredBy_filteredBypage_page(let lhsFilteredby, let lhsPage), .m_getAllCourses__filteredBy_filteredBypage_page(let rhsFilteredby, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFilteredby, rhs: rhsFilteredby, with: matcher), lhsFilteredby, rhsFilteredby, "filteredBy"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getEnrollments__page_page(p0): return p0.intValue
            case .m_getEnrollmentsOffline: return 0
            case let .m_getPrimaryEnrollment__pageSize_pageSize(p0): return p0.intValue
            case .m_getPrimaryEnrollmentOffline: return 0
            case let .m_getAllCourses__filteredBy_filteredBypage_page(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getEnrollments__page_page: return ".getEnrollments(page:)"
            case .m_getEnrollmentsOffline: return ".getEnrollmentsOffline()"
            case .m_getPrimaryEnrollment__pageSize_pageSize: return ".getPrimaryEnrollment(pageSize:)"
            case .m_getPrimaryEnrollmentOffline: return ".getPrimaryEnrollmentOffline()"
            case .m_getAllCourses__filteredBy_filteredBypage_page: return ".getAllCourses(filteredBy:page:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getEnrollments(page: Parameter<Int>, willReturn: [CourseItem]...) -> MethodStub {
            return Given(method: .m_getEnrollments__page_page(`page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getEnrollmentsOffline(willReturn: [CourseItem]...) -> MethodStub {
            return Given(method: .m_getEnrollmentsOffline, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getPrimaryEnrollment(pageSize: Parameter<Int>, willReturn: PrimaryEnrollment...) -> MethodStub {
            return Given(method: .m_getPrimaryEnrollment__pageSize_pageSize(`pageSize`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getPrimaryEnrollmentOffline(willReturn: PrimaryEnrollment...) -> MethodStub {
            return Given(method: .m_getPrimaryEnrollmentOffline, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getAllCourses(filteredBy: Parameter<String>, page: Parameter<Int>, willReturn: PrimaryEnrollment...) -> MethodStub {
            return Given(method: .m_getAllCourses__filteredBy_filteredBypage_page(`filteredBy`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getEnrollments(page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getEnrollments__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getEnrollments(page: Parameter<Int>, willProduce: (StubberThrows<[CourseItem]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getEnrollments__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseItem]).self)
			willProduce(stubber)
			return given
        }
        public static func getEnrollmentsOffline(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getEnrollmentsOffline, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getEnrollmentsOffline(willProduce: (StubberThrows<[CourseItem]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getEnrollmentsOffline, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseItem]).self)
			willProduce(stubber)
			return given
        }
        public static func getPrimaryEnrollment(pageSize: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getPrimaryEnrollment__pageSize_pageSize(`pageSize`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getPrimaryEnrollment(pageSize: Parameter<Int>, willProduce: (StubberThrows<PrimaryEnrollment>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getPrimaryEnrollment__pageSize_pageSize(`pageSize`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (PrimaryEnrollment).self)
			willProduce(stubber)
			return given
        }
        public static func getPrimaryEnrollmentOffline(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getPrimaryEnrollmentOffline, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getPrimaryEnrollmentOffline(willProduce: (StubberThrows<PrimaryEnrollment>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getPrimaryEnrollmentOffline, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (PrimaryEnrollment).self)
			willProduce(stubber)
			return given
        }
        public static func getAllCourses(filteredBy: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getAllCourses__filteredBy_filteredBypage_page(`filteredBy`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getAllCourses(filteredBy: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<PrimaryEnrollment>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getAllCourses__filteredBy_filteredBypage_page(`filteredBy`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (PrimaryEnrollment).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getEnrollments(page: Parameter<Int>) -> Verify { return Verify(method: .m_getEnrollments__page_page(`page`))}
        public static func getEnrollmentsOffline() -> Verify { return Verify(method: .m_getEnrollmentsOffline)}
        public static func getPrimaryEnrollment(pageSize: Parameter<Int>) -> Verify { return Verify(method: .m_getPrimaryEnrollment__pageSize_pageSize(`pageSize`))}
        public static func getPrimaryEnrollmentOffline() -> Verify { return Verify(method: .m_getPrimaryEnrollmentOffline)}
        public static func getAllCourses(filteredBy: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getAllCourses__filteredBy_filteredBypage_page(`filteredBy`, `page`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getEnrollments(page: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_getEnrollments__page_page(`page`), performs: perform)
        }
        public static func getEnrollmentsOffline(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getEnrollmentsOffline, performs: perform)
        }
        public static func getPrimaryEnrollment(pageSize: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_getPrimaryEnrollment__pageSize_pageSize(`pageSize`), performs: perform)
        }
        public static func getPrimaryEnrollmentOffline(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getPrimaryEnrollmentOffline, performs: perform)
        }
        public static func getAllCourses(filteredBy: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getAllCourses__filteredBy_filteredBypage_page(`filteredBy`, `page`), performs: perform)
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

