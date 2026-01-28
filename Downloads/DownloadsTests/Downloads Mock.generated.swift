// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Downloads
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - DownloadsAnalytics

open class DownloadsAnalyticsMock: DownloadsAnalytics, Mock {
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





    open func downloadCourseClicked(courseId: String, courseName: String) {
        addInvocation(.m_downloadCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_downloadCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func cancelDownloadClicked(courseId: String, courseName: String) {
        addInvocation(.m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func removeDownloadClicked(courseId: String, courseName: String) {
        addInvocation(.m_removeDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_removeDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func downloadConfirmed(courseId: String, courseName: String, downloadSize: Int64) {
        addInvocation(.m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`)))
		let perform = methodPerformValue(.m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`))) as? (String, String, Int64) -> Void
		perform?(`courseId`, `courseName`, `downloadSize`)
    }

    open func downloadCancelled(courseId: String, courseName: String) {
        addInvocation(.m_downloadCancelled__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_downloadCancelled__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func downloadRemoved(courseId: String, courseName: String, downloadSize: Int64) {
        addInvocation(.m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`)))
		let perform = methodPerformValue(.m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`))) as? (String, String, Int64) -> Void
		perform?(`courseId`, `courseName`, `downloadSize`)
    }

    open func downloadError(courseId: String, courseName: String, errorType: String) {
        addInvocation(.m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`errorType`)))
		let perform = methodPerformValue(.m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`errorType`))) as? (String, String, String) -> Void
		perform?(`courseId`, `courseName`, `errorType`)
    }

