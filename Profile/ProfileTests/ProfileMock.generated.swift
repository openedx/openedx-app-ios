// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Profile
import Foundation
import SwiftUI
import Combine
import OEXFoundation


// MARK: - ProfileAnalytics

open class ProfileAnalyticsMock: ProfileAnalytics, Mock {
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





    open func profileEditClicked() {
        addInvocation(.m_profileEditClicked)
		let perform = methodPerformValue(.m_profileEditClicked) as? () -> Void
		perform?()
    }

    open func profileSwitch(action: String) {
        addInvocation(.m_profileSwitch__action_action(Parameter<String>.value(`action`)))
		let perform = methodPerformValue(.m_profileSwitch__action_action(Parameter<String>.value(`action`))) as? (String) -> Void
		perform?(`action`)
    }

    open func profileEditDoneClicked() {
        addInvocation(.m_profileEditDoneClicked)
		let perform = methodPerformValue(.m_profileEditDoneClicked) as? () -> Void
		perform?()
    }

    open func profileDeleteAccountClicked() {
        addInvocation(.m_profileDeleteAccountClicked)
		let perform = methodPerformValue(.m_profileDeleteAccountClicked) as? () -> Void
		perform?()
    }

    open func profileVideoSettingsClicked() {
        addInvocation(.m_profileVideoSettingsClicked)
		let perform = methodPerformValue(.m_profileVideoSettingsClicked) as? () -> Void
		perform?()
    }

    open func privacyPolicyClicked() {
        addInvocation(.m_privacyPolicyClicked)
		let perform = methodPerformValue(.m_privacyPolicyClicked) as? () -> Void
		perform?()
    }

    open func cookiePolicyClicked() {
        addInvocation(.m_cookiePolicyClicked)
		let perform = methodPerformValue(.m_cookiePolicyClicked) as? () -> Void
		perform?()
    }

    open func emailSupportClicked() {
        addInvocation(.m_emailSupportClicked)
		let perform = methodPerformValue(.m_emailSupportClicked) as? () -> Void
		perform?()
    }

    open func faqClicked() {
        addInvocation(.m_faqClicked)
		let perform = methodPerformValue(.m_faqClicked) as? () -> Void
		perform?()
    }

    open func tosClicked() {
        addInvocation(.m_tosClicked)
		let perform = methodPerformValue(.m_tosClicked) as? () -> Void
		perform?()
    }

    open func dataSellClicked() {
        addInvocation(.m_dataSellClicked)
		let perform = methodPerformValue(.m_dataSellClicked) as? () -> Void
		perform?()
    }

    open func userLogout(force: Bool) {
        addInvocation(.m_userLogout__force_force(Parameter<Bool>.value(`force`)))
		let perform = methodPerformValue(.m_userLogout__force_force(Parameter<Bool>.value(`force`))) as? (Bool) -> Void
		perform?(`force`)
    }

    open func profileWifiToggle(action: String) {
        addInvocation(.m_profileWifiToggle__action_action(Parameter<String>.value(`action`)))
		let perform = methodPerformValue(.m_profileWifiToggle__action_action(Parameter<String>.value(`action`))) as? (String) -> Void
		perform?(`action`)
    }

    open func profileUserDeleteAccountClicked() {
        addInvocation(.m_profileUserDeleteAccountClicked)
		let perform = methodPerformValue(.m_profileUserDeleteAccountClicked) as? () -> Void
		perform?()
    }

    open func profileDeleteAccountSuccess(success: Bool) {
        addInvocation(.m_profileDeleteAccountSuccess__success_success(Parameter<Bool>.value(`success`)))
		let perform = methodPerformValue(.m_profileDeleteAccountSuccess__success_success(Parameter<Bool>.value(`success`))) as? (Bool) -> Void
		perform?(`success`)
    }

    open func profileTrackEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_profileTrackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_profileTrackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }

    open func profileScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_profileScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_profileScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }


    fileprivate enum MethodType {
        case m_profileEditClicked
        case m_profileSwitch__action_action(Parameter<String>)
        case m_profileEditDoneClicked
        case m_profileDeleteAccountClicked
        case m_profileVideoSettingsClicked
        case m_privacyPolicyClicked
        case m_cookiePolicyClicked
        case m_emailSupportClicked
        case m_faqClicked
        case m_tosClicked
        case m_dataSellClicked
        case m_userLogout__force_force(Parameter<Bool>)
        case m_profileWifiToggle__action_action(Parameter<String>)
        case m_profileUserDeleteAccountClicked
        case m_profileDeleteAccountSuccess__success_success(Parameter<Bool>)
        case m_profileTrackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)
        case m_profileScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_profileEditClicked, .m_profileEditClicked): return .match

            case (.m_profileSwitch__action_action(let lhsAction), .m_profileSwitch__action_action(let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_profileEditDoneClicked, .m_profileEditDoneClicked): return .match

            case (.m_profileDeleteAccountClicked, .m_profileDeleteAccountClicked): return .match

            case (.m_profileVideoSettingsClicked, .m_profileVideoSettingsClicked): return .match

            case (.m_privacyPolicyClicked, .m_privacyPolicyClicked): return .match

            case (.m_cookiePolicyClicked, .m_cookiePolicyClicked): return .match

            case (.m_emailSupportClicked, .m_emailSupportClicked): return .match

            case (.m_faqClicked, .m_faqClicked): return .match

            case (.m_tosClicked, .m_tosClicked): return .match

            case (.m_dataSellClicked, .m_dataSellClicked): return .match

            case (.m_userLogout__force_force(let lhsForce), .m_userLogout__force_force(let rhsForce)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsForce, rhs: rhsForce, with: matcher), lhsForce, rhsForce, "force"))
				return Matcher.ComparisonResult(results)

            case (.m_profileWifiToggle__action_action(let lhsAction), .m_profileWifiToggle__action_action(let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_profileUserDeleteAccountClicked, .m_profileUserDeleteAccountClicked): return .match

            case (.m_profileDeleteAccountSuccess__success_success(let lhsSuccess), .m_profileDeleteAccountSuccess__success_success(let rhsSuccess)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSuccess, rhs: rhsSuccess, with: matcher), lhsSuccess, rhsSuccess, "success"))
				return Matcher.ComparisonResult(results)

            case (.m_profileTrackEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_profileTrackEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)

            case (.m_profileScreenEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_profileScreenEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_profileEditClicked: return 0
            case let .m_profileSwitch__action_action(p0): return p0.intValue
            case .m_profileEditDoneClicked: return 0
            case .m_profileDeleteAccountClicked: return 0
            case .m_profileVideoSettingsClicked: return 0
            case .m_privacyPolicyClicked: return 0
            case .m_cookiePolicyClicked: return 0
            case .m_emailSupportClicked: return 0
            case .m_faqClicked: return 0
            case .m_tosClicked: return 0
            case .m_dataSellClicked: return 0
            case let .m_userLogout__force_force(p0): return p0.intValue
            case let .m_profileWifiToggle__action_action(p0): return p0.intValue
            case .m_profileUserDeleteAccountClicked: return 0
            case let .m_profileDeleteAccountSuccess__success_success(p0): return p0.intValue
            case let .m_profileTrackEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            case let .m_profileScreenEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_profileEditClicked: return ".profileEditClicked()"
            case .m_profileSwitch__action_action: return ".profileSwitch(action:)"
            case .m_profileEditDoneClicked: return ".profileEditDoneClicked()"
            case .m_profileDeleteAccountClicked: return ".profileDeleteAccountClicked()"
            case .m_profileVideoSettingsClicked: return ".profileVideoSettingsClicked()"
            case .m_privacyPolicyClicked: return ".privacyPolicyClicked()"
            case .m_cookiePolicyClicked: return ".cookiePolicyClicked()"
            case .m_emailSupportClicked: return ".emailSupportClicked()"
            case .m_faqClicked: return ".faqClicked()"
            case .m_tosClicked: return ".tosClicked()"
            case .m_dataSellClicked: return ".dataSellClicked()"
            case .m_userLogout__force_force: return ".userLogout(force:)"
            case .m_profileWifiToggle__action_action: return ".profileWifiToggle(action:)"
            case .m_profileUserDeleteAccountClicked: return ".profileUserDeleteAccountClicked()"
            case .m_profileDeleteAccountSuccess__success_success: return ".profileDeleteAccountSuccess(success:)"
            case .m_profileTrackEvent__eventbiValue_biValue: return ".profileTrackEvent(_:biValue:)"
            case .m_profileScreenEvent__eventbiValue_biValue: return ".profileScreenEvent(_:biValue:)"
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

        public static func profileEditClicked() -> Verify { return Verify(method: .m_profileEditClicked)}
        public static func profileSwitch(action: Parameter<String>) -> Verify { return Verify(method: .m_profileSwitch__action_action(`action`))}
        public static func profileEditDoneClicked() -> Verify { return Verify(method: .m_profileEditDoneClicked)}
        public static func profileDeleteAccountClicked() -> Verify { return Verify(method: .m_profileDeleteAccountClicked)}
        public static func profileVideoSettingsClicked() -> Verify { return Verify(method: .m_profileVideoSettingsClicked)}
        public static func privacyPolicyClicked() -> Verify { return Verify(method: .m_privacyPolicyClicked)}
        public static func cookiePolicyClicked() -> Verify { return Verify(method: .m_cookiePolicyClicked)}
        public static func emailSupportClicked() -> Verify { return Verify(method: .m_emailSupportClicked)}
        public static func faqClicked() -> Verify { return Verify(method: .m_faqClicked)}
        public static func tosClicked() -> Verify { return Verify(method: .m_tosClicked)}
        public static func dataSellClicked() -> Verify { return Verify(method: .m_dataSellClicked)}
        public static func userLogout(force: Parameter<Bool>) -> Verify { return Verify(method: .m_userLogout__force_force(`force`))}
        public static func profileWifiToggle(action: Parameter<String>) -> Verify { return Verify(method: .m_profileWifiToggle__action_action(`action`))}
        public static func profileUserDeleteAccountClicked() -> Verify { return Verify(method: .m_profileUserDeleteAccountClicked)}
        public static func profileDeleteAccountSuccess(success: Parameter<Bool>) -> Verify { return Verify(method: .m_profileDeleteAccountSuccess__success_success(`success`))}
        public static func profileTrackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_profileTrackEvent__eventbiValue_biValue(`event`, `biValue`))}
        public static func profileScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_profileScreenEvent__eventbiValue_biValue(`event`, `biValue`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func profileEditClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_profileEditClicked, performs: perform)
        }
        public static func profileSwitch(action: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_profileSwitch__action_action(`action`), performs: perform)
        }
        public static func profileEditDoneClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_profileEditDoneClicked, performs: perform)
        }
        public static func profileDeleteAccountClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_profileDeleteAccountClicked, performs: perform)
        }
        public static func profileVideoSettingsClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_profileVideoSettingsClicked, performs: perform)
        }
        public static func privacyPolicyClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_privacyPolicyClicked, performs: perform)
        }
        public static func cookiePolicyClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cookiePolicyClicked, performs: perform)
        }
        public static func emailSupportClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_emailSupportClicked, performs: perform)
        }
        public static func faqClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_faqClicked, performs: perform)
        }
        public static func tosClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_tosClicked, performs: perform)
        }
        public static func dataSellClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_dataSellClicked, performs: perform)
        }
        public static func userLogout(force: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_userLogout__force_force(`force`), performs: perform)
        }
        public static func profileWifiToggle(action: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_profileWifiToggle__action_action(`action`), performs: perform)
        }
        public static func profileUserDeleteAccountClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_profileUserDeleteAccountClicked, performs: perform)
        }
        public static func profileDeleteAccountSuccess(success: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_profileDeleteAccountSuccess__success_success(`success`), performs: perform)
        }
        public static func profileTrackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_profileTrackEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
        }
        public static func profileScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_profileScreenEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
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

