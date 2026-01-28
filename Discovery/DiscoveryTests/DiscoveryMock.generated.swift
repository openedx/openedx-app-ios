// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Discovery
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - DiscoveryAnalytics

open class DiscoveryAnalyticsMock: DiscoveryAnalytics, Mock {
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





    open func discoverySearchBarClicked() {
        addInvocation(.m_discoverySearchBarClicked)
		let perform = methodPerformValue(.m_discoverySearchBarClicked) as? () -> Void
		perform?()
    }

    open func discoveryCoursesSearch(label: String, coursesCount: Int) {
        addInvocation(.m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(Parameter<String>.value(`label`), Parameter<Int>.value(`coursesCount`)))
		let perform = methodPerformValue(.m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(Parameter<String>.value(`label`), Parameter<Int>.value(`coursesCount`))) as? (String, Int) -> Void
		perform?(`label`, `coursesCount`)
    }

    open func discoveryCourseClicked(courseID: String, courseName: String) {
        addInvocation(.m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseID`, `courseName`)
    }

    open func viewCourseClicked(courseId: String, courseName: String) {
        addInvocation(.m_viewCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_viewCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseEnrollClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseEnrollClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseEnrollClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseEnrollSuccess(courseId: String, courseName: String) {
        addInvocation(.m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func externalLinkOpen(url: String, screen: String) {
        addInvocation(.m_externalLinkOpen__url_urlscreen_screen(Parameter<String>.value(`url`), Parameter<String>.value(`screen`)))
		let perform = methodPerformValue(.m_externalLinkOpen__url_urlscreen_screen(Parameter<String>.value(`url`), Parameter<String>.value(`screen`))) as? (String, String) -> Void
		perform?(`url`, `screen`)
    }

    open func externalLinkOpenAction(url: String, screen: String, action: String) {
        addInvocation(.m_externalLinkOpenAction__url_urlscreen_screenaction_action(Parameter<String>.value(`url`), Parameter<String>.value(`screen`), Parameter<String>.value(`action`)))
		let perform = methodPerformValue(.m_externalLinkOpenAction__url_urlscreen_screenaction_action(Parameter<String>.value(`url`), Parameter<String>.value(`screen`), Parameter<String>.value(`action`))) as? (String, String, String) -> Void
		perform?(`url`, `screen`, `action`)
    }

    open func discoveryScreenEvent(event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_discoveryScreenEvent__event_eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_discoveryScreenEvent__event_eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }


    fileprivate enum MethodType {
        case m_discoverySearchBarClicked
        case m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(Parameter<String>, Parameter<Int>)
        case m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_viewCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseEnrollClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_externalLinkOpen__url_urlscreen_screen(Parameter<String>, Parameter<String>)
        case m_externalLinkOpenAction__url_urlscreen_screenaction_action(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_discoveryScreenEvent__event_eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_discoverySearchBarClicked, .m_discoverySearchBarClicked): return .match

            case (.m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(let lhsLabel, let lhsCoursescount), .m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(let rhsLabel, let rhsCoursescount)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLabel, rhs: rhsLabel, with: matcher), lhsLabel, rhsLabel, "label"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursescount, rhs: rhsCoursescount, with: matcher), lhsCoursescount, rhsCoursescount, "coursesCount"))
				return Matcher.ComparisonResult(results)

            case (.m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_viewCourseClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_viewCourseClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseEnrollClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseEnrollClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_externalLinkOpen__url_urlscreen_screen(let lhsUrl, let lhsScreen), .m_externalLinkOpen__url_urlscreen_screen(let rhsUrl, let rhsScreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				return Matcher.ComparisonResult(results)

            case (.m_externalLinkOpenAction__url_urlscreen_screenaction_action(let lhsUrl, let lhsScreen, let lhsAction), .m_externalLinkOpenAction__url_urlscreen_screenaction_action(let rhsUrl, let rhsScreen, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_discoveryScreenEvent__event_eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_discoveryScreenEvent__event_eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_discoverySearchBarClicked: return 0
            case let .m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(p0, p1): return p0.intValue + p1.intValue
            case let .m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_viewCourseClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseEnrollClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_externalLinkOpen__url_urlscreen_screen(p0, p1): return p0.intValue + p1.intValue
            case let .m_externalLinkOpenAction__url_urlscreen_screenaction_action(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_discoveryScreenEvent__event_eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_discoverySearchBarClicked: return ".discoverySearchBarClicked()"
            case .m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount: return ".discoveryCoursesSearch(label:coursesCount:)"
            case .m_discoveryCourseClicked__courseID_courseIDcourseName_courseName: return ".discoveryCourseClicked(courseID:courseName:)"
            case .m_viewCourseClicked__courseId_courseIdcourseName_courseName: return ".viewCourseClicked(courseId:courseName:)"
            case .m_courseEnrollClicked__courseId_courseIdcourseName_courseName: return ".courseEnrollClicked(courseId:courseName:)"
            case .m_courseEnrollSuccess__courseId_courseIdcourseName_courseName: return ".courseEnrollSuccess(courseId:courseName:)"
            case .m_externalLinkOpen__url_urlscreen_screen: return ".externalLinkOpen(url:screen:)"
            case .m_externalLinkOpenAction__url_urlscreen_screenaction_action: return ".externalLinkOpenAction(url:screen:action:)"
            case .m_discoveryScreenEvent__event_eventbiValue_biValue: return ".discoveryScreenEvent(event:biValue:)"
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

        public static func discoverySearchBarClicked() -> Verify { return Verify(method: .m_discoverySearchBarClicked)}
        public static func discoveryCoursesSearch(label: Parameter<String>, coursesCount: Parameter<Int>) -> Verify { return Verify(method: .m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(`label`, `coursesCount`))}
        public static func discoveryCourseClicked(courseID: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(`courseID`, `courseName`))}
        public static func viewCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_viewCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseEnrollClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseEnrollClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseEnrollSuccess(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func externalLinkOpen(url: Parameter<String>, screen: Parameter<String>) -> Verify { return Verify(method: .m_externalLinkOpen__url_urlscreen_screen(`url`, `screen`))}
        public static func externalLinkOpenAction(url: Parameter<String>, screen: Parameter<String>, action: Parameter<String>) -> Verify { return Verify(method: .m_externalLinkOpenAction__url_urlscreen_screenaction_action(`url`, `screen`, `action`))}
        public static func discoveryScreenEvent(event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_discoveryScreenEvent__event_eventbiValue_biValue(`event`, `biValue`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func discoverySearchBarClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_discoverySearchBarClicked, performs: perform)
        }
        public static func discoveryCoursesSearch(label: Parameter<String>, coursesCount: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_discoveryCoursesSearch__label_labelcoursesCount_coursesCount(`label`, `coursesCount`), performs: perform)
        }
        public static func discoveryCourseClicked(courseID: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_discoveryCourseClicked__courseID_courseIDcourseName_courseName(`courseID`, `courseName`), performs: perform)
        }
        public static func viewCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_viewCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseEnrollClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseEnrollClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseEnrollSuccess(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseEnrollSuccess__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func externalLinkOpen(url: Parameter<String>, screen: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_externalLinkOpen__url_urlscreen_screen(`url`, `screen`), performs: perform)
        }
        public static func externalLinkOpenAction(url: Parameter<String>, screen: Parameter<String>, action: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_externalLinkOpenAction__url_urlscreen_screenaction_action(`url`, `screen`, `action`), performs: perform)
        }
        public static func discoveryScreenEvent(event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_discoveryScreenEvent__event_eventbiValue_biValue(`event`, `biValue`), performs: perform)
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

// MARK: - DiscoveryInteractorProtocol

open class DiscoveryInteractorProtocolMock: DiscoveryInteractorProtocol, Mock {
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





    open func discovery(page: Int) throws -> [CourseItem] {
        addInvocation(.m_discovery__page_page(Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_discovery__page_page(Parameter<Int>.value(`page`))) as? (Int) -> Void
		perform?(`page`)
		var __value: [CourseItem]
		do {
		    __value = try methodReturnValue(.m_discovery__page_page(Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for discovery(page: Int). Use given")
			Failure("Stub return value not specified for discovery(page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func discoveryOffline() throws -> [CourseItem] {
        addInvocation(.m_discoveryOffline)
		let perform = methodPerformValue(.m_discoveryOffline) as? () -> Void
		perform?()
		var __value: [CourseItem]
		do {
		    __value = try methodReturnValue(.m_discoveryOffline).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for discoveryOffline(). Use given")
			Failure("Stub return value not specified for discoveryOffline(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func search(page: Int, searchTerm: String) throws -> [CourseItem] {
        addInvocation(.m_search__page_pagesearchTerm_searchTerm(Parameter<Int>.value(`page`), Parameter<String>.value(`searchTerm`)))
		let perform = methodPerformValue(.m_search__page_pagesearchTerm_searchTerm(Parameter<Int>.value(`page`), Parameter<String>.value(`searchTerm`))) as? (Int, String) -> Void
		perform?(`page`, `searchTerm`)
		var __value: [CourseItem]
		do {
		    __value = try methodReturnValue(.m_search__page_pagesearchTerm_searchTerm(Parameter<Int>.value(`page`), Parameter<String>.value(`searchTerm`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for search(page: Int, searchTerm: String). Use given")
			Failure("Stub return value not specified for search(page: Int, searchTerm: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getLoadedCourseDetails(courseID: String) throws -> CourseDetails {
        addInvocation(.m_getLoadedCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getLoadedCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDetails
		do {
		    __value = try methodReturnValue(.m_getLoadedCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getLoadedCourseDetails(courseID: String). Use given")
			Failure("Stub return value not specified for getLoadedCourseDetails(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseDetails(courseID: String) throws -> CourseDetails {
        addInvocation(.m_getCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDetails
		do {
		    __value = try methodReturnValue(.m_getCourseDetails__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDetails(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDetails(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func enrollToCourse(courseID: String) throws -> Bool {
        addInvocation(.m_enrollToCourse__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_enrollToCourse__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_enrollToCourse__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for enrollToCourse(courseID: String). Use given")
			Failure("Stub return value not specified for enrollToCourse(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_discovery__page_page(Parameter<Int>)
        case m_discoveryOffline
        case m_search__page_pagesearchTerm_searchTerm(Parameter<Int>, Parameter<String>)
        case m_getLoadedCourseDetails__courseID_courseID(Parameter<String>)
        case m_getCourseDetails__courseID_courseID(Parameter<String>)
        case m_enrollToCourse__courseID_courseID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_discovery__page_page(let lhsPage), .m_discovery__page_page(let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_discoveryOffline, .m_discoveryOffline): return .match

            case (.m_search__page_pagesearchTerm_searchTerm(let lhsPage, let lhsSearchterm), .m_search__page_pagesearchTerm_searchTerm(let rhsPage, let rhsSearchterm)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchterm, rhs: rhsSearchterm, with: matcher), lhsSearchterm, rhsSearchterm, "searchTerm"))
				return Matcher.ComparisonResult(results)

            case (.m_getLoadedCourseDetails__courseID_courseID(let lhsCourseid), .m_getLoadedCourseDetails__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDetails__courseID_courseID(let lhsCourseid), .m_getCourseDetails__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_enrollToCourse__courseID_courseID(let lhsCourseid), .m_enrollToCourse__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_discovery__page_page(p0): return p0.intValue
            case .m_discoveryOffline: return 0
            case let .m_search__page_pagesearchTerm_searchTerm(p0, p1): return p0.intValue + p1.intValue
            case let .m_getLoadedCourseDetails__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseDetails__courseID_courseID(p0): return p0.intValue
            case let .m_enrollToCourse__courseID_courseID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_discovery__page_page: return ".discovery(page:)"
            case .m_discoveryOffline: return ".discoveryOffline()"
            case .m_search__page_pagesearchTerm_searchTerm: return ".search(page:searchTerm:)"
            case .m_getLoadedCourseDetails__courseID_courseID: return ".getLoadedCourseDetails(courseID:)"
            case .m_getCourseDetails__courseID_courseID: return ".getCourseDetails(courseID:)"
            case .m_enrollToCourse__courseID_courseID: return ".enrollToCourse(courseID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func discovery(page: Parameter<Int>, willReturn: [CourseItem]...) -> MethodStub {
            return Given(method: .m_discovery__page_page(`page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func discoveryOffline(willReturn: [CourseItem]...) -> MethodStub {
            return Given(method: .m_discoveryOffline, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func search(page: Parameter<Int>, searchTerm: Parameter<String>, willReturn: [CourseItem]...) -> MethodStub {
            return Given(method: .m_search__page_pagesearchTerm_searchTerm(`page`, `searchTerm`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getLoadedCourseDetails(courseID: Parameter<String>, willReturn: CourseDetails...) -> MethodStub {
            return Given(method: .m_getLoadedCourseDetails__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDetails(courseID: Parameter<String>, willReturn: CourseDetails...) -> MethodStub {
            return Given(method: .m_getCourseDetails__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func enrollToCourse(courseID: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_enrollToCourse__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func discovery(page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_discovery__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func discovery(page: Parameter<Int>, willProduce: (StubberThrows<[CourseItem]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_discovery__page_page(`page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseItem]).self)
			willProduce(stubber)
			return given
        }
        public static func discoveryOffline(willThrow: Error...) -> MethodStub {
            return Given(method: .m_discoveryOffline, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func discoveryOffline(willProduce: (StubberThrows<[CourseItem]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_discoveryOffline, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseItem]).self)
			willProduce(stubber)
			return given
        }
        public static func search(page: Parameter<Int>, searchTerm: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_search__page_pagesearchTerm_searchTerm(`page`, `searchTerm`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func search(page: Parameter<Int>, searchTerm: Parameter<String>, willProduce: (StubberThrows<[CourseItem]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_search__page_pagesearchTerm_searchTerm(`page`, `searchTerm`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseItem]).self)
			willProduce(stubber)
			return given
        }
        public static func getLoadedCourseDetails(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getLoadedCourseDetails__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getLoadedCourseDetails(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDetails>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getLoadedCourseDetails__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDetails).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDetails(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDetails__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDetails(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDetails>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDetails__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDetails).self)
			willProduce(stubber)
			return given
        }
        public static func enrollToCourse(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_enrollToCourse__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func enrollToCourse(courseID: Parameter<String>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_enrollToCourse__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func discovery(page: Parameter<Int>) -> Verify { return Verify(method: .m_discovery__page_page(`page`))}
        public static func discoveryOffline() -> Verify { return Verify(method: .m_discoveryOffline)}
        public static func search(page: Parameter<Int>, searchTerm: Parameter<String>) -> Verify { return Verify(method: .m_search__page_pagesearchTerm_searchTerm(`page`, `searchTerm`))}
        public static func getLoadedCourseDetails(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getLoadedCourseDetails__courseID_courseID(`courseID`))}
        public static func getCourseDetails(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDetails__courseID_courseID(`courseID`))}
        public static func enrollToCourse(courseID: Parameter<String>) -> Verify { return Verify(method: .m_enrollToCourse__courseID_courseID(`courseID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func discovery(page: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_discovery__page_page(`page`), performs: perform)
        }
        public static func discoveryOffline(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_discoveryOffline, performs: perform)
        }
        public static func search(page: Parameter<Int>, searchTerm: Parameter<String>, perform: @escaping (Int, String) -> Void) -> Perform {
            return Perform(method: .m_search__page_pagesearchTerm_searchTerm(`page`, `searchTerm`), performs: perform)
        }
        public static func getLoadedCourseDetails(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getLoadedCourseDetails__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseDetails(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDetails__courseID_courseID(`courseID`), performs: perform)
        }
        public static func enrollToCourse(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_enrollToCourse__courseID_courseID(`courseID`), performs: perform)
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