    open func downloadCompleted(courseId: String, courseName: String, downloadSize: Int64) {
        addInvocation(.m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`)))
		let perform = methodPerformValue(.m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`))) as? (String, String, Int64) -> Void
		perform?(`courseId`, `courseName`, `downloadSize`)
    }

    open func downloadStarted(courseId: String, courseName: String, downloadSize: Int64) {
        addInvocation(.m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`)))
		let perform = methodPerformValue(.m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<Int64>.value(`downloadSize`))) as? (String, String, Int64) -> Void
		perform?(`courseId`, `courseName`, `downloadSize`)
    }

    open func downloadsScreenViewed() {
        addInvocation(.m_downloadsScreenViewed)
		let perform = methodPerformValue(.m_downloadsScreenViewed) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_downloadCourseClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_removeDownloadClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>, Parameter<String>, Parameter<Int64>)
        case m_downloadCancelled__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>, Parameter<String>, Parameter<Int64>)
        case m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>, Parameter<String>, Parameter<Int64>)
        case m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(Parameter<String>, Parameter<String>, Parameter<Int64>)
        case m_downloadsScreenViewed

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_downloadCourseClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_downloadCourseClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_removeDownloadClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_removeDownloadClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let lhsCourseid, let lhsCoursename, let lhsDownloadsize), .m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let rhsCourseid, let rhsCoursename, let rhsDownloadsize)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadsize, rhs: rhsDownloadsize, with: matcher), lhsDownloadsize, rhsDownloadsize, "downloadSize"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadCancelled__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_downloadCancelled__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let lhsCourseid, let lhsCoursename, let lhsDownloadsize), .m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let rhsCourseid, let rhsCoursename, let rhsDownloadsize)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadsize, rhs: rhsDownloadsize, with: matcher), lhsDownloadsize, rhsDownloadsize, "downloadSize"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(let lhsCourseid, let lhsCoursename, let lhsErrortype), .m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(let rhsCourseid, let rhsCoursename, let rhsErrortype)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsErrortype, rhs: rhsErrortype, with: matcher), lhsErrortype, rhsErrortype, "errorType"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let lhsCourseid, let lhsCoursename, let lhsDownloadsize), .m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let rhsCourseid, let rhsCoursename, let rhsDownloadsize)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadsize, rhs: rhsDownloadsize, with: matcher), lhsDownloadsize, rhsDownloadsize, "downloadSize"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let lhsCourseid, let lhsCoursename, let lhsDownloadsize), .m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(let rhsCourseid, let rhsCoursename, let rhsDownloadsize)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadsize, rhs: rhsDownloadsize, with: matcher), lhsDownloadsize, rhsDownloadsize, "downloadSize"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadsScreenViewed, .m_downloadsScreenViewed): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_downloadCourseClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_removeDownloadClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_downloadCancelled__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_downloadsScreenViewed: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_downloadCourseClicked__courseId_courseIdcourseName_courseName: return ".downloadCourseClicked(courseId:courseName:)"
            case .m_cancelDownloadClicked__courseId_courseIdcourseName_courseName: return ".cancelDownloadClicked(courseId:courseName:)"
            case .m_removeDownloadClicked__courseId_courseIdcourseName_courseName: return ".removeDownloadClicked(courseId:courseName:)"
            case .m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize: return ".downloadConfirmed(courseId:courseName:downloadSize:)"
            case .m_downloadCancelled__courseId_courseIdcourseName_courseName: return ".downloadCancelled(courseId:courseName:)"
            case .m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize: return ".downloadRemoved(courseId:courseName:downloadSize:)"
            case .m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType: return ".downloadError(courseId:courseName:errorType:)"
            case .m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize: return ".downloadCompleted(courseId:courseName:downloadSize:)"
            case .m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize: return ".downloadStarted(courseId:courseName:downloadSize:)"
            case .m_downloadsScreenViewed: return ".downloadsScreenViewed()"
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

        public static func downloadCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_downloadCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func cancelDownloadClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func removeDownloadClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_removeDownloadClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func downloadConfirmed(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>) -> Verify { return Verify(method: .m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`))}
        public static func downloadCancelled(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_downloadCancelled__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func downloadRemoved(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>) -> Verify { return Verify(method: .m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`))}
        public static func downloadError(courseId: Parameter<String>, courseName: Parameter<String>, errorType: Parameter<String>) -> Verify { return Verify(method: .m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(`courseId`, `courseName`, `errorType`))}
        public static func downloadCompleted(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>) -> Verify { return Verify(method: .m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`))}
        public static func downloadStarted(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>) -> Verify { return Verify(method: .m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`))}
        public static func downloadsScreenViewed() -> Verify { return Verify(method: .m_downloadsScreenViewed)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func downloadCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_downloadCourseClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func cancelDownloadClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_cancelDownloadClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func removeDownloadClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_removeDownloadClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func downloadConfirmed(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>, perform: @escaping (String, String, Int64) -> Void) -> Perform {
            return Perform(method: .m_downloadConfirmed__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`), performs: perform)
        }
        public static func downloadCancelled(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_downloadCancelled__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func downloadRemoved(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>, perform: @escaping (String, String, Int64) -> Void) -> Perform {
            return Perform(method: .m_downloadRemoved__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`), performs: perform)
        }
        public static func downloadError(courseId: Parameter<String>, courseName: Parameter<String>, errorType: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_downloadError__courseId_courseIdcourseName_courseNameerrorType_errorType(`courseId`, `courseName`, `errorType`), performs: perform)
        }
        public static func downloadCompleted(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>, perform: @escaping (String, String, Int64) -> Void) -> Perform {
            return Perform(method: .m_downloadCompleted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`), performs: perform)
        }
        public static func downloadStarted(courseId: Parameter<String>, courseName: Parameter<String>, downloadSize: Parameter<Int64>, perform: @escaping (String, String, Int64) -> Void) -> Perform {
            return Perform(method: .m_downloadStarted__courseId_courseIdcourseName_courseNamedownloadSize_downloadSize(`courseId`, `courseName`, `downloadSize`), performs: perform)
        }
        public static func downloadsScreenViewed(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_downloadsScreenViewed, performs: perform)
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

// MARK: - DownloadsHelperProtocol

open class DownloadsHelperProtocolMock: DownloadsHelperProtocol, Mock {
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





