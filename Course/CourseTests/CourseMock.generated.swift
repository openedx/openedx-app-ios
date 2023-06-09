// Generated using Sourcery 1.8.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Course
import Foundation
import SwiftUI
import Combine


// MARK: - AuthInteractorProtocol

open class AuthInteractorProtocolMock: AuthInteractorProtocol, Mock {
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





    @discardableResult
	open func login(username: String, password: String) throws -> User {
        addInvocation(.m_login__username_usernamepassword_password(Parameter<String>.value(`username`), Parameter<String>.value(`password`)))
		let perform = methodPerformValue(.m_login__username_usernamepassword_password(Parameter<String>.value(`username`), Parameter<String>.value(`password`))) as? (String, String) -> Void
		perform?(`username`, `password`)
		var __value: User
		do {
		    __value = try methodReturnValue(.m_login__username_usernamepassword_password(Parameter<String>.value(`username`), Parameter<String>.value(`password`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for login(username: String, password: String). Use given")
			Failure("Stub return value not specified for login(username: String, password: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func resetPassword(email: String) throws -> ResetPassword {
        addInvocation(.m_resetPassword__email_email(Parameter<String>.value(`email`)))
		let perform = methodPerformValue(.m_resetPassword__email_email(Parameter<String>.value(`email`))) as? (String) -> Void
		perform?(`email`)
		var __value: ResetPassword
		do {
		    __value = try methodReturnValue(.m_resetPassword__email_email(Parameter<String>.value(`email`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for resetPassword(email: String). Use given")
			Failure("Stub return value not specified for resetPassword(email: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCookies(force: Bool) throws {
        addInvocation(.m_getCookies__force_force(Parameter<Bool>.value(`force`)))
		let perform = methodPerformValue(.m_getCookies__force_force(Parameter<Bool>.value(`force`))) as? (Bool) -> Void
		perform?(`force`)
		do {
		    _ = try methodReturnValue(.m_getCookies__force_force(Parameter<Bool>.value(`force`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func getRegistrationFields() throws -> [PickerFields] {
        addInvocation(.m_getRegistrationFields)
		let perform = methodPerformValue(.m_getRegistrationFields) as? () -> Void
		perform?()
		var __value: [PickerFields]
		do {
		    __value = try methodReturnValue(.m_getRegistrationFields).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getRegistrationFields(). Use given")
			Failure("Stub return value not specified for getRegistrationFields(). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func registerUser(fields: [String: String]) throws {
        addInvocation(.m_registerUser__fields_fields(Parameter<[String: String]>.value(`fields`)))
		let perform = methodPerformValue(.m_registerUser__fields_fields(Parameter<[String: String]>.value(`fields`))) as? ([String: String]) -> Void
		perform?(`fields`)
		do {
		    _ = try methodReturnValue(.m_registerUser__fields_fields(Parameter<[String: String]>.value(`fields`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func validateRegistrationFields(fields: [String: String]) throws -> [String: String] {
        addInvocation(.m_validateRegistrationFields__fields_fields(Parameter<[String: String]>.value(`fields`)))
		let perform = methodPerformValue(.m_validateRegistrationFields__fields_fields(Parameter<[String: String]>.value(`fields`))) as? ([String: String]) -> Void
		perform?(`fields`)
		var __value: [String: String]
		do {
		    __value = try methodReturnValue(.m_validateRegistrationFields__fields_fields(Parameter<[String: String]>.value(`fields`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for validateRegistrationFields(fields: [String: String]). Use given")
			Failure("Stub return value not specified for validateRegistrationFields(fields: [String: String]). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_login__username_usernamepassword_password(Parameter<String>, Parameter<String>)
        case m_resetPassword__email_email(Parameter<String>)
        case m_getCookies__force_force(Parameter<Bool>)
        case m_getRegistrationFields
        case m_registerUser__fields_fields(Parameter<[String: String]>)
        case m_validateRegistrationFields__fields_fields(Parameter<[String: String]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_login__username_usernamepassword_password(let lhsUsername, let lhsPassword), .m_login__username_usernamepassword_password(let rhsUsername, let rhsPassword)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPassword, rhs: rhsPassword, with: matcher), lhsPassword, rhsPassword, "password"))
				return Matcher.ComparisonResult(results)

            case (.m_resetPassword__email_email(let lhsEmail), .m_resetPassword__email_email(let rhsEmail)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEmail, rhs: rhsEmail, with: matcher), lhsEmail, rhsEmail, "email"))
				return Matcher.ComparisonResult(results)

            case (.m_getCookies__force_force(let lhsForce), .m_getCookies__force_force(let rhsForce)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsForce, rhs: rhsForce, with: matcher), lhsForce, rhsForce, "force"))
				return Matcher.ComparisonResult(results)

            case (.m_getRegistrationFields, .m_getRegistrationFields): return .match

            case (.m_registerUser__fields_fields(let lhsFields), .m_registerUser__fields_fields(let rhsFields)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFields, rhs: rhsFields, with: matcher), lhsFields, rhsFields, "fields"))
				return Matcher.ComparisonResult(results)

            case (.m_validateRegistrationFields__fields_fields(let lhsFields), .m_validateRegistrationFields__fields_fields(let rhsFields)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFields, rhs: rhsFields, with: matcher), lhsFields, rhsFields, "fields"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_login__username_usernamepassword_password(p0, p1): return p0.intValue + p1.intValue
            case let .m_resetPassword__email_email(p0): return p0.intValue
            case let .m_getCookies__force_force(p0): return p0.intValue
            case .m_getRegistrationFields: return 0
            case let .m_registerUser__fields_fields(p0): return p0.intValue
            case let .m_validateRegistrationFields__fields_fields(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_login__username_usernamepassword_password: return ".login(username:password:)"
            case .m_resetPassword__email_email: return ".resetPassword(email:)"
            case .m_getCookies__force_force: return ".getCookies(force:)"
            case .m_getRegistrationFields: return ".getRegistrationFields()"
            case .m_registerUser__fields_fields: return ".registerUser(fields:)"
            case .m_validateRegistrationFields__fields_fields: return ".validateRegistrationFields(fields:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>, willReturn: User...) -> MethodStub {
            return Given(method: .m_login__username_usernamepassword_password(`username`, `password`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func resetPassword(email: Parameter<String>, willReturn: ResetPassword...) -> MethodStub {
            return Given(method: .m_resetPassword__email_email(`email`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getRegistrationFields(willReturn: [PickerFields]...) -> MethodStub {
            return Given(method: .m_getRegistrationFields, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func validateRegistrationFields(fields: Parameter<[String: String]>, willReturn: [String: String]...) -> MethodStub {
            return Given(method: .m_validateRegistrationFields__fields_fields(`fields`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_login__username_usernamepassword_password(`username`, `password`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>, willProduce: (StubberThrows<User>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_login__username_usernamepassword_password(`username`, `password`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (User).self)
			willProduce(stubber)
			return given
        }
        public static func resetPassword(email: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_resetPassword__email_email(`email`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resetPassword(email: Parameter<String>, willProduce: (StubberThrows<ResetPassword>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resetPassword__email_email(`email`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ResetPassword).self)
			willProduce(stubber)
			return given
        }
        public static func getCookies(force: Parameter<Bool>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCookies__force_force(`force`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCookies(force: Parameter<Bool>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCookies__force_force(`force`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func getRegistrationFields(willThrow: Error...) -> MethodStub {
            return Given(method: .m_getRegistrationFields, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getRegistrationFields(willProduce: (StubberThrows<[PickerFields]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getRegistrationFields, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([PickerFields]).self)
			willProduce(stubber)
			return given
        }
        public static func registerUser(fields: Parameter<[String: String]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_registerUser__fields_fields(`fields`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func registerUser(fields: Parameter<[String: String]>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_registerUser__fields_fields(`fields`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func validateRegistrationFields(fields: Parameter<[String: String]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_validateRegistrationFields__fields_fields(`fields`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func validateRegistrationFields(fields: Parameter<[String: String]>, willProduce: (StubberThrows<[String: String]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_validateRegistrationFields__fields_fields(`fields`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([String: String]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>) -> Verify { return Verify(method: .m_login__username_usernamepassword_password(`username`, `password`))}
        public static func resetPassword(email: Parameter<String>) -> Verify { return Verify(method: .m_resetPassword__email_email(`email`))}
        public static func getCookies(force: Parameter<Bool>) -> Verify { return Verify(method: .m_getCookies__force_force(`force`))}
        public static func getRegistrationFields() -> Verify { return Verify(method: .m_getRegistrationFields)}
        public static func registerUser(fields: Parameter<[String: String]>) -> Verify { return Verify(method: .m_registerUser__fields_fields(`fields`))}
        public static func validateRegistrationFields(fields: Parameter<[String: String]>) -> Verify { return Verify(method: .m_validateRegistrationFields__fields_fields(`fields`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_login__username_usernamepassword_password(`username`, `password`), performs: perform)
        }
        public static func resetPassword(email: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_resetPassword__email_email(`email`), performs: perform)
        }
        public static func getCookies(force: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_getCookies__force_force(`force`), performs: perform)
        }
        public static func getRegistrationFields(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getRegistrationFields, performs: perform)
        }
        public static func registerUser(fields: Parameter<[String: String]>, perform: @escaping ([String: String]) -> Void) -> Perform {
            return Perform(method: .m_registerUser__fields_fields(`fields`), performs: perform)
        }
        public static func validateRegistrationFields(fields: Parameter<[String: String]>, perform: @escaping ([String: String]) -> Void) -> Perform {
            return Perform(method: .m_validateRegistrationFields__fields_fields(`fields`), performs: perform)
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

// MARK: - BaseRouter

open class BaseRouterMock: BaseRouter, Mock {
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

    open func showMainScreen() {
        addInvocation(.m_showMainScreen)
		let perform = methodPerformValue(.m_showMainScreen) as? () -> Void
		perform?()
    }

    open func showLoginScreen() {
        addInvocation(.m_showLoginScreen)
		let perform = methodPerformValue(.m_showLoginScreen) as? () -> Void
		perform?()
    }

    open func showRegisterScreen() {
        addInvocation(.m_showRegisterScreen)
		let perform = methodPerformValue(.m_showRegisterScreen) as? () -> Void
		perform?()
    }

    open func showForgotPasswordScreen() {
        addInvocation(.m_showForgotPasswordScreen)
		let perform = methodPerformValue(.m_showForgotPasswordScreen) as? () -> Void
		perform?()
    }

    open func presentAlert(alertTitle: String, alertMessage: String, positiveAction: String, onCloseTapped: @escaping () -> Void, okTapped: @escaping () -> Void, type: AlertViewType) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`okTapped`), Parameter<AlertViewType>.value(`type`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String>.value(`positiveAction`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`okTapped`), Parameter<AlertViewType>.value(`type`))) as? (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void
		perform?(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`)
    }

    open func presentAlert(alertTitle: String, alertMessage: String, nextSectionName: String?, action: String, image: SwiftUI.Image, onCloseTapped: @escaping () -> Void, okTapped: @escaping () -> Void, nextSectionTapped: @escaping () -> Void) {
        addInvocation(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`okTapped`), Parameter<() -> Void>.value(`nextSectionTapped`)))
		let perform = methodPerformValue(.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>.value(`alertTitle`), Parameter<String>.value(`alertMessage`), Parameter<String?>.value(`nextSectionName`), Parameter<String>.value(`action`), Parameter<SwiftUI.Image>.value(`image`), Parameter<() -> Void>.value(`onCloseTapped`), Parameter<() -> Void>.value(`okTapped`), Parameter<() -> Void>.value(`nextSectionTapped`))) as? (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void
		perform?(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, view: any View) {
        addInvocation(.m_presentView__transitionStyle_transitionStyleview_view(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`)))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStyleview_view(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<any View>.value(`view`))) as? (UIModalTransitionStyle, any View) -> Void
		perform?(`transitionStyle`, `view`)
    }

    open func presentView(transitionStyle: UIModalTransitionStyle, content: () -> any View) {
        addInvocation(.m_presentView__transitionStyle_transitionStylecontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<() -> any View>.any))
		let perform = methodPerformValue(.m_presentView__transitionStyle_transitionStylecontent_content(Parameter<UIModalTransitionStyle>.value(`transitionStyle`), Parameter<() -> any View>.any)) as? (UIModalTransitionStyle, () -> any View) -> Void
		perform?(`transitionStyle`, `content`)
    }


    fileprivate enum MethodType {
        case m_backToRoot__animated_animated(Parameter<Bool>)
        case m_back__animated_animated(Parameter<Bool>)
        case m_backWithFade
        case m_dismiss__animated_animated(Parameter<Bool>)
        case m_removeLastView__controllers_controllers(Parameter<Int>)
        case m_showMainScreen
        case m_showLoginScreen
        case m_showRegisterScreen
        case m_showForgotPasswordScreen
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_view(Parameter<UIModalTransitionStyle>, Parameter<any View>)
        case m_presentView__transitionStyle_transitionStylecontent_content(Parameter<UIModalTransitionStyle>, Parameter<() -> any View>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
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

            case (.m_showMainScreen, .m_showMainScreen): return .match

            case (.m_showLoginScreen, .m_showLoginScreen): return .match

            case (.m_showRegisterScreen, .m_showRegisterScreen): return .match

            case (.m_showForgotPasswordScreen, .m_showForgotPasswordScreen): return .match

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(let lhsAlerttitle, let lhsAlertmessage, let lhsPositiveaction, let lhsOnclosetapped, let lhsOktapped, let lhsType), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(let rhsAlerttitle, let rhsAlertmessage, let rhsPositiveaction, let rhsOnclosetapped, let rhsOktapped, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPositiveaction, rhs: rhsPositiveaction, with: matcher), lhsPositiveaction, rhsPositiveaction, "positiveAction"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOktapped, rhs: rhsOktapped, with: matcher), lhsOktapped, rhsOktapped, "okTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(let lhsAlerttitle, let lhsAlertmessage, let lhsNextsectionname, let lhsAction, let lhsImage, let lhsOnclosetapped, let lhsOktapped, let lhsNextsectiontapped), .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(let rhsAlerttitle, let rhsAlertmessage, let rhsNextsectionname, let rhsAction, let rhsImage, let rhsOnclosetapped, let rhsOktapped, let rhsNextsectiontapped)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlerttitle, rhs: rhsAlerttitle, with: matcher), lhsAlerttitle, rhsAlerttitle, "alertTitle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAlertmessage, rhs: rhsAlertmessage, with: matcher), lhsAlertmessage, rhsAlertmessage, "alertMessage"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectionname, rhs: rhsNextsectionname, with: matcher), lhsNextsectionname, rhsNextsectionname, "nextSectionName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsImage, rhs: rhsImage, with: matcher), lhsImage, rhsImage, "image"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnclosetapped, rhs: rhsOnclosetapped, with: matcher), lhsOnclosetapped, rhsOnclosetapped, "onCloseTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOktapped, rhs: rhsOktapped, with: matcher), lhsOktapped, rhsOktapped, "okTapped"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNextsectiontapped, rhs: rhsNextsectiontapped, with: matcher), lhsNextsectiontapped, rhsNextsectiontapped, "nextSectionTapped"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStyleview_view(let lhsTransitionstyle, let lhsView), .m_presentView__transitionStyle_transitionStyleview_view(let rhsTransitionstyle, let rhsView)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsView, rhs: rhsView, with: matcher), lhsView, rhsView, "view"))
				return Matcher.ComparisonResult(results)

            case (.m_presentView__transitionStyle_transitionStylecontent_content(let lhsTransitionstyle, let lhsContent), .m_presentView__transitionStyle_transitionStylecontent_content(let rhsTransitionstyle, let rhsContent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTransitionstyle, rhs: rhsTransitionstyle, with: matcher), lhsTransitionstyle, rhsTransitionstyle, "transitionStyle"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsContent, rhs: rhsContent, with: matcher), lhsContent, rhsContent, "content"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_backToRoot__animated_animated(p0): return p0.intValue
            case let .m_back__animated_animated(p0): return p0.intValue
            case .m_backWithFade: return 0
            case let .m_dismiss__animated_animated(p0): return p0.intValue
            case let .m_removeLastView__controllers_controllers(p0): return p0.intValue
            case .m_showMainScreen: return 0
            case .m_showLoginScreen: return 0
            case .m_showRegisterScreen: return 0
            case .m_showForgotPasswordScreen: return 0
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_view(p0, p1): return p0.intValue + p1.intValue
            case let .m_presentView__transitionStyle_transitionStylecontent_content(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_backToRoot__animated_animated: return ".backToRoot(animated:)"
            case .m_back__animated_animated: return ".back(animated:)"
            case .m_backWithFade: return ".backWithFade()"
            case .m_dismiss__animated_animated: return ".dismiss(animated:)"
            case .m_removeLastView__controllers_controllers: return ".removeLastView(controllers:)"
            case .m_showMainScreen: return ".showMainScreen()"
            case .m_showLoginScreen: return ".showLoginScreen()"
            case .m_showRegisterScreen: return ".showRegisterScreen()"
            case .m_showForgotPasswordScreen: return ".showForgotPasswordScreen()"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type: return ".presentAlert(alertTitle:alertMessage:positiveAction:onCloseTapped:okTapped:type:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped: return ".presentAlert(alertTitle:alertMessage:nextSectionName:action:image:onCloseTapped:okTapped:nextSectionTapped:)"
            case .m_presentView__transitionStyle_transitionStyleview_view: return ".presentView(transitionStyle:view:)"
            case .m_presentView__transitionStyle_transitionStylecontent_content: return ".presentView(transitionStyle:content:)"
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

        public static func backToRoot(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_backToRoot__animated_animated(`animated`))}
        public static func back(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_back__animated_animated(`animated`))}
        public static func backWithFade() -> Verify { return Verify(method: .m_backWithFade)}
        public static func dismiss(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_dismiss__animated_animated(`animated`))}
        public static func removeLastView(controllers: Parameter<Int>) -> Verify { return Verify(method: .m_removeLastView__controllers_controllers(`controllers`))}
        public static func showMainScreen() -> Verify { return Verify(method: .m_showMainScreen)}
        public static func showLoginScreen() -> Verify { return Verify(method: .m_showLoginScreen)}
        public static func showRegisterScreen() -> Verify { return Verify(method: .m_showRegisterScreen)}
        public static func showForgotPasswordScreen() -> Verify { return Verify(method: .m_showForgotPasswordScreen)}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_view(`transitionStyle`, `view`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStylecontent_content(`transitionStyle`, `content`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

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
        public static func showMainScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showMainScreen, performs: perform)
        }
        public static func showLoginScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showLoginScreen, performs: perform)
        }
        public static func showRegisterScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showRegisterScreen, performs: perform)
        }
        public static func showForgotPasswordScreen(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_showForgotPasswordScreen, performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>, perform: @escaping (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>, perform: @escaping (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, perform: @escaping (UIModalTransitionStyle, any View) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStyleview_view(`transitionStyle`, `view`), performs: perform)
        }
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, content: Parameter<() -> any View>, perform: @escaping (UIModalTransitionStyle, () -> any View) -> Void) -> Perform {
            return Perform(method: .m_presentView__transitionStyle_transitionStylecontent_content(`transitionStyle`, `content`), performs: perform)
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

// MARK: - ConnectivityProtocol

open class ConnectivityProtocolMock: ConnectivityProtocol, Mock {
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

    public var isInternetAvaliable: Bool {
		get {	invocations.append(.p_isInternetAvaliable_get); return __p_isInternetAvaliable ?? givenGetterValue(.p_isInternetAvaliable_get, "ConnectivityProtocolMock - stub value for isInternetAvaliable was not defined") }
	}
	private var __p_isInternetAvaliable: (Bool)?

    public var isMobileData: Bool {
		get {	invocations.append(.p_isMobileData_get); return __p_isMobileData ?? givenGetterValue(.p_isMobileData_get, "ConnectivityProtocolMock - stub value for isMobileData was not defined") }
	}
	private var __p_isMobileData: (Bool)?

    public var internetReachableSubject: CurrentValueSubject<InternetState?, Never> {
		get {	invocations.append(.p_internetReachableSubject_get); return __p_internetReachableSubject ?? givenGetterValue(.p_internetReachableSubject_get, "ConnectivityProtocolMock - stub value for internetReachableSubject was not defined") }
	}
	private var __p_internetReachableSubject: (CurrentValueSubject<InternetState?, Never>)?






    fileprivate enum MethodType {
        case p_isInternetAvaliable_get
        case p_isMobileData_get
        case p_internetReachableSubject_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {            case (.p_isInternetAvaliable_get,.p_isInternetAvaliable_get): return Matcher.ComparisonResult.match
            case (.p_isMobileData_get,.p_isMobileData_get): return Matcher.ComparisonResult.match
            case (.p_internetReachableSubject_get,.p_internetReachableSubject_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .p_isInternetAvaliable_get: return 0
            case .p_isMobileData_get: return 0
            case .p_internetReachableSubject_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .p_isInternetAvaliable_get: return "[get] .isInternetAvaliable"
            case .p_isMobileData_get: return "[get] .isMobileData"
            case .p_internetReachableSubject_get: return "[get] .internetReachableSubject"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func isInternetAvaliable(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isInternetAvaliable_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func isMobileData(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_isMobileData_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func internetReachableSubject(getter defaultValue: CurrentValueSubject<InternetState?, Never>...) -> PropertyStub {
            return Given(method: .p_internetReachableSubject_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static var isInternetAvaliable: Verify { return Verify(method: .p_isInternetAvaliable_get) }
        public static var isMobileData: Verify { return Verify(method: .p_isMobileData_get) }
        public static var internetReachableSubject: Verify { return Verify(method: .p_internetReachableSubject_get) }
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

// MARK: - CourseInteractorProtocol

open class CourseInteractorProtocolMock: CourseInteractorProtocol, Mock {
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

    open func getCourseBlocks(courseID: String) throws -> CourseStructure {
        addInvocation(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseBlocks(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseBlocks(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseVideoBlocks(fullStructure: CourseStructure) -> CourseStructure {
        addInvocation(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`)))
		let perform = methodPerformValue(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))) as? (CourseStructure) -> Void
		perform?(`fullStructure`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>.value(`fullStructure`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getCourseVideoBlocks(fullStructure: CourseStructure). Use given")
			Failure("Stub return value not specified for getCourseVideoBlocks(fullStructure: CourseStructure). Use given")
		}
		return __value
    }

    open func getCourseDetailsOffline(courseID: String) throws -> CourseDetails {
        addInvocation(.m_getCourseDetailsOffline__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDetailsOffline__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDetails
		do {
		    __value = try methodReturnValue(.m_getCourseDetailsOffline__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDetailsOffline(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDetailsOffline(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCourseBlocksOffline(courseID: String) throws -> CourseStructure {
        addInvocation(.m_getCourseBlocksOffline__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseBlocksOffline__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getCourseBlocksOffline__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseBlocksOffline(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseBlocksOffline(courseID: String). Use given")
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

    open func blockCompletionRequest(courseID: String, blockID: String) throws {
        addInvocation(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`)))
		let perform = methodPerformValue(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`))) as? (String, String) -> Void
		perform?(`courseID`, `blockID`)
		do {
		    _ = try methodReturnValue(.m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func getHandouts(courseID: String) throws -> String? {
        addInvocation(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: String? = nil
		do {
		    __value = try methodReturnValue(.m_getHandouts__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
		return __value
    }

    open func getUpdates(courseID: String) throws -> [CourseUpdate] {
        addInvocation(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: [CourseUpdate]
		do {
		    __value = try methodReturnValue(.m_getUpdates__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getUpdates(courseID: String). Use given")
			Failure("Stub return value not specified for getUpdates(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func resumeBlock(courseID: String) throws -> ResumeBlock {
        addInvocation(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: ResumeBlock
		do {
		    __value = try methodReturnValue(.m_resumeBlock__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for resumeBlock(courseID: String). Use given")
			Failure("Stub return value not specified for resumeBlock(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getSubtitles(url: String, selectedLanguage: String) throws -> [Subtitle] {
        addInvocation(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`)))
		let perform = methodPerformValue(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`))) as? (String, String) -> Void
		perform?(`url`, `selectedLanguage`)
		var __value: [Subtitle]
		do {
		    __value = try methodReturnValue(.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>.value(`url`), Parameter<String>.value(`selectedLanguage`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getSubtitles(url: String, selectedLanguage: String). Use given")
			Failure("Stub return value not specified for getSubtitles(url: String, selectedLanguage: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_getCourseDetails__courseID_courseID(Parameter<String>)
        case m_getCourseBlocks__courseID_courseID(Parameter<String>)
        case m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>)
        case m_getCourseDetailsOffline__courseID_courseID(Parameter<String>)
        case m_getCourseBlocksOffline__courseID_courseID(Parameter<String>)
        case m_enrollToCourse__courseID_courseID(Parameter<String>)
        case m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>, Parameter<String>)
        case m_getHandouts__courseID_courseID(Parameter<String>)
        case m_getUpdates__courseID_courseID(Parameter<String>)
        case m_resumeBlock__courseID_courseID(Parameter<String>)
        case m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseDetails__courseID_courseID(let lhsCourseid), .m_getCourseDetails__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseBlocks__courseID_courseID(let lhsCourseid), .m_getCourseBlocks__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseVideoBlocks__fullStructure_fullStructure(let lhsFullstructure), .m_getCourseVideoBlocks__fullStructure_fullStructure(let rhsFullstructure)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFullstructure, rhs: rhsFullstructure, with: matcher), lhsFullstructure, rhsFullstructure, "fullStructure"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDetailsOffline__courseID_courseID(let lhsCourseid), .m_getCourseDetailsOffline__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseBlocksOffline__courseID_courseID(let lhsCourseid), .m_getCourseBlocksOffline__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_enrollToCourse__courseID_courseID(let lhsCourseid), .m_enrollToCourse__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_blockCompletionRequest__courseID_courseIDblockID_blockID(let lhsCourseid, let lhsBlockid), .m_blockCompletionRequest__courseID_courseIDblockID_blockID(let rhsCourseid, let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				return Matcher.ComparisonResult(results)

            case (.m_getHandouts__courseID_courseID(let lhsCourseid), .m_getHandouts__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getUpdates__courseID_courseID(let lhsCourseid), .m_getUpdates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_resumeBlock__courseID_courseID(let lhsCourseid), .m_resumeBlock__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getSubtitles__url_urlselectedLanguage_selectedLanguage(let lhsUrl, let lhsSelectedlanguage), .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(let rhsUrl, let rhsSelectedlanguage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUrl, rhs: rhsUrl, with: matcher), lhsUrl, rhsUrl, "url"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSelectedlanguage, rhs: rhsSelectedlanguage, with: matcher), lhsSelectedlanguage, rhsSelectedlanguage, "selectedLanguage"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseDetails__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseBlocks__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseVideoBlocks__fullStructure_fullStructure(p0): return p0.intValue
            case let .m_getCourseDetailsOffline__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseBlocksOffline__courseID_courseID(p0): return p0.intValue
            case let .m_enrollToCourse__courseID_courseID(p0): return p0.intValue
            case let .m_blockCompletionRequest__courseID_courseIDblockID_blockID(p0, p1): return p0.intValue + p1.intValue
            case let .m_getHandouts__courseID_courseID(p0): return p0.intValue
            case let .m_getUpdates__courseID_courseID(p0): return p0.intValue
            case let .m_resumeBlock__courseID_courseID(p0): return p0.intValue
            case let .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseDetails__courseID_courseID: return ".getCourseDetails(courseID:)"
            case .m_getCourseBlocks__courseID_courseID: return ".getCourseBlocks(courseID:)"
            case .m_getCourseVideoBlocks__fullStructure_fullStructure: return ".getCourseVideoBlocks(fullStructure:)"
            case .m_getCourseDetailsOffline__courseID_courseID: return ".getCourseDetailsOffline(courseID:)"
            case .m_getCourseBlocksOffline__courseID_courseID: return ".getCourseBlocksOffline(courseID:)"
            case .m_enrollToCourse__courseID_courseID: return ".enrollToCourse(courseID:)"
            case .m_blockCompletionRequest__courseID_courseIDblockID_blockID: return ".blockCompletionRequest(courseID:blockID:)"
            case .m_getHandouts__courseID_courseID: return ".getHandouts(courseID:)"
            case .m_getUpdates__courseID_courseID: return ".getUpdates(courseID:)"
            case .m_resumeBlock__courseID_courseID: return ".resumeBlock(courseID:)"
            case .m_getSubtitles__url_urlselectedLanguage_selectedLanguage: return ".getSubtitles(url:selectedLanguage:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseDetails(courseID: Parameter<String>, willReturn: CourseDetails...) -> MethodStub {
            return Given(method: .m_getCourseDetails__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseBlocks(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDetailsOffline(courseID: Parameter<String>, willReturn: CourseDetails...) -> MethodStub {
            return Given(method: .m_getCourseDetailsOffline__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseBlocksOffline(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseBlocksOffline__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func enrollToCourse(courseID: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_enrollToCourse__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getHandouts(courseID: Parameter<String>, willReturn: String?...) -> MethodStub {
            return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getUpdates(courseID: Parameter<String>, willReturn: [CourseUpdate]...) -> MethodStub {
            return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func resumeBlock(courseID: Parameter<String>, willReturn: ResumeBlock...) -> MethodStub {
            return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willReturn: [Subtitle]...) -> MethodStub {
            return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willProduce: (Stubber<CourseStructure>) -> Void) -> MethodStub {
            let willReturn: [CourseStructure] = []
			let given: Given = { return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseStructure).self)
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
        public static func getCourseBlocks(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseBlocks(courseID: Parameter<String>, willProduce: (StubberThrows<CourseStructure>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseStructure).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseDetailsOffline(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDetailsOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDetailsOffline(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDetails>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDetailsOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDetails).self)
			willProduce(stubber)
			return given
        }
        public static func getCourseBlocksOffline(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseBlocksOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseBlocksOffline(courseID: Parameter<String>, willProduce: (StubberThrows<CourseStructure>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseBlocksOffline__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseStructure).self)
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
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func getHandouts(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getHandouts(courseID: Parameter<String>, willProduce: (StubberThrows<String?>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getHandouts__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (String?).self)
			willProduce(stubber)
			return given
        }
        public static func getUpdates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getUpdates(courseID: Parameter<String>, willProduce: (StubberThrows<[CourseUpdate]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getUpdates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([CourseUpdate]).self)
			willProduce(stubber)
			return given
        }
        public static func resumeBlock(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resumeBlock(courseID: Parameter<String>, willProduce: (StubberThrows<ResumeBlock>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resumeBlock__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ResumeBlock).self)
			willProduce(stubber)
			return given
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, willProduce: (StubberThrows<[Subtitle]>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: ([Subtitle]).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseDetails(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDetails__courseID_courseID(`courseID`))}
        public static func getCourseBlocks(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseBlocks__courseID_courseID(`courseID`))}
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`))}
        public static func getCourseDetailsOffline(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDetailsOffline__courseID_courseID(`courseID`))}
        public static func getCourseBlocksOffline(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseBlocksOffline__courseID_courseID(`courseID`))}
        public static func enrollToCourse(courseID: Parameter<String>) -> Verify { return Verify(method: .m_enrollToCourse__courseID_courseID(`courseID`))}
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>) -> Verify { return Verify(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`))}
        public static func getHandouts(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getHandouts__courseID_courseID(`courseID`))}
        public static func getUpdates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getUpdates__courseID_courseID(`courseID`))}
        public static func resumeBlock(courseID: Parameter<String>) -> Verify { return Verify(method: .m_resumeBlock__courseID_courseID(`courseID`))}
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>) -> Verify { return Verify(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseDetails(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDetails__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseBlocks(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseBlocks__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), performs: perform)
        }
        public static func getCourseDetailsOffline(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDetailsOffline__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseBlocksOffline(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseBlocksOffline__courseID_courseID(`courseID`), performs: perform)
        }
        public static func enrollToCourse(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_enrollToCourse__courseID_courseID(`courseID`), performs: perform)
        }
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`), performs: perform)
        }
        public static func getHandouts(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getHandouts__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getUpdates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getUpdates__courseID_courseID(`courseID`), performs: perform)
        }
        public static func resumeBlock(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_resumeBlock__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`), performs: perform)
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