// MARK: - ProfileInteractorProtocol

open class ProfileInteractorProtocolMock: ProfileInteractorProtocol, Mock {
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





    open func getUserProfile(username: String) throws -> UserProfile {
        addInvocation(.m_getUserProfile__username_username(Parameter<String>.value(`username`)))
		let perform = methodPerformValue(.m_getUserProfile__username_username(Parameter<String>.value(`username`))) as? (String) -> Void
		perform?(`username`)
		var __value: UserProfile
		do {
		    __value = try methodReturnValue(.m_getUserProfile__username_username(Parameter<String>.value(`username`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getUserProfile(username: String). Use given")
			Failure("Stub return value not specified for getUserProfile(username: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMyProfile() throws -> UserProfile {
        addInvocation(.m_getMyProfile)
		let perform = methodPerformValue(.m_getMyProfile) as? () -> Void
		perform?()
		var __value: UserProfile
		do {
		    __value = try methodReturnValue(.m_getMyProfile).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getMyProfile(). Use given")
			Failure("Stub return value not specified for getMyProfile(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getMyProfileOffline() -> UserProfile? {
        addInvocation(.m_getMyProfileOffline)
		let perform = methodPerformValue(.m_getMyProfileOffline) as? () -> Void
		perform?()
		var __value: UserProfile? = nil
		do {
		    __value = try methodReturnValue(.m_getMyProfileOffline).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func logOut() throws {
        addInvocation(.m_logOut)
		let perform = methodPerformValue(.m_logOut) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_logOut).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func getSpokenLanguages() -> [PickerFields.Option] {
        addInvocation(.m_getSpokenLanguages)
		let perform = methodPerformValue(.m_getSpokenLanguages) as? () -> Void
		perform?()
		var __value: [PickerFields.Option]
		do {
		    __value = try methodReturnValue(.m_getSpokenLanguages).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getSpokenLanguages(). Use given")
			Failure("Stub return value not specified for getSpokenLanguages(). Use given")
		}
		return __value
    }

    open func getCountries() -> [PickerFields.Option] {
        addInvocation(.m_getCountries)
		let perform = methodPerformValue(.m_getCountries) as? () -> Void
		perform?()
		var __value: [PickerFields.Option]
		do {
		    __value = try methodReturnValue(.m_getCountries).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getCountries(). Use given")
			Failure("Stub return value not specified for getCountries(). Use given")
		}
		return __value
    }

    open func uploadProfilePicture(pictureData: Data) throws {
        addInvocation(.m_uploadProfilePicture__pictureData_pictureData(Parameter<Data>.value(`pictureData`)))
		let perform = methodPerformValue(.m_uploadProfilePicture__pictureData_pictureData(Parameter<Data>.value(`pictureData`))) as? (Data) -> Void
		perform?(`pictureData`)
		do {
		    _ = try methodReturnValue(.m_uploadProfilePicture__pictureData_pictureData(Parameter<Data>.value(`pictureData`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteProfilePicture() throws -> Bool {
        addInvocation(.m_deleteProfilePicture)
		let perform = methodPerformValue(.m_deleteProfilePicture) as? () -> Void
		perform?()
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_deleteProfilePicture).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for deleteProfilePicture(). Use given")
			Failure("Stub return value not specified for deleteProfilePicture(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func updateUserProfile(parameters: [String: any Any & Sendable]) throws -> UserProfile {
        addInvocation(.m_updateUserProfile__parameters_parameters(Parameter<[String: any Any & Sendable]>.value(`parameters`)))
		let perform = methodPerformValue(.m_updateUserProfile__parameters_parameters(Parameter<[String: any Any & Sendable]>.value(`parameters`))) as? ([String: any Any & Sendable]) -> Void
		perform?(`parameters`)
		var __value: UserProfile
		do {
		    __value = try methodReturnValue(.m_updateUserProfile__parameters_parameters(Parameter<[String: any Any & Sendable]>.value(`parameters`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for updateUserProfile(parameters: [String: any Any & Sendable]). Use given")
			Failure("Stub return value not specified for updateUserProfile(parameters: [String: any Any & Sendable]). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func deleteAccount(password: String) throws -> Bool {
        addInvocation(.m_deleteAccount__password_password(Parameter<String>.value(`password`)))
		let perform = methodPerformValue(.m_deleteAccount__password_password(Parameter<String>.value(`password`))) as? (String) -> Void
		perform?(`password`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_deleteAccount__password_password(Parameter<String>.value(`password`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for deleteAccount(password: String). Use given")
			Failure("Stub return value not specified for deleteAccount(password: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getSettings() -> UserSettings {
        addInvocation(.m_getSettings)
		let perform = methodPerformValue(.m_getSettings) as? () -> Void
		perform?()
		var __value: UserSettings
		do {
		    __value = try methodReturnValue(.m_getSettings).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getSettings(). Use given")
			Failure("Stub return value not specified for getSettings(). Use given")
		}
		return __value
    }

    open func saveSettings(_ settings: UserSettings) {
        addInvocation(.m_saveSettings__settings(Parameter<UserSettings>.value(`settings`)))
		let perform = methodPerformValue(.m_saveSettings__settings(Parameter<UserSettings>.value(`settings`))) as? (UserSettings) -> Void
		perform?(`settings`)
    }

    open func enrollmentsStatus() throws -> [CourseForSync] {
        addInvocation(.m_enrollmentsStatus)
		let perform = methodPerformValue(.m_enrollmentsStatus) as? () -> Void
		perform?()
		var __value: [CourseForSync]
		do {
		    __value = try methodReturnValue(.m_enrollmentsStatus).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for enrollmentsStatus(). Use given")
			Failure("Stub return value not specified for enrollmentsStatus(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseDates(courseID: String) throws -> CourseDates {
        addInvocation(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDates
		do {
		    __value = try methodReturnValue(.m_getCourseDates__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDates(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDates(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getUserProfile__username_username(Parameter<String>)
        case m_getMyProfile
        case m_getMyProfileOffline
        case m_logOut
        case m_getSpokenLanguages
        case m_getCountries
        case m_uploadProfilePicture__pictureData_pictureData(Parameter<Data>)
        case m_deleteProfilePicture
        case m_updateUserProfile__parameters_parameters(Parameter<[String: any Any & Sendable]>)
        case m_deleteAccount__password_password(Parameter<String>)
        case m_getSettings
        case m_saveSettings__settings(Parameter<UserSettings>)
        case m_enrollmentsStatus
        case m_getCourseDates__courseID_courseID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getUserProfile__username_username(let lhsUsername), .m_getUserProfile__username_username(let rhsUsername)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				return Matcher.ComparisonResult(results)

            case (.m_getMyProfile, .m_getMyProfile): return .match

            case (.m_getMyProfileOffline, .m_getMyProfileOffline): return .match

            case (.m_logOut, .m_logOut): return .match

            case (.m_getSpokenLanguages, .m_getSpokenLanguages): return .match

            case (.m_getCountries, .m_getCountries): return .match

            case (.m_uploadProfilePicture__pictureData_pictureData(let lhsPicturedata), .m_uploadProfilePicture__pictureData_pictureData(let rhsPicturedata)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPicturedata, rhs: rhsPicturedata, with: matcher), lhsPicturedata, rhsPicturedata, "pictureData"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteProfilePicture, .m_deleteProfilePicture): return .match

            case (.m_updateUserProfile__parameters_parameters(let lhsParameters), .m_updateUserProfile__parameters_parameters(let rhsParameters)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher), lhsParameters, rhsParameters, "parameters"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteAccount__password_password(let lhsPassword), .m_deleteAccount__password_password(let rhsPassword)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPassword, rhs: rhsPassword, with: matcher), lhsPassword, rhsPassword, "password"))
				return Matcher.ComparisonResult(results)

            case (.m_getSettings, .m_getSettings): return .match

            case (.m_saveSettings__settings(let lhsSettings), .m_saveSettings__settings(let rhsSettings)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSettings, rhs: rhsSettings, with: matcher), lhsSettings, rhsSettings, "_ settings"))
				return Matcher.ComparisonResult(results)

            case (.m_enrollmentsStatus, .m_enrollmentsStatus): return .match

            case (.m_getCourseDates__courseID_courseID(let lhsCourseid), .m_getCourseDates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getUserProfile__username_username(p0): return p0.intValue
            case .m_getMyProfile: return 0
            case .m_getMyProfileOffline: return 0
            case .m_logOut: return 0
            case .m_getSpokenLanguages: return 0
            case .m_getCountries: return 0
            case let .m_uploadProfilePicture__pictureData_pictureData(p0): return p0.intValue
            case .m_deleteProfilePicture: return 0
            case let .m_updateUserProfile__parameters_parameters(p0): return p0.intValue
            case let .m_deleteAccount__password_password(p0): return p0.intValue
            case .m_getSettings: return 0
            case let .m_saveSettings__settings(p0): return p0.intValue
            case .m_enrollmentsStatus: return 0
            case let .m_getCourseDates__courseID_courseID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getUserProfile__username_username: return ".getUserProfile(username:)"
            case .m_getMyProfile: return ".getMyProfile()"
            case .m_getMyProfileOffline: return ".getMyProfileOffline()"
            case .m_logOut: return ".logOut()"
            case .m_getSpokenLanguages: return ".getSpokenLanguages()"
            case .m_getCountries: return ".getCountries()"
            case .m_uploadProfilePicture__pictureData_pictureData: return ".uploadProfilePicture(pictureData:)"
            case .m_deleteProfilePicture: return ".deleteProfilePicture()"
            case .m_updateUserProfile__parameters_parameters: return ".updateUserProfile(parameters:)"
            case .m_deleteAccount__password_password: return ".deleteAccount(password:)"
            case .m_getSettings: return ".getSettings()"
            case .m_saveSettings__settings: return ".saveSettings(_:)"
            case .m_enrollmentsStatus: return ".enrollmentsStatus()"
            case .m_getCourseDates__courseID_courseID: return ".getCourseDates(courseID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getUserProfile(username: Parameter<String>, willReturn: UserProfile...) -> MethodStub {
            return Given(method: .m_getUserProfile__username_username(`username`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMyProfile(willReturn: UserProfile...) -> MethodStub {
            return Given(method: .m_getMyProfile, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMyProfileOffline(willReturn: UserProfile?...) -> MethodStub {
            return Given(method: .m_getMyProfileOffline, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSpokenLanguages(willReturn: [PickerFields.Option]...) -> MethodStub {
            return Given(method: .m_getSpokenLanguages, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCountries(willReturn: [PickerFields.Option]...) -> MethodStub {
            return Given(method: .m_getCountries, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func deleteProfilePicture(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_deleteProfilePicture, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func updateUserProfile(parameters: Parameter<[String: any Any & Sendable]>, willReturn: UserProfile...) -> MethodStub {
            return Given(method: .m_updateUserProfile__parameters_parameters(`parameters`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func deleteAccount(password: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_deleteAccount__password_password(`password`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSettings(willReturn: UserSettings...) -> MethodStub {
            return Given(method: .m_getSettings, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func enrollmentsStatus(willReturn: [CourseForSync]...) -> MethodStub {
            return Given(method: .m_enrollmentsStatus, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDates(courseID: Parameter<String>, willReturn: CourseDates...) -> MethodStub {
            return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getMyProfileOffline(willProduce: (Stubber<UserProfile?>) -> Void) -> MethodStub {
            let willReturn: [UserProfile?] = []
			let given: Given = { return Given(method: .m_getMyProfileOffline, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UserProfile?).self)
			willProduce(stubber)
			return given
        }
        public static func getSpokenLanguages(willProduce: (Stubber<[PickerFields.Option]>) -> Void) -> MethodStub {
            let willReturn: [[PickerFields.Option]] = []
			let given: Given = { return Given(method: .m_getSpokenLanguages, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([PickerFields.Option]).self)
			willProduce(stubber)
			return given
        }
        public static func getCountries(willProduce: (Stubber<[PickerFields.Option]>) -> Void) -> MethodStub {
            let willReturn: [[PickerFields.Option]] = []
			let given: Given = { return Given(method: .m_getCountries, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([PickerFields.Option]).self)
			willProduce(stubber)
			return given
        }
        public static func getSettings(willProduce: (Stubber<UserSettings>) -> Void) -> MethodStub {
            let willReturn: [UserSettings] = []
			let given: Given = { return Given(method: .m_getSettings, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (UserSettings).self)
			willProduce(stubber)
			return given
        }
        public static func getUserProfile(username: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getUserProfile__username_username(`username`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getUserProfile(username: Parameter<String>, willProduce: (StubberThrows<UserProfile>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getUserProfile__username_username(`username`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserProfile).self)
			willProduce(stubber)
			return given
        }
        public static func getMyProfile(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getMyProfile, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getMyProfile(willProduce: (StubberThrows<UserProfile>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getMyProfile, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserProfile).self)
			willProduce(stubber)
			return given
        }
        public static func logOut(willThrow: Error...) -> MethodStub {
            return Given(method: .m_logOut, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func logOut(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_logOut, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func uploadProfilePicture(pictureData: Parameter<Data>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_uploadProfilePicture__pictureData_pictureData(`pictureData`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func uploadProfilePicture(pictureData: Parameter<Data>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_uploadProfilePicture__pictureData_pictureData(`pictureData`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func deleteProfilePicture(willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteProfilePicture, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteProfilePicture(willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteProfilePicture, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func updateUserProfile(parameters: Parameter<[String: any Any & Sendable]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_updateUserProfile__parameters_parameters(`parameters`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func updateUserProfile(parameters: Parameter<[String: any Any & Sendable]>, willProduce: (StubberThrows<UserProfile>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_updateUserProfile__parameters_parameters(`parameters`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserProfile).self)
			willProduce(stubber)
			return given
        }
        public static func deleteAccount(password: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteAccount__password_password(`password`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteAccount(password: Parameter<String>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteAccount__password_password(`password`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func enrollmentsStatus(willThrow: Error...) -> MethodStub {
            return Given(method: .m_enrollmentsStatus, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func enrollmentsStatus(willProduce: (StubberThrows<[CourseForSync]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_enrollmentsStatus, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseForSync]).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDates(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDates>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDates).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getUserProfile(username: Parameter<String>) -> Verify { return Verify(method: .m_getUserProfile__username_username(`username`))}
        public static func getMyProfile() -> Verify { return Verify(method: .m_getMyProfile)}
        public static func getMyProfileOffline() -> Verify { return Verify(method: .m_getMyProfileOffline)}
        public static func logOut() -> Verify { return Verify(method: .m_logOut)}
        public static func getSpokenLanguages() -> Verify { return Verify(method: .m_getSpokenLanguages)}
        public static func getCountries() -> Verify { return Verify(method: .m_getCountries)}
        public static func uploadProfilePicture(pictureData: Parameter<Data>) -> Verify { return Verify(method: .m_uploadProfilePicture__pictureData_pictureData(`pictureData`))}
        public static func deleteProfilePicture() -> Verify { return Verify(method: .m_deleteProfilePicture)}
        public static func updateUserProfile(parameters: Parameter<[String: any Any & Sendable]>) -> Verify { return Verify(method: .m_updateUserProfile__parameters_parameters(`parameters`))}
        public static func deleteAccount(password: Parameter<String>) -> Verify { return Verify(method: .m_deleteAccount__password_password(`password`))}
        public static func getSettings() -> Verify { return Verify(method: .m_getSettings)}
        public static func saveSettings(_ settings: Parameter<UserSettings>) -> Verify { return Verify(method: .m_saveSettings__settings(`settings`))}
        public static func enrollmentsStatus() -> Verify { return Verify(method: .m_enrollmentsStatus)}
        public static func getCourseDates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDates__courseID_courseID(`courseID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getUserProfile(username: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getUserProfile__username_username(`username`), performs: perform)
        }
        public static func getMyProfile(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getMyProfile, performs: perform)
        }
        public static func getMyProfileOffline(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getMyProfileOffline, performs: perform)
        }
        public static func logOut(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_logOut, performs: perform)
        }
        public static func getSpokenLanguages(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getSpokenLanguages, performs: perform)
        }
        public static func getCountries(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getCountries, performs: perform)
        }
        public static func uploadProfilePicture(pictureData: Parameter<Data>, perform: @escaping (Data) -> Void) -> Perform {
            return Perform(method: .m_uploadProfilePicture__pictureData_pictureData(`pictureData`), performs: perform)
        }
        public static func deleteProfilePicture(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteProfilePicture, performs: perform)
        }
        public static func updateUserProfile(parameters: Parameter<[String: any Any & Sendable]>, perform: @escaping ([String: any Any & Sendable]) -> Void) -> Perform {
            return Perform(method: .m_updateUserProfile__parameters_parameters(`parameters`), performs: perform)
        }
        public static func deleteAccount(password: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_deleteAccount__password_password(`password`), performs: perform)
        }
        public static func getSettings(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getSettings, performs: perform)
        }
        public static func saveSettings(_ settings: Parameter<UserSettings>, perform: @escaping (UserSettings) -> Void) -> Perform {
            return Perform(method: .m_saveSettings__settings(`settings`), performs: perform)
        }
        public static func enrollmentsStatus(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_enrollmentsStatus, performs: perform)
        }
        public static func getCourseDates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDates__courseID_courseID(`courseID`), performs: perform)
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

// MARK: - ProfilePersistenceProtocol

open class ProfilePersistenceProtocolMock: ProfilePersistenceProtocol, Mock {
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





    open func getCourseState(courseID: String) -> CourseCalendarState? {
        addInvocation(.m_getCourseState__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseState__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseCalendarState? = nil
		do {
		    __value = try methodReturnValue(.m_getCourseState__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func getAllCourseStates() -> [CourseCalendarState] {
        addInvocation(.m_getAllCourseStates)
		let perform = methodPerformValue(.m_getAllCourseStates) as? () -> Void
		perform?()
		var __value: [CourseCalendarState]
		do {
		    __value = try methodReturnValue(.m_getAllCourseStates).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getAllCourseStates(). Use given")
			Failure("Stub return value not specified for getAllCourseStates(). Use given")
		}
		return __value
    }

    open func saveCourseState(state: CourseCalendarState) {
        addInvocation(.m_saveCourseState__state_state(Parameter<CourseCalendarState>.value(`state`)))
		let perform = methodPerformValue(.m_saveCourseState__state_state(Parameter<CourseCalendarState>.value(`state`))) as? (CourseCalendarState) -> Void
		perform?(`state`)
    }

    open func removeCourseState(courseID: String) {
        addInvocation(.m_removeCourseState__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_removeCourseState__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
    }

    open func deleteAllCourseStatesAndEvents() {
        addInvocation(.m_deleteAllCourseStatesAndEvents)
		let perform = methodPerformValue(.m_deleteAllCourseStatesAndEvents) as? () -> Void
		perform?()
    }

    open func saveCourseCalendarEvent(_ event: CourseCalendarEvent) {
        addInvocation(.m_saveCourseCalendarEvent__event(Parameter<CourseCalendarEvent>.value(`event`)))
		let perform = methodPerformValue(.m_saveCourseCalendarEvent__event(Parameter<CourseCalendarEvent>.value(`event`))) as? (CourseCalendarEvent) -> Void
		perform?(`event`)
    }

    open func removeCourseCalendarEvents(for courseId: String) {
        addInvocation(.m_removeCourseCalendarEvents__for_courseId(Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_removeCourseCalendarEvents__for_courseId(Parameter<String>.value(`courseId`))) as? (String) -> Void
		perform?(`courseId`)
    }

    open func removeAllCourseCalendarEvents() {
        addInvocation(.m_removeAllCourseCalendarEvents)
		let perform = methodPerformValue(.m_removeAllCourseCalendarEvents) as? () -> Void
		perform?()
    }

    open func getCourseCalendarEvents(for courseId: String) -> [CourseCalendarEvent] {
        addInvocation(.m_getCourseCalendarEvents__for_courseId(Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_getCourseCalendarEvents__for_courseId(Parameter<String>.value(`courseId`))) as? (String) -> Void
		perform?(`courseId`)
		var __value: [CourseCalendarEvent]
		do {
		    __value = try methodReturnValue(.m_getCourseCalendarEvents__for_courseId(Parameter<String>.value(`courseId`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getCourseCalendarEvents(for courseId: String). Use given")
			Failure("Stub return value not specified for getCourseCalendarEvents(for courseId: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getCourseState__courseID_courseID(Parameter<String>)
        case m_getAllCourseStates
        case m_saveCourseState__state_state(Parameter<CourseCalendarState>)
        case m_removeCourseState__courseID_courseID(Parameter<String>)
        case m_deleteAllCourseStatesAndEvents
        case m_saveCourseCalendarEvent__event(Parameter<CourseCalendarEvent>)
        case m_removeCourseCalendarEvents__for_courseId(Parameter<String>)
        case m_removeAllCourseCalendarEvents
        case m_getCourseCalendarEvents__for_courseId(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseState__courseID_courseID(let lhsCourseid), .m_getCourseState__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getAllCourseStates, .m_getAllCourseStates): return .match

            case (.m_saveCourseState__state_state(let lhsState), .m_saveCourseState__state_state(let rhsState)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsState, rhs: rhsState, with: matcher), lhsState, rhsState, "state"))
				return Matcher.ComparisonResult(results)

            case (.m_removeCourseState__courseID_courseID(let lhsCourseid), .m_removeCourseState__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteAllCourseStatesAndEvents, .m_deleteAllCourseStatesAndEvents): return .match

            case (.m_saveCourseCalendarEvent__event(let lhsEvent), .m_saveCourseCalendarEvent__event(let rhsEvent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				return Matcher.ComparisonResult(results)

            case (.m_removeCourseCalendarEvents__for_courseId(let lhsCourseid), .m_removeCourseCalendarEvents__for_courseId(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "for courseId"))
				return Matcher.ComparisonResult(results)

            case (.m_removeAllCourseCalendarEvents, .m_removeAllCourseCalendarEvents): return .match

            case (.m_getCourseCalendarEvents__for_courseId(let lhsCourseid), .m_getCourseCalendarEvents__for_courseId(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "for courseId"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseState__courseID_courseID(p0): return p0.intValue
            case .m_getAllCourseStates: return 0
            case let .m_saveCourseState__state_state(p0): return p0.intValue
            case let .m_removeCourseState__courseID_courseID(p0): return p0.intValue
            case .m_deleteAllCourseStatesAndEvents: return 0
            case let .m_saveCourseCalendarEvent__event(p0): return p0.intValue
            case let .m_removeCourseCalendarEvents__for_courseId(p0): return p0.intValue
            case .m_removeAllCourseCalendarEvents: return 0
            case let .m_getCourseCalendarEvents__for_courseId(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseState__courseID_courseID: return ".getCourseState(courseID:)"
            case .m_getAllCourseStates: return ".getAllCourseStates()"
            case .m_saveCourseState__state_state: return ".saveCourseState(state:)"
            case .m_removeCourseState__courseID_courseID: return ".removeCourseState(courseID:)"
            case .m_deleteAllCourseStatesAndEvents: return ".deleteAllCourseStatesAndEvents()"
            case .m_saveCourseCalendarEvent__event: return ".saveCourseCalendarEvent(_:)"
            case .m_removeCourseCalendarEvents__for_courseId: return ".removeCourseCalendarEvents(for:)"
            case .m_removeAllCourseCalendarEvents: return ".removeAllCourseCalendarEvents()"
            case .m_getCourseCalendarEvents__for_courseId: return ".getCourseCalendarEvents(for:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseState(courseID: Parameter<String>, willReturn: CourseCalendarState?...) -> MethodStub {
            return Given(method: .m_getCourseState__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getAllCourseStates(willReturn: [CourseCalendarState]...) -> MethodStub {
            return Given(method: .m_getAllCourseStates, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseCalendarEvents(for courseId: Parameter<String>, willReturn: [CourseCalendarEvent]...) -> MethodStub {
            return Given(method: .m_getCourseCalendarEvents__for_courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseState(courseID: Parameter<String>, willProduce: (Stubber<CourseCalendarState?>) -> Void) -> MethodStub {
            let willReturn: [CourseCalendarState?] = []
			let given: Given = { return Given(method: .m_getCourseState__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseCalendarState?).self)
			willProduce(stubber)
			return given
        }
        public static func getAllCourseStates(willProduce: (Stubber<[CourseCalendarState]>) -> Void) -> MethodStub {
            let willReturn: [[CourseCalendarState]] = []
			let given: Given = { return Given(method: .m_getAllCourseStates, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([CourseCalendarState]).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseCalendarEvents(for courseId: Parameter<String>, willProduce: (Stubber<[CourseCalendarEvent]>) -> Void) -> MethodStub {
            let willReturn: [[CourseCalendarEvent]] = []
			let given: Given = { return Given(method: .m_getCourseCalendarEvents__for_courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([CourseCalendarEvent]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseState(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseState__courseID_courseID(`courseID`))}
        public static func getAllCourseStates() -> Verify { return Verify(method: .m_getAllCourseStates)}
        public static func saveCourseState(state: Parameter<CourseCalendarState>) -> Verify { return Verify(method: .m_saveCourseState__state_state(`state`))}
        public static func removeCourseState(courseID: Parameter<String>) -> Verify { return Verify(method: .m_removeCourseState__courseID_courseID(`courseID`))}
        public static func deleteAllCourseStatesAndEvents() -> Verify { return Verify(method: .m_deleteAllCourseStatesAndEvents)}
        public static func saveCourseCalendarEvent(_ event: Parameter<CourseCalendarEvent>) -> Verify { return Verify(method: .m_saveCourseCalendarEvent__event(`event`))}
        public static func removeCourseCalendarEvents(for courseId: Parameter<String>) -> Verify { return Verify(method: .m_removeCourseCalendarEvents__for_courseId(`courseId`))}
        public static func removeAllCourseCalendarEvents() -> Verify { return Verify(method: .m_removeAllCourseCalendarEvents)}
        public static func getCourseCalendarEvents(for courseId: Parameter<String>) -> Verify { return Verify(method: .m_getCourseCalendarEvents__for_courseId(`courseId`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseState(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseState__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getAllCourseStates(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getAllCourseStates, performs: perform)
        }
        public static func saveCourseState(state: Parameter<CourseCalendarState>, perform: @escaping (CourseCalendarState) -> Void) -> Perform {
            return Perform(method: .m_saveCourseState__state_state(`state`), performs: perform)
        }
        public static func removeCourseState(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_removeCourseState__courseID_courseID(`courseID`), performs: perform)
        }
        public static func deleteAllCourseStatesAndEvents(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteAllCourseStatesAndEvents, performs: perform)
        }
        public static func saveCourseCalendarEvent(_ event: Parameter<CourseCalendarEvent>, perform: @escaping (CourseCalendarEvent) -> Void) -> Perform {
            return Perform(method: .m_saveCourseCalendarEvent__event(`event`), performs: perform)
        }
        public static func removeCourseCalendarEvents(for courseId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_removeCourseCalendarEvents__for_courseId(`courseId`), performs: perform)
        }
        public static func removeAllCourseCalendarEvents(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_removeAllCourseCalendarEvents, performs: perform)
        }
        public static func getCourseCalendarEvents(for courseId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseCalendarEvents__for_courseId(`courseId`), performs: perform)
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

// MARK: - ProfileRouter
@MainActor
open class ProfileRouterMock: ProfileRouter, Mock {
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





    open func showEditProfile(userModel: Core.UserProfile, avatar: UIImage?, profileDidEdit: @escaping ((UserProfile?, UIImage?)) -> Void) {
        addInvocation(.m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(Parameter<Core.UserProfile>.value(`userModel`), Parameter<UIImage?>.value(`avatar`), Parameter<((UserProfile?, UIImage?)) -> Void>.value(`profileDidEdit`)))
		let perform = methodPerformValue(.m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(Parameter<Core.UserProfile>.value(`userModel`), Parameter<UIImage?>.value(`avatar`), Parameter<((UserProfile?, UIImage?)) -> Void>.value(`profileDidEdit`))) as? (Core.UserProfile, UIImage?, @escaping ((UserProfile?, UIImage?)) -> Void) -> Void
		perform?(`userModel`, `avatar`, `profileDidEdit`)
    }

    open func showSettings() {
        addInvocation(.m_showSettings)
		let perform = methodPerformValue(.m_showSettings) as? () -> Void
		perform?()
    }

    open func showVideoSettings() {
        addInvocation(.m_showVideoSettings)
		let perform = methodPerformValue(.m_showVideoSettings) as? () -> Void
		perform?()
    }

    open func showManageAccount() {
        addInvocation(.m_showManageAccount)
		let perform = methodPerformValue(.m_showManageAccount) as? () -> Void
		perform?()
    }

    open func showDatesAndCalendar() {
        addInvocation(.m_showDatesAndCalendar)
		let perform = methodPerformValue(.m_showDatesAndCalendar) as? () -> Void
		perform?()
    }

    open func showSyncCalendarOptions() {
        addInvocation(.m_showSyncCalendarOptions)
		let perform = methodPerformValue(.m_showSyncCalendarOptions) as? () -> Void
		perform?()
    }

    open func showCoursesToSync() {
        addInvocation(.m_showCoursesToSync)
		let perform = methodPerformValue(.m_showCoursesToSync) as? () -> Void
		perform?()
    }

    open func showVideoQualityView(viewModel: SettingsViewModel) {
        addInvocation(.m_showVideoQualityView__viewModel_viewModel(Parameter<SettingsViewModel>.value(`viewModel`)))
		let perform = methodPerformValue(.m_showVideoQualityView__viewModel_viewModel(Parameter<SettingsViewModel>.value(`viewModel`))) as? (SettingsViewModel) -> Void
		perform?(`viewModel`)
    }

    open func showVideoDownloadQualityView(downloadQuality: DownloadQuality, didSelect: ((DownloadQuality) -> Void)?, analytics: CoreAnalytics) {
        addInvocation(.m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(Parameter<DownloadQuality>.value(`downloadQuality`), Parameter<((DownloadQuality) -> Void)?>.value(`didSelect`), Parameter<CoreAnalytics>.value(`analytics`)))
		let perform = methodPerformValue(.m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(Parameter<DownloadQuality>.value(`downloadQuality`), Parameter<((DownloadQuality) -> Void)?>.value(`didSelect`), Parameter<CoreAnalytics>.value(`analytics`))) as? (DownloadQuality, ((DownloadQuality) -> Void)?, CoreAnalytics) -> Void
		perform?(`downloadQuality`, `didSelect`, `analytics`)
    }

    open func showDeleteProfileView() {
        addInvocation(.m_showDeleteProfileView)
		let perform = methodPerformValue(.m_showDeleteProfileView) as? () -> Void
		perform?()
    }

    open func backToRoot(animated: Bool) {
        addInvocation(.m_backToRoot__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_backToRoot__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func back(animated: Bool) {
        addInvocation(.m_back__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_back__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func backWithFade() {
        addInvocation(.m_backWithFade)
		let perform = methodPerformValue(.m_backWithFade) as? () -> Void
		perform?()
    }

    open func dismiss(animated: Bool) {
        addInvocation(.m_dismiss__animated_animated(Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_dismiss__animated_animated(Parameter<Bool>.value(`animated`))) as? (Bool) -> Void
		perform?(`animated`)
    }

    open func removeLastView(controllers: Int) {
        addInvocation(.m_removeLastView__controllers_controllers(Parameter<Int>.value(`controllers`)))
		let perform = methodPerformValue(.m_removeLastView__controllers_controllers(Parameter<Int>.value(`controllers`))) as? (Int) -> Void
		perform?(`controllers`)
    }

    open func showMainOrWhatsNewScreen(sourceScreen: LogistrationSourceScreen, postLoginData: PostLoginData?) {
        addInvocation(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>.value(`sourceScreen`), Parameter<PostLoginData?>.value(`postLoginData`)))
		let perform = methodPerformValue(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>.value(`sourceScreen`), Parameter<PostLoginData?>.value(`postLoginData`))) as? (LogistrationSourceScreen, PostLoginData?) -> Void
		perform?(`sourceScreen`, `postLoginData`)
    }

    open func showStartupScreen() {
        addInvocation(.m_showStartupScreen)
		let perform = methodPerformValue(.m_showStartupScreen) as? () -> Void
		perform?()
    }

    open func showLoginScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
    }

    open func showRegisterScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
    }

    open func showForgotPasswordScreen() {
        addInvocation(.m_showForgotPasswordScreen)
		let perform = methodPerformValue(.m_showForgotPasswordScreen) as? () -> Void
		perform?()
    }

    open func showDiscoveryScreen(searchQuery: String?, sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>.value(`searchQuery`), Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>.value(`searchQuery`), Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (String?, LogistrationSourceScreen) -> Void
		perform?(`searchQuery`, `sourceScreen`)
    }

    open func showWebBrowser(title: String, url: URL) {
        addInvocation(.m_showWebBrowser__title_titleurl_url(Parameter<String>.value(`title`), Parameter<URL>.value(`url`)))
		let perform = methodPerformValue(.m_showWebBrowser__title_titleurl_url(Parameter<String>.value(`title`), Parameter<URL>.value(`url`))) as? (String, URL) -> Void
		perform?(`title`, `url`)
    }

    open func showSSOWebBrowser(title: String) {
        addInvocation(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
    }

    open func presentAlert(alertTitle: String, alertMessage: String, positiveAction: String, onCloseTapped: @escaping () -> Void, firstButtonTapped: @escaping () -> Void, type: AlertViewType) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<AlertViewType>.value(`type`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<AlertViewType>.value(`type`))) as? (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void
		perform?(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`)
    }

    open func presentAlert(alertTitle: String, alertMessage: String, nextSectionName: String?, action: String, image: SwiftUI.Image, onCloseTapped: @escaping () -> Void, firstButtonTapped: @escaping () -> Void, nextSectionTapped: @escaping () -> Void) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<() -> Void>.value(`nextSectionTapped`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`firstButtonTapped`), Parameter<() -> Void>.value(`nextSectionTapped`))) as? (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void
		perform?(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, view: any View, completion: (() -> Void)?) {
        addInvocation(.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`), Parameter<(() -> Void)?>.value(`completion`))) as? (UIModalTransitionStyle, any View, (() -> Void)?) -> Void
		perform?(`transitionStyle`, `view`, `completion`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, animated: Bool, content: () -> any View) {
        addInvocation(.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<Bool>.value(`animated`), Parameter<() -> any View>.any))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<Bool>.value(`animated`), Parameter<() -> any View>.any)) as? (UIModalTransitionStyle, Bool, () -> any View) -> Void
		perform?(`transitionStyle`, `animated`, `content`)
    }


    fileprivate enum MethodType {
        case m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(Parameter<Core.UserProfile>, Parameter<UIImage?>, Parameter<((UserProfile?, UIImage?)) -> Void>)
        case m_showSettings
        case m_showVideoSettings
        case m_showManageAccount
        case m_showDatesAndCalendar
        case m_showSyncCalendarOptions
        case m_showCoursesToSync
        case m_showVideoQualityView__viewModel_viewModel(Parameter<SettingsViewModel>)
        case m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(Parameter<DownloadQuality>, Parameter<((DownloadQuality) -> Void)?>, Parameter<CoreAnalytics>)
        case m_showDeleteProfileView
        case m_backToRoot__animated_animated(Parameter<Bool>)
        case m_back__animated_animated(Parameter<Bool>)
        case m_backWithFade
        case m_dismiss__animated_animated(Parameter<Bool>)
        case m_removeLastView__controllers_controllers(Parameter<Int>)
        case m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(Parameter<LogistrationSourceScreen>, Parameter<PostLoginData?>)
        case m_showStartupScreen
        case m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showForgotPasswordScreen
        case m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>, Parameter<LogistrationSourceScreen>)
        case m_showWebBrowser__title_titleurl_url(Parameter<String>, Parameter<URL>)
        case m_showSSOWebBrowser__title_title(Parameter<String>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>, Parameter<any View>, Parameter<(() -> Void)?>)
        case m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>, Parameter<Bool>, Parameter<() -> any View>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(let lhsUsermodel, let lhsAvatar, let lhsProfiledidedit), .m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(let rhsUsermodel, let rhsAvatar, let rhsProfiledidedit)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsermodel, rhs: rhsUsermodel, with: matcher), lhsUsermodel, rhsUsermodel, "userModel"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAvatar, rhs: rhsAvatar, with: matcher), lhsAvatar, rhsAvatar, "avatar"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsProfiledidedit, rhs: rhsProfiledidedit, with: matcher), lhsProfiledidedit, rhsProfiledidedit, "profileDidEdit"))
				return Matcher.ComparisonResult(results)

            case (.m_showSettings, .m_showSettings): return .match

            case (.m_showVideoSettings, .m_showVideoSettings): return .match

            case (.m_showManageAccount, .m_showManageAccount): return .match

            case (.m_showDatesAndCalendar, .m_showDatesAndCalendar): return .match

            case (.m_showSyncCalendarOptions, .m_showSyncCalendarOptions): return .match

            case (.m_showCoursesToSync, .m_showCoursesToSync): return .match

            case (.m_showVideoQualityView__viewModel_viewModel(let lhsViewmodel), .m_showVideoQualityView__viewModel_viewModel(let rhsViewmodel)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsViewmodel, rhs: rhsViewmodel, with: matcher), lhsViewmodel, rhsViewmodel, "viewModel"))
				return Matcher.ComparisonResult(results)

            case (.m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(let lhsDownloadquality, let lhsDidselect, let lhsAnalytics), .m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(let rhsDownloadquality, let rhsDidselect, let rhsAnalytics)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadquality, rhs: rhsDownloadquality, with: matcher), lhsDownloadquality, rhsDownloadquality, "downloadQuality"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDidselect, rhs: rhsDidselect, with: matcher), lhsDidselect, rhsDidselect, "didSelect"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnalytics, rhs: rhsAnalytics, with: matcher), lhsAnalytics, rhsAnalytics, "analytics"))
				return Matcher.ComparisonResult(results)

            case (.m_showDeleteProfileView, .m_showDeleteProfileView): return .match

            case (.m_backToRoot__animated_animated(let lhsAnimated), .m_backToRoot__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_back__animated_animated(let lhsAnimated), .m_back__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_backWithFade, .m_backWithFade): return .match

            case (.m_dismiss__animated_animated(let lhsAnimated), .m_dismiss__animated_animated(let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_removeLastView__controllers_controllers(let lhsControllers), .m_removeLastView__controllers_controllers(let rhsControllers)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsControllers, rhs: rhsControllers, with: matcher), lhsControllers, rhsControllers, "controllers"))
				return Matcher.ComparisonResult(results)

            case (.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(let lhsSourcescreen, let lhsPostlogindata), .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(let rhsSourcescreen, let rhsPostlogindata)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPostlogindata, rhs: rhsPostlogindata, with: matcher), lhsPostlogindata, rhsPostlogindata, "postLoginData"))
				return Matcher.ComparisonResult(results)

            case (.m_showStartupScreen, .m_showStartupScreen): return .match

            case (.m_showLoginScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showLoginScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showRegisterScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showRegisterScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showForgotPasswordScreen, .m_showForgotPasswordScreen): return .match

            case (.m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(let lhsSearchquery, let lhsSourcescreen), .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(let rhsSearchquery, let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchquery, rhs: rhsSearchquery, with: matcher), lhsSearchquery, rhsSearchquery, "searchQuery"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
				return Matcher.ComparisonResult(results)

            case (.m_showWebBrowser__title_titleurl_url(let lhsTitle, let lhsUrl), .m_showWebBrowser__title_titleurl_url(let rhsTitle, let rhsUrl)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				return Matcher.ComparisonResult(results)

            case (.m_showSSOWebBrowser__title_title(let lhsTitle), .m_showSSOWebBrowser__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				return Matcher.ComparisonResult(results)

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(let lhsAlerttitle, let lhsAlertmessage, let lhsPositiveaction, let lhsOnclosetapped, let lhsFirstbuttontapped, let lhsType), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(let rhsAlerttitle, let rhsAlertmessage, let rhsPositiveaction, let rhsOnclosetapped, let rhsFirstbuttontapped, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPositiveaction, rhs: rhsPositiveaction, with: matcher), lhsPositiveaction, rhsPositiveaction, "positiveAction"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFirstbuttontapped, rhs: rhsFirstbuttontapped, with: matcher), lhsFirstbuttontapped, rhsFirstbuttontapped, "firstButtonTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(let lhsAlerttitle, let lhsAlertmessage, let lhsNextsectionname, let lhsAction, let lhsImage, let lhsOnclosetapped, let lhsFirstbuttontapped, let lhsNextsectiontapped), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(let rhsAlerttitle, let rhsAlertmessage, let rhsNextsectionname, let rhsAction, let rhsImage, let rhsOnclosetapped, let rhsFirstbuttontapped, let rhsNextsectiontapped)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectionname, rhs: rhsNextsectionname, with: matcher), lhsNextsectionname, rhsNextsectionname, "nextSectionName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsImage, rhs: rhsImage, with: matcher), lhsImage, rhsImage, "image"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFirstbuttontapped, rhs: rhsFirstbuttontapped, with: matcher), lhsFirstbuttontapped, rhsFirstbuttontapped, "firstButtonTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectiontapped, rhs: rhsNextsectiontapped, with: matcher), lhsNextsectiontapped, rhsNextsectiontapped, "nextSectionTapped"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(let lhsTransitionstyle, let lhsView, let lhsCompletion), .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(let rhsTransitionstyle, let rhsView, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher), lhsView, rhsView, "view"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(let lhsTransitionstyle, let lhsAnimated, let lhsContent), .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(let rhsTransitionstyle, let rhsAnimated, let rhsContent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher), lhsContent, rhsContent, "content"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_showSettings: return 0
            case .m_showVideoSettings: return 0
            case .m_showManageAccount: return 0
            case .m_showDatesAndCalendar: return 0
            case .m_showSyncCalendarOptions: return 0
            case .m_showCoursesToSync: return 0
            case let .m_showVideoQualityView__viewModel_viewModel(p0): return p0.intValue
            case let .m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_showDeleteProfileView: return 0
            case let .m_backToRoot__animated_animated(p0): return p0.intValue
            case let .m_back__animated_animated(p0): return p0.intValue
            case .m_backWithFade: return 0
            case let .m_dismiss__animated_animated(p0): return p0.intValue
            case let .m_removeLastView__controllers_controllers(p0): return p0.intValue
            case let .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(p0, p1): return p0.intValue + p1.intValue
            case .m_showStartupScreen: return 0
            case let .m_showLoginScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case let .m_showRegisterScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showForgotPasswordScreen: return 0
            case let .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(p0, p1): return p0.intValue + p1.intValue
            case let .m_showWebBrowser__title_titleurl_url(p0, p1): return p0.intValue + p1.intValue
            case let .m_showSSOWebBrowser__title_title(p0): return p0.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit: return ".showEditProfile(userModel:avatar:profileDidEdit:)"
            case .m_showSettings: return ".showSettings()"
            case .m_showVideoSettings: return ".showVideoSettings()"
            case .m_showManageAccount: return ".showManageAccount()"
            case .m_showDatesAndCalendar: return ".showDatesAndCalendar()"
            case .m_showSyncCalendarOptions: return ".showSyncCalendarOptions()"
            case .m_showCoursesToSync: return ".showCoursesToSync()"
            case .m_showVideoQualityView__viewModel_viewModel: return ".showVideoQualityView(viewModel:)"
            case .m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics: return ".showVideoDownloadQualityView(downloadQuality:didSelect:analytics:)"
            case .m_showDeleteProfileView: return ".showDeleteProfileView()"
            case .m_backToRoot__animated_animated: return ".backToRoot(animated:)"
            case .m_back__animated_animated: return ".back(animated:)"
            case .m_backWithFade: return ".backWithFade()"
            case .m_dismiss__animated_animated: return ".dismiss(animated:)"
            case .m_removeLastView__controllers_controllers: return ".removeLastView(controllers:)"
            case .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData: return ".showMainOrWhatsNewScreen(sourceScreen:postLoginData:)"
            case .m_showStartupScreen: return ".showStartupScreen()"
            case .m_showLoginScreen__sourceScreen_sourceScreen: return ".showLoginScreen(sourceScreen:)"
            case .m_showRegisterScreen__sourceScreen_sourceScreen: return ".showRegisterScreen(sourceScreen:)"
            case .m_showForgotPasswordScreen: return ".showForgotPasswordScreen()"
            case .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen: return ".showDiscoveryScreen(searchQuery:sourceScreen:)"
            case .m_showWebBrowser__title_titleurl_url: return ".showWebBrowser(title:url:)"
            case .m_showSSOWebBrowser__title_title: return ".showSSOWebBrowser(title:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type: return ".presentAlert(alertTitle:alertMessage:positiveAction:onCloseTapped:firstButtonTapped:type:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped: return ".presentAlert(alertTitle:alertMessage:nextSectionName:action:image:onCloseTapped:firstButtonTapped:nextSectionTapped:)"
            case .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion: return ".presentView(transitionStyle:view:completion:)"
            case .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content: return ".presentView(transitionStyle:animated:content:)"
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

        public static func showEditProfile(userModel: Parameter<Core.UserProfile>, avatar: Parameter<UIImage?>, profileDidEdit: Parameter<((UserProfile?, UIImage?)) -> Void>) -> Verify { return Verify(method: .m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(`userModel`, `avatar`, `profileDidEdit`))}
        public static func showSettings() -> Verify { return Verify(method: .m_showSettings)}
        public static func showVideoSettings() -> Verify { return Verify(method: .m_showVideoSettings)}
        public static func showManageAccount() -> Verify { return Verify(method: .m_showManageAccount)}
        public static func showDatesAndCalendar() -> Verify { return Verify(method: .m_showDatesAndCalendar)}
        public static func showSyncCalendarOptions() -> Verify { return Verify(method: .m_showSyncCalendarOptions)}
        public static func showCoursesToSync() -> Verify { return Verify(method: .m_showCoursesToSync)}
        public static func showVideoQualityView(viewModel: Parameter<SettingsViewModel>) -> Verify { return Verify(method: .m_showVideoQualityView__viewModel_viewModel(`viewModel`))}
        public static func showVideoDownloadQualityView(downloadQuality: Parameter<DownloadQuality>, didSelect: Parameter<((DownloadQuality) -> Void)?>, analytics: Parameter<CoreAnalytics>) -> Verify { return Verify(method: .m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(`downloadQuality`, `didSelect`, `analytics`))}
        public static func showDeleteProfileView() -> Verify { return Verify(method: .m_showDeleteProfileView)}
        public static func backToRoot(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_backToRoot__animated_animated(`animated`))}
        public static func back(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_back__animated_animated(`animated`))}
        public static func backWithFade() -> Verify { return Verify(method: .m_backWithFade)}
        public static func dismiss(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_dismiss__animated_animated(`animated`))}
        public static func removeLastView(controllers: Parameter<Int>) -> Verify { return Verify(method: .m_removeLastView__controllers_controllers(`controllers`))}
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, postLoginData: Parameter<PostLoginData?>) -> Verify { return Verify(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(`sourceScreen`, `postLoginData`))}
        public static func showStartupScreen() -> Verify { return Verify(method: .m_showStartupScreen)}
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showForgotPasswordScreen() -> Verify { return Verify(method: .m_showForgotPasswordScreen)}
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`))}
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>) -> Verify { return Verify(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`))}
        public static func showSSOWebBrowser(title: Parameter<String>) -> Verify { return Verify(method: .m_showSSOWebBrowser__title_title(`title`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func showEditProfile(userModel: Parameter<Core.UserProfile>, avatar: Parameter<UIImage?>, profileDidEdit: Parameter<((UserProfile?, UIImage?)) -> Void>, perform: @escaping (Core.UserProfile, UIImage?, @escaping ((UserProfile?, UIImage?)) -> Void) -> Void) -> Perform {
            return Perform(method: .m_showEditProfile__userModel_userModelavatar_avatarprofileDidEdit_profileDidEdit(`userModel`, `avatar`, `profileDidEdit`), performs: perform)
        }
        public static func showSettings(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showSettings, performs: perform)
        }
        public static func showVideoSettings(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showVideoSettings, performs: perform)
        }
        public static func showManageAccount(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showManageAccount, performs: perform)
        }
        public static func showDatesAndCalendar(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showDatesAndCalendar, performs: perform)
        }
        public static func showSyncCalendarOptions(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showSyncCalendarOptions, performs: perform)
        }
        public static func showCoursesToSync(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showCoursesToSync, performs: perform)
        }
        public static func showVideoQualityView(viewModel: Parameter<SettingsViewModel>, perform: @escaping (SettingsViewModel) -> Void) -> Perform {
            return Perform(method: .m_showVideoQualityView__viewModel_viewModel(`viewModel`), performs: perform)
        }
        public static func showVideoDownloadQualityView(downloadQuality: Parameter<DownloadQuality>, didSelect: Parameter<((DownloadQuality) -> Void)?>, analytics: Parameter<CoreAnalytics>, perform: @escaping (DownloadQuality, ((DownloadQuality) -> Void)?, CoreAnalytics) -> Void) -> Perform {
            return Perform(method: .m_showVideoDownloadQualityView__downloadQuality_downloadQualitydidSelect_didSelectanalytics_analytics(`downloadQuality`, `didSelect`, `analytics`), performs: perform)
        }
        public static func showDeleteProfileView(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showDeleteProfileView, performs: perform)
        }
        public static func backToRoot(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_backToRoot__animated_animated(`animated`), performs: perform)
        }
        public static func back(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_back__animated_animated(`animated`), performs: perform)
        }
        public static func backWithFade(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_backWithFade, performs: perform)
        }
        public static func dismiss(animated: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_dismiss__animated_animated(`animated`), performs: perform)
        }
        public static func removeLastView(controllers: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_removeLastView__controllers_controllers(`controllers`), performs: perform)
        }
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, postLoginData: Parameter<PostLoginData?>, perform: @escaping (LogistrationSourceScreen, PostLoginData?) -> Void) -> Perform {
            return Perform(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreenpostLoginData_postLoginData(`sourceScreen`, `postLoginData`), performs: perform)
        }
        public static func showStartupScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showStartupScreen, performs: perform)
        }
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
        }
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
        }
        public static func showForgotPasswordScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showForgotPasswordScreen, performs: perform)
        }
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (String?, LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`), performs: perform)
        }
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>, perform: @escaping (String, URL) -> Void) -> Perform {
            return Perform(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`), performs: perform)
        }
        public static func showSSOWebBrowser(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showSSOWebBrowser__title_title(`title`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>, perform: @escaping (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `firstButtonTapped`, `type`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, firstButtonTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>, perform: @escaping (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedfirstButtonTapped_firstButtonTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `firstButtonTapped`, `nextSectionTapped`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>, perform: @escaping (UIModalTransitionStyle, any View, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>, perform: @escaping (UIModalTransitionStyle, Bool, () -> any View) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`), performs: perform)
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

// MARK: - ProfileStorage

open class ProfileStorageMock: ProfileStorage, Mock {
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

    public var userProfile: DataLayer.UserProfile? {
		get {	invocations.append(.p_userProfile_get); return __p_userProfile ?? optionalGivenGetterValue(.p_userProfile_get, "ProfileStorageMock - stub value for userProfile was not defined") }
		set {	invocations.append(.p_userProfile_set(.value(newValue))); __p_userProfile = newValue }
	}
	private var __p_userProfile: (DataLayer.UserProfile)?

    public var useRelativeDates: Bool {
		get {	invocations.append(.p_useRelativeDates_get); return __p_useRelativeDates ?? givenGetterValue(.p_useRelativeDates_get, "ProfileStorageMock - stub value for useRelativeDates was not defined") }
		set {	invocations.append(.p_useRelativeDates_set(.value(newValue))); __p_useRelativeDates = newValue }
	}
	private var __p_useRelativeDates: (Bool)?

    public var calendarSettings: CalendarSettings? {
		get {	invocations.append(.p_calendarSettings_get); return __p_calendarSettings ?? optionalGivenGetterValue(.p_calendarSettings_get, "ProfileStorageMock - stub value for calendarSettings was not defined") }
		set {	invocations.append(.p_calendarSettings_set(.value(newValue))); __p_calendarSettings = newValue }
	}
	private var __p_calendarSettings: (CalendarSettings)?

    public var hideInactiveCourses: Bool? {
		get {	invocations.append(.p_hideInactiveCourses_get); return __p_hideInactiveCourses ?? optionalGivenGetterValue(.p_hideInactiveCourses_get, "ProfileStorageMock - stub value for hideInactiveCourses was not defined") }
		set {	invocations.append(.p_hideInactiveCourses_set(.value(newValue))); __p_hideInactiveCourses = newValue }
	}
	private var __p_hideInactiveCourses: (Bool)?

    public var lastLoginUsername: String? {
		get {	invocations.append(.p_lastLoginUsername_get); return __p_lastLoginUsername ?? optionalGivenGetterValue(.p_lastLoginUsername_get, "ProfileStorageMock - stub value for lastLoginUsername was not defined") }
		set {	invocations.append(.p_lastLoginUsername_set(.value(newValue))); __p_lastLoginUsername = newValue }
	}
	private var __p_lastLoginUsername: (String)?

    public var lastCalendarName: String? {
		get {	invocations.append(.p_lastCalendarName_get); return __p_lastCalendarName ?? optionalGivenGetterValue(.p_lastCalendarName_get, "ProfileStorageMock - stub value for lastCalendarName was not defined") }
		set {	invocations.append(.p_lastCalendarName_set(.value(newValue))); __p_lastCalendarName = newValue }
	}
	private var __p_lastCalendarName: (String)?

    public var lastCalendarUpdateDate: Date? {
		get {	invocations.append(.p_lastCalendarUpdateDate_get); return __p_lastCalendarUpdateDate ?? optionalGivenGetterValue(.p_lastCalendarUpdateDate_get, "ProfileStorageMock - stub value for lastCalendarUpdateDate was not defined") }
		set {	invocations.append(.p_lastCalendarUpdateDate_set(.value(newValue))); __p_lastCalendarUpdateDate = newValue }
	}
	private var __p_lastCalendarUpdateDate: (Date)?

    public var firstCalendarUpdate: Bool? {
		get {	invocations.append(.p_firstCalendarUpdate_get); return __p_firstCalendarUpdate ?? optionalGivenGetterValue(.p_firstCalendarUpdate_get, "ProfileStorageMock - stub value for firstCalendarUpdate was not defined") }
		set {	invocations.append(.p_firstCalendarUpdate_set(.value(newValue))); __p_firstCalendarUpdate = newValue }
	}
	private var __p_firstCalendarUpdate: (Bool)?






    fileprivate enum MethodType {
        case p_userProfile_get
		case p_userProfile_set(Parameter<DataLayer.UserProfile?>)
        case p_useRelativeDates_get
		case p_useRelativeDates_set(Parameter<Bool>)
        case p_calendarSettings_get
		case p_calendarSettings_set(Parameter<CalendarSettings?>)
        case p_hideInactiveCourses_get
		case p_hideInactiveCourses_set(Parameter<Bool?>)
        case p_lastLoginUsername_get
		case p_lastLoginUsername_set(Parameter<String?>)
        case p_lastCalendarName_get
		case p_lastCalendarName_set(Parameter<String?>)
        case p_lastCalendarUpdateDate_get
		case p_lastCalendarUpdateDate_set(Parameter<Date?>)
        case p_firstCalendarUpdate_get
		case p_firstCalendarUpdate_set(Parameter<Bool?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_userProfile_get,.p_userProfile_get): return Matcher.ComparisonResult.match
			case (.p_userProfile_set(let left),.p_userProfile_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<DataLayer.UserProfile?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_useRelativeDates_get,.p_useRelativeDates_get): return Matcher.ComparisonResult.match
			case (.p_useRelativeDates_set(let left),.p_useRelativeDates_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_calendarSettings_get,.p_calendarSettings_get): return Matcher.ComparisonResult.match
			case (.p_calendarSettings_set(let left),.p_calendarSettings_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<CalendarSettings?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_hideInactiveCourses_get,.p_hideInactiveCourses_get): return Matcher.ComparisonResult.match
			case (.p_hideInactiveCourses_set(let left),.p_hideInactiveCourses_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_lastLoginUsername_get,.p_lastLoginUsername_get): return Matcher.ComparisonResult.match
			case (.p_lastLoginUsername_set(let left),.p_lastLoginUsername_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_lastCalendarName_get,.p_lastCalendarName_get): return Matcher.ComparisonResult.match
			case (.p_lastCalendarName_set(let left),.p_lastCalendarName_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_lastCalendarUpdateDate_get,.p_lastCalendarUpdateDate_get): return Matcher.ComparisonResult.match
			case (.p_lastCalendarUpdateDate_set(let left),.p_lastCalendarUpdateDate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Date?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_firstCalendarUpdate_get,.p_firstCalendarUpdate_get): return Matcher.ComparisonResult.match
			case (.p_firstCalendarUpdate_set(let left),.p_firstCalendarUpdate_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_userProfile_get: return 0
			case .p_userProfile_set(let newValue): return newValue.intValue
            case .p_useRelativeDates_get: return 0
			case .p_useRelativeDates_set(let newValue): return newValue.intValue
            case .p_calendarSettings_get: return 0
			case .p_calendarSettings_set(let newValue): return newValue.intValue
            case .p_hideInactiveCourses_get: return 0
			case .p_hideInactiveCourses_set(let newValue): return newValue.intValue
            case .p_lastLoginUsername_get: return 0
			case .p_lastLoginUsername_set(let newValue): return newValue.intValue
            case .p_lastCalendarName_get: return 0
			case .p_lastCalendarName_set(let newValue): return newValue.intValue
            case .p_lastCalendarUpdateDate_get: return 0
			case .p_lastCalendarUpdateDate_set(let newValue): return newValue.intValue
            case .p_firstCalendarUpdate_get: return 0
			case .p_firstCalendarUpdate_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_userProfile_get: return "[get] .userProfile"
			case .p_userProfile_set: return "[set] .userProfile"
            case .p_useRelativeDates_get: return "[get] .useRelativeDates"
			case .p_useRelativeDates_set: return "[set] .useRelativeDates"
            case .p_calendarSettings_get: return "[get] .calendarSettings"
			case .p_calendarSettings_set: return "[set] .calendarSettings"
            case .p_hideInactiveCourses_get: return "[get] .hideInactiveCourses"
			case .p_hideInactiveCourses_set: return "[set] .hideInactiveCourses"
            case .p_lastLoginUsername_get: return "[get] .lastLoginUsername"
			case .p_lastLoginUsername_set: return "[set] .lastLoginUsername"
            case .p_lastCalendarName_get: return "[get] .lastCalendarName"
			case .p_lastCalendarName_set: return "[set] .lastCalendarName"
            case .p_lastCalendarUpdateDate_get: return "[get] .lastCalendarUpdateDate"
			case .p_lastCalendarUpdateDate_set: return "[set] .lastCalendarUpdateDate"
            case .p_firstCalendarUpdate_get: return "[get] .firstCalendarUpdate"
			case .p_firstCalendarUpdate_set: return "[set] .firstCalendarUpdate"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func userProfile(getter defaultValue: DataLayer.UserProfile?...) -> PropertyStub {
            return Given(method: .p_userProfile_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func useRelativeDates(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_useRelativeDates_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func calendarSettings(getter defaultValue: CalendarSettings?...) -> PropertyStub {
            return Given(method: .p_calendarSettings_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func hideInactiveCourses(getter defaultValue: Bool?...) -> PropertyStub {
            return Given(method: .p_hideInactiveCourses_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastLoginUsername(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_lastLoginUsername_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastCalendarName(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_lastCalendarName_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func lastCalendarUpdateDate(getter defaultValue: Date?...) -> PropertyStub {
            return Given(method: .p_lastCalendarUpdateDate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func firstCalendarUpdate(getter defaultValue: Bool?...) -> PropertyStub {
            return Given(method: .p_firstCalendarUpdate_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var userProfile: Verify { return Verify(method: .p_userProfile_get) }
		public static func userProfile(set newValue: Parameter<DataLayer.UserProfile?>) -> Verify { return Verify(method: .p_userProfile_set(newValue)) }
        public static var useRelativeDates: Verify { return Verify(method: .p_useRelativeDates_get) }
		public static func useRelativeDates(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_useRelativeDates_set(newValue)) }
        public static var calendarSettings: Verify { return Verify(method: .p_calendarSettings_get) }
		public static func calendarSettings(set newValue: Parameter<CalendarSettings?>) -> Verify { return Verify(method: .p_calendarSettings_set(newValue)) }
        public static var hideInactiveCourses: Verify { return Verify(method: .p_hideInactiveCourses_get) }
		public static func hideInactiveCourses(set newValue: Parameter<Bool?>) -> Verify { return Verify(method: .p_hideInactiveCourses_set(newValue)) }
        public static var lastLoginUsername: Verify { return Verify(method: .p_lastLoginUsername_get) }
		public static func lastLoginUsername(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_lastLoginUsername_set(newValue)) }
        public static var lastCalendarName: Verify { return Verify(method: .p_lastCalendarName_get) }
		public static func lastCalendarName(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_lastCalendarName_set(newValue)) }
        public static var lastCalendarUpdateDate: Verify { return Verify(method: .p_lastCalendarUpdateDate_get) }
		public static func lastCalendarUpdateDate(set newValue: Parameter<Date?>) -> Verify { return Verify(method: .p_lastCalendarUpdateDate_set(newValue)) }
        public static var firstCalendarUpdate: Verify { return Verify(method: .p_firstCalendarUpdate_get) }
		public static func firstCalendarUpdate(set newValue: Parameter<Bool?>) -> Verify { return Verify(method: .p_firstCalendarUpdate_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

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