    open func calculateDownloadProgress(courseID: String) -> (downloaded: Int, total: Int) {
        addInvocation(.m_calculateDownloadProgress__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_calculateDownloadProgress__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: (downloaded: Int, total: Int)
		do {
		    __value = try methodReturnValue(.m_calculateDownloadProgress__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for calculateDownloadProgress(courseID: String). Use given")
			Failure("Stub return value not specified for calculateDownloadProgress(courseID: String). Use given")
		}
		return __value
    }

    open func isDownloading(courseID: String) -> Bool {
        addInvocation(.m_isDownloading__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_isDownloading__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isDownloading__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isDownloading(courseID: String). Use given")
			Failure("Stub return value not specified for isDownloading(courseID: String). Use given")
		}
		return __value
    }

    open func isFullyDownloaded(courseID: String) -> Bool {
        addInvocation(.m_isFullyDownloaded__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_isFullyDownloaded__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isFullyDownloaded__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isFullyDownloaded(courseID: String). Use given")
			Failure("Stub return value not specified for isFullyDownloaded(courseID: String). Use given")
		}
		return __value
    }

    open func getDownloadTasksForCourse(courseID: String) -> [DownloadDataTask] {
        addInvocation(.m_getDownloadTasksForCourse__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getDownloadTasksForCourse__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: [DownloadDataTask]
		do {
		    __value = try methodReturnValue(.m_getDownloadTasksForCourse__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getDownloadTasksForCourse(courseID: String). Use given")
			Failure("Stub return value not specified for getDownloadTasksForCourse(courseID: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_calculateDownloadProgress__courseID_courseID(Parameter<String>)
        case m_isDownloading__courseID_courseID(Parameter<String>)
        case m_isFullyDownloaded__courseID_courseID(Parameter<String>)
        case m_getDownloadTasksForCourse__courseID_courseID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_calculateDownloadProgress__courseID_courseID(let lhsCourseid), .m_calculateDownloadProgress__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_isDownloading__courseID_courseID(let lhsCourseid), .m_isDownloading__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_isFullyDownloaded__courseID_courseID(let lhsCourseid), .m_isFullyDownloaded__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getDownloadTasksForCourse__courseID_courseID(let lhsCourseid), .m_getDownloadTasksForCourse__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_calculateDownloadProgress__courseID_courseID(p0): return p0.intValue
            case let .m_isDownloading__courseID_courseID(p0): return p0.intValue
            case let .m_isFullyDownloaded__courseID_courseID(p0): return p0.intValue
            case let .m_getDownloadTasksForCourse__courseID_courseID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_calculateDownloadProgress__courseID_courseID: return ".calculateDownloadProgress(courseID:)"
            case .m_isDownloading__courseID_courseID: return ".isDownloading(courseID:)"
            case .m_isFullyDownloaded__courseID_courseID: return ".isFullyDownloaded(courseID:)"
            case .m_getDownloadTasksForCourse__courseID_courseID: return ".getDownloadTasksForCourse(courseID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func calculateDownloadProgress(courseID: Parameter<String>, willReturn: (downloaded: Int, total: Int)...) -> MethodStub {
            return Given(method: .m_calculateDownloadProgress__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isDownloading(courseID: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isDownloading__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isFullyDownloaded(courseID: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isFullyDownloaded__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadTasksForCourse(courseID: Parameter<String>, willReturn: [DownloadDataTask]...) -> MethodStub {
            return Given(method: .m_getDownloadTasksForCourse__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func calculateDownloadProgress(courseID: Parameter<String>, willProduce: (Stubber<(downloaded: Int, total: Int)>) -> Void) -> MethodStub {
            let willReturn: [(downloaded: Int, total: Int)] = []
			let given: Given = { return Given(method: .m_calculateDownloadProgress__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ((downloaded: Int, total: Int)).self)
			willProduce(stubber)
			return given
        }
        public static func isDownloading(courseID: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isDownloading__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func isFullyDownloaded(courseID: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isFullyDownloaded__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func getDownloadTasksForCourse(courseID: Parameter<String>, willProduce: (Stubber<[DownloadDataTask]>) -> Void) -> MethodStub {
            let willReturn: [[DownloadDataTask]] = []
			let given: Given = { return Given(method: .m_getDownloadTasksForCourse__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DownloadDataTask]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func calculateDownloadProgress(courseID: Parameter<String>) -> Verify { return Verify(method: .m_calculateDownloadProgress__courseID_courseID(`courseID`))}
        public static func isDownloading(courseID: Parameter<String>) -> Verify { return Verify(method: .m_isDownloading__courseID_courseID(`courseID`))}
        public static func isFullyDownloaded(courseID: Parameter<String>) -> Verify { return Verify(method: .m_isFullyDownloaded__courseID_courseID(`courseID`))}
        public static func getDownloadTasksForCourse(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getDownloadTasksForCourse__courseID_courseID(`courseID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func calculateDownloadProgress(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_calculateDownloadProgress__courseID_courseID(`courseID`), performs: perform)
        }
        public static func isDownloading(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isDownloading__courseID_courseID(`courseID`), performs: perform)
        }
        public static func isFullyDownloaded(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_isFullyDownloaded__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getDownloadTasksForCourse(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getDownloadTasksForCourse__courseID_courseID(`courseID`), performs: perform)
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

// MARK: - DownloadsInteractorProtocol

open class DownloadsInteractorProtocolMock: DownloadsInteractorProtocol, Mock {
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





    open func getDownloadCourses() throws -> [DownloadCoursePreview] {
        addInvocation(.m_getDownloadCourses)
		let perform = methodPerformValue(.m_getDownloadCourses) as? () -> Void
		perform?()
		var __value: [DownloadCoursePreview]
		do {
		    __value = try methodReturnValue(.m_getDownloadCourses).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getDownloadCourses(). Use given")
			Failure("Stub return value not specified for getDownloadCourses(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getDownloadCoursesOffline() throws -> [DownloadCoursePreview] {
        addInvocation(.m_getDownloadCoursesOffline)
		let perform = methodPerformValue(.m_getDownloadCoursesOffline) as? () -> Void
		perform?()
		var __value: [DownloadCoursePreview]
		do {
		    __value = try methodReturnValue(.m_getDownloadCoursesOffline).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getDownloadCoursesOffline(). Use given")
			Failure("Stub return value not specified for getDownloadCoursesOffline(). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getDownloadCourses
        case m_getDownloadCoursesOffline

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getDownloadCourses, .m_getDownloadCourses): return .match

            case (.m_getDownloadCoursesOffline, .m_getDownloadCoursesOffline): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_getDownloadCourses: return 0
            case .m_getDownloadCoursesOffline: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getDownloadCourses: return ".getDownloadCourses()"
            case .m_getDownloadCoursesOffline: return ".getDownloadCoursesOffline()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getDownloadCourses(willReturn: [DownloadCoursePreview]...) -> MethodStub {
            return Given(method: .m_getDownloadCourses, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadCoursesOffline(willReturn: [DownloadCoursePreview]...) -> MethodStub {
            return Given(method: .m_getDownloadCoursesOffline, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadCourses(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getDownloadCourses, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getDownloadCourses(willProduce: (StubberThrows<[DownloadCoursePreview]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getDownloadCourses, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([DownloadCoursePreview]).self)
			willProduce(stubber)
			return given
        }
        public static func getDownloadCoursesOffline(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getDownloadCoursesOffline, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getDownloadCoursesOffline(willProduce: (StubberThrows<[DownloadCoursePreview]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getDownloadCoursesOffline, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([DownloadCoursePreview]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getDownloadCourses() -> Verify { return Verify(method: .m_getDownloadCourses)}
        public static func getDownloadCoursesOffline() -> Verify { return Verify(method: .m_getDownloadCoursesOffline)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getDownloadCourses(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getDownloadCourses, performs: perform)
        }
        public static func getDownloadCoursesOffline(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getDownloadCoursesOffline, performs: perform)
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

