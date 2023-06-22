// Generated using Sourcery 1.8.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Discussion
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

// MARK: - DiscussionInteractorProtocol

open class DiscussionInteractorProtocolMock: DiscussionInteractorProtocol, Mock {
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





    open func getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int) throws -> ThreadLists {
        addInvocation(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`))) as? (String, ThreadType, SortType, ThreadsFilter, Int) -> Void
		perform?(`courseID`, `type`, `sort`, `filter`, `page`)
		var __value: ThreadLists
		do {
		    __value = try methodReturnValue(.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>.value(`courseID`), Parameter<ThreadType>.value(`type`), Parameter<SortType>.value(`sort`), Parameter<ThreadsFilter>.value(`filter`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int). Use given")
			Failure("Stub return value not specified for getThreadsList(courseID: String, type: ThreadType, sort: SortType, filter: ThreadsFilter, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getTopics(courseID: String) throws -> Topics {
        addInvocation(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: Topics
		do {
		    __value = try methodReturnValue(.m_getTopics__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getTopics(courseID: String). Use given")
			Failure("Stub return value not specified for getTopics(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func searchThreads(courseID: String, searchText: String, pageNumber: Int) throws -> ThreadLists {
        addInvocation(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`)))
		let perform = methodPerformValue(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `searchText`, `pageNumber`)
		var __value: ThreadLists
		do {
		    __value = try methodReturnValue(.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>.value(`courseID`), Parameter<String>.value(`searchText`), Parameter<Int>.value(`pageNumber`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for searchThreads(courseID: String, searchText: String, pageNumber: Int). Use given")
			Failure("Stub return value not specified for searchThreads(courseID: String, searchText: String, pageNumber: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getDiscussionComments(threadID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`threadID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getDiscussionComments(threadID: String, page: Int). Use given")
			Failure("Stub return value not specified for getDiscussionComments(threadID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getQuestionComments(threadID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`threadID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>.value(`threadID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getQuestionComments(threadID: String, page: Int). Use given")
			Failure("Stub return value not specified for getQuestionComments(threadID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func getCommentResponses(commentID: String, page: Int) throws -> ([UserComment], Pagination) {
        addInvocation(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`)))
		let perform = methodPerformValue(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`))) as? (String, Int) -> Void
		perform?(`commentID`, `page`)
		var __value: ([UserComment], Pagination)
		do {
		    __value = try methodReturnValue(.m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>.value(`commentID`), Parameter<Int>.value(`page`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCommentResponses(commentID: String, page: Int). Use given")
			Failure("Stub return value not specified for getCommentResponses(commentID: String, page: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func addCommentTo(threadID: String, rawBody: String, parentID: String?) throws -> Post {
        addInvocation(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`)))
		let perform = methodPerformValue(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`))) as? (String, String, String?) -> Void
		perform?(`threadID`, `rawBody`, `parentID`)
		var __value: Post
		do {
		    __value = try methodReturnValue(.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>.value(`threadID`), Parameter<String>.value(`rawBody`), Parameter<String?>.value(`parentID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for addCommentTo(threadID: String, rawBody: String, parentID: String?). Use given")
			Failure("Stub return value not specified for addCommentTo(threadID: String, rawBody: String, parentID: String?). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func voteThread(voted: Bool, threadID: String) throws {
        addInvocation(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`voted`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func voteResponse(voted: Bool, responseID: String) throws {
        addInvocation(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`)))
		let perform = methodPerformValue(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`))) as? (Bool, String) -> Void
		perform?(`voted`, `responseID`)
		do {
		    _ = try methodReturnValue(.m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>.value(`voted`), Parameter<String>.value(`responseID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func flagThread(abuseFlagged: Bool, threadID: String) throws {
        addInvocation(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`abuseFlagged`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func flagComment(abuseFlagged: Bool, commentID: String) throws {
        addInvocation(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`)))
		let perform = methodPerformValue(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`))) as? (Bool, String) -> Void
		perform?(`abuseFlagged`, `commentID`)
		do {
		    _ = try methodReturnValue(.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>.value(`abuseFlagged`), Parameter<String>.value(`commentID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func followThread(following: Bool, threadID: String) throws {
        addInvocation(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`))) as? (Bool, String) -> Void
		perform?(`following`, `threadID`)
		do {
		    _ = try methodReturnValue(.m_followThread__following_followingthreadID_threadID(Parameter<Bool>.value(`following`), Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func createNewThread(newThread: DiscussionNewThread) throws {
        addInvocation(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`)))
		let perform = methodPerformValue(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`))) as? (DiscussionNewThread) -> Void
		perform?(`newThread`)
		do {
		    _ = try methodReturnValue(.m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>.value(`newThread`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func readBody(threadID: String) throws {
        addInvocation(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`))) as? (String) -> Void
		perform?(`threadID`)
		do {
		    _ = try methodReturnValue(.m_readBody__threadID_threadID(Parameter<String>.value(`threadID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>, Parameter<ThreadType>, Parameter<SortType>, Parameter<ThreadsFilter>, Parameter<Int>)
        case m_getTopics__courseID_courseID(Parameter<String>)
        case m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>, Parameter<Int>)
        case m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(Parameter<String>, Parameter<String>, Parameter<String?>)
        case m_voteThread__voted_votedthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_voteResponse__voted_votedresponseID_responseID(Parameter<Bool>, Parameter<String>)
        case m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(Parameter<Bool>, Parameter<String>)
        case m_followThread__following_followingthreadID_threadID(Parameter<Bool>, Parameter<String>)
        case m_createNewThread__newThread_newThread(Parameter<DiscussionNewThread>)
        case m_readBody__threadID_threadID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(let lhsCourseid, let lhsType, let lhsSort, let lhsFilter, let lhsPage), .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(let rhsCourseid, let rhsType, let rhsSort, let rhsFilter, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSort, rhs: rhsSort, with: matcher), lhsSort, rhsSort, "sort"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFilter, rhs: rhsFilter, with: matcher), lhsFilter, rhsFilter, "filter"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getTopics__courseID_courseID(let lhsCourseid), .m_getTopics__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let lhsCourseid, let lhsSearchtext, let lhsPagenumber), .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let rhsCourseid, let rhsSearchtext, let rhsPagenumber)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchtext, rhs: rhsSearchtext, with: matcher), lhsSearchtext, rhsSearchtext, "searchText"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPagenumber, rhs: rhsPagenumber, with: matcher), lhsPagenumber, rhsPagenumber, "pageNumber"))
				return Matcher.ComparisonResult(results)

            case (.m_getDiscussionComments__threadID_threadIDpage_page(let lhsThreadid, let lhsPage), .m_getDiscussionComments__threadID_threadIDpage_page(let rhsThreadid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getQuestionComments__threadID_threadIDpage_page(let lhsThreadid, let lhsPage), .m_getQuestionComments__threadID_threadIDpage_page(let rhsThreadid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_getCommentResponses__commentID_commentIDpage_page(let lhsCommentid, let lhsPage), .m_getCommentResponses__commentID_commentIDpage_page(let rhsCommentid, let rhsPage)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPage, rhs: rhsPage, with: matcher), lhsPage, rhsPage, "page"))
				return Matcher.ComparisonResult(results)

            case (.m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(let lhsThreadid, let lhsRawbody, let lhsParentid), .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(let rhsThreadid, let rhsRawbody, let rhsParentid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRawbody, rhs: rhsRawbody, with: matcher), lhsRawbody, rhsRawbody, "rawBody"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParentid, rhs: rhsParentid, with: matcher), lhsParentid, rhsParentid, "parentID"))
				return Matcher.ComparisonResult(results)

            case (.m_voteThread__voted_votedthreadID_threadID(let lhsVoted, let lhsThreadid), .m_voteThread__voted_votedthreadID_threadID(let rhsVoted, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVoted, rhs: rhsVoted, with: matcher), lhsVoted, rhsVoted, "voted"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_voteResponse__voted_votedresponseID_responseID(let lhsVoted, let lhsResponseid), .m_voteResponse__voted_votedresponseID_responseID(let rhsVoted, let rhsResponseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVoted, rhs: rhsVoted, with: matcher), lhsVoted, rhsVoted, "voted"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
				return Matcher.ComparisonResult(results)

            case (.m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(let lhsAbuseflagged, let lhsThreadid), .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(let rhsAbuseflagged, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAbuseflagged, rhs: rhsAbuseflagged, with: matcher), lhsAbuseflagged, rhsAbuseflagged, "abuseFlagged"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(let lhsAbuseflagged, let lhsCommentid), .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(let rhsAbuseflagged, let rhsCommentid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAbuseflagged, rhs: rhsAbuseflagged, with: matcher), lhsAbuseflagged, rhsAbuseflagged, "abuseFlagged"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				return Matcher.ComparisonResult(results)

            case (.m_followThread__following_followingthreadID_threadID(let lhsFollowing, let lhsThreadid), .m_followThread__following_followingthreadID_threadID(let rhsFollowing, let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFollowing, rhs: rhsFollowing, with: matcher), lhsFollowing, rhsFollowing, "following"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)

            case (.m_createNewThread__newThread_newThread(let lhsNewthread), .m_createNewThread__newThread_newThread(let rhsNewthread)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsNewthread, rhs: rhsNewthread, with: matcher), lhsNewthread, rhsNewthread, "newThread"))
				return Matcher.ComparisonResult(results)

            case (.m_readBody__threadID_threadID(let lhsThreadid), .m_readBody__threadID_threadID(let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_getTopics__courseID_courseID(p0): return p0.intValue
            case let .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_getDiscussionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getQuestionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getCommentResponses__commentID_commentIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_voteThread__voted_votedthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_voteResponse__voted_votedresponseID_responseID(p0, p1): return p0.intValue + p1.intValue
            case let .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(p0, p1): return p0.intValue + p1.intValue
            case let .m_followThread__following_followingthreadID_threadID(p0, p1): return p0.intValue + p1.intValue
            case let .m_createNewThread__newThread_newThread(p0): return p0.intValue
            case let .m_readBody__threadID_threadID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page: return ".getThreadsList(courseID:type:sort:filter:page:)"
            case .m_getTopics__courseID_courseID: return ".getTopics(courseID:)"
            case .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber: return ".searchThreads(courseID:searchText:pageNumber:)"
            case .m_getDiscussionComments__threadID_threadIDpage_page: return ".getDiscussionComments(threadID:page:)"
            case .m_getQuestionComments__threadID_threadIDpage_page: return ".getQuestionComments(threadID:page:)"
            case .m_getCommentResponses__commentID_commentIDpage_page: return ".getCommentResponses(commentID:page:)"
            case .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID: return ".addCommentTo(threadID:rawBody:parentID:)"
            case .m_voteThread__voted_votedthreadID_threadID: return ".voteThread(voted:threadID:)"
            case .m_voteResponse__voted_votedresponseID_responseID: return ".voteResponse(voted:responseID:)"
            case .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID: return ".flagThread(abuseFlagged:threadID:)"
            case .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID: return ".flagComment(abuseFlagged:commentID:)"
            case .m_followThread__following_followingthreadID_threadID: return ".followThread(following:threadID:)"
            case .m_createNewThread__newThread_newThread: return ".createNewThread(newThread:)"
            case .m_readBody__threadID_threadID: return ".readBody(threadID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTopics(courseID: Parameter<String>, willReturn: Topics...) -> MethodStub {
            return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willReturn: ([UserComment], Pagination)...) -> MethodStub {
            return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willReturn: Post...) -> MethodStub {
            return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willProduce: (StubberThrows<ThreadLists>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ThreadLists).self)
			willProduce(stubber)
			return given
        }
        public static func getTopics(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getTopics(courseID: Parameter<String>, willProduce: (StubberThrows<Topics>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Topics).self)
			willProduce(stubber)
			return given
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willProduce: (StubberThrows<ThreadLists>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (ThreadLists).self)
			willProduce(stubber)
			return given
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, willProduce: (StubberThrows<([UserComment], Pagination)>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (([UserComment], Pagination)).self)
			willProduce(stubber)
			return given
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willProduce: (StubberThrows<Post>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Post).self)
			willProduce(stubber)
			return given
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_createNewThread__newThread_newThread(`newThread`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_createNewThread__newThread_newThread(`newThread`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func readBody(threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_readBody__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func readBody(threadID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_readBody__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`))}
        public static func getTopics(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getTopics__courseID_courseID(`courseID`))}
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>) -> Verify { return Verify(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`))}
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`))}
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>) -> Verify { return Verify(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`))}
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`))}
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>) -> Verify { return Verify(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`))}
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`))}
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>) -> Verify { return Verify(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`))}
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>) -> Verify { return Verify(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`))}
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>) -> Verify { return Verify(method: .m_createNewThread__newThread_newThread(`newThread`))}
        public static func readBody(threadID: Parameter<String>) -> Verify { return Verify(method: .m_readBody__threadID_threadID(`threadID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, perform: @escaping (String, ThreadType, SortType, ThreadsFilter, Int) -> Void) -> Perform {
            return Perform(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), performs: perform)
        }
        public static func getTopics(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getTopics__courseID_courseID(`courseID`), performs: perform)
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), performs: perform)
        }
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`), performs: perform)
        }
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`), performs: perform)
        }
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>, perform: @escaping (String, Int) -> Void) -> Perform {
            return Perform(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`), performs: perform)
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, perform: @escaping (String, String, String?) -> Void) -> Perform {
            return Perform(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), performs: perform)
        }
        public static func voteThread(voted: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_voteThread__voted_votedthreadID_threadID(`voted`, `threadID`), performs: perform)
        }
        public static func voteResponse(voted: Parameter<Bool>, responseID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_voteResponse__voted_votedresponseID_responseID(`voted`, `responseID`), performs: perform)
        }
        public static func flagThread(abuseFlagged: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_flagThread__abuseFlagged_abuseFlaggedthreadID_threadID(`abuseFlagged`, `threadID`), performs: perform)
        }
        public static func flagComment(abuseFlagged: Parameter<Bool>, commentID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_flagComment__abuseFlagged_abuseFlaggedcommentID_commentID(`abuseFlagged`, `commentID`), performs: perform)
        }
        public static func followThread(following: Parameter<Bool>, threadID: Parameter<String>, perform: @escaping (Bool, String) -> Void) -> Perform {
            return Perform(method: .m_followThread__following_followingthreadID_threadID(`following`, `threadID`), performs: perform)
        }
        public static func createNewThread(newThread: Parameter<DiscussionNewThread>, perform: @escaping (DiscussionNewThread) -> Void) -> Perform {
            return Perform(method: .m_createNewThread__newThread_newThread(`newThread`), performs: perform)
        }
        public static func readBody(threadID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_readBody__threadID_threadID(`threadID`), performs: perform)
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

// MARK: - DiscussionRouter

open class DiscussionRouterMock: DiscussionRouter, Mock {
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





    open func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType) {
        addInvocation(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`)))
		let perform = methodPerformValue(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`))) as? (String, Topics, String, ThreadType) -> Void
		perform?(`courseID`, `topics`, `title`, `type`)
    }

    open func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>) {
        addInvocation(.m_showThread__thread_threadpostStateSubject_postStateSubject(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`)))
		let perform = methodPerformValue(.m_showThread__thread_threadpostStateSubject_postStateSubject(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`))) as? (UserThread, CurrentValueSubject<PostState?, Never>) -> Void
		perform?(`thread`, `postStateSubject`)
    }

    open func showDiscussionsSearch(courseID: String) {
        addInvocation(.m_showDiscussionsSearch__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_showDiscussionsSearch__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
    }

    open func showComments(commentID: String, parentComment: Post, threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>) {
        addInvocation(.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`)))
		let perform = methodPerformValue(.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`))) as? (String, Post, CurrentValueSubject<ThreadPostState?, Never>) -> Void
		perform?(`commentID`, `parentComment`, `threadStateSubject`)
    }

    open func createNewThread(courseID: String, selectedTopic: String, onPostCreated: @escaping () -> Void) {
        addInvocation(.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>.value(`courseID`), Parameter<String>.value(`selectedTopic`), Parameter<() -> Void>.value(`onPostCreated`)))
		let perform = methodPerformValue(.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>.value(`courseID`), Parameter<String>.value(`selectedTopic`), Parameter<() -> Void>.value(`onPostCreated`))) as? (String, String, @escaping () -> Void) -> Void
		perform?(`courseID`, `selectedTopic`, `onPostCreated`)
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
        case m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(Parameter<String>, Parameter<Topics>, Parameter<String>, Parameter<ThreadType>)
        case m_showThread__thread_threadpostStateSubject_postStateSubject(Parameter<UserThread>, Parameter<CurrentValueSubject<PostState?, Never>>)
        case m_showDiscussionsSearch__courseID_courseID(Parameter<String>)
        case m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(Parameter<String>, Parameter<Post>, Parameter<CurrentValueSubject<ThreadPostState?, Never>>)
        case m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>, Parameter<String>, Parameter<() -> Void>)
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
            case (.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(let lhsCourseid, let lhsTopics, let lhsTitle, let lhsType), .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(let rhsCourseid, let rhsTopics, let rhsTitle, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopics, rhs: rhsTopics, with: matcher), lhsTopics, rhsTopics, "topics"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_showThread__thread_threadpostStateSubject_postStateSubject(let lhsThread, let lhsPoststatesubject), .m_showThread__thread_threadpostStateSubject_postStateSubject(let rhsThread, let rhsPoststatesubject)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThread, rhs: rhsThread, with: matcher), lhsThread, rhsThread, "thread"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPoststatesubject, rhs: rhsPoststatesubject, with: matcher), lhsPoststatesubject, rhsPoststatesubject, "postStateSubject"))
				return Matcher.ComparisonResult(results)

            case (.m_showDiscussionsSearch__courseID_courseID(let lhsCourseid), .m_showDiscussionsSearch__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(let lhsCommentid, let lhsParentcomment, let lhsThreadstatesubject), .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(let rhsCommentid, let rhsParentcomment, let rhsThreadstatesubject)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParentcomment, rhs: rhsParentcomment, with: matcher), lhsParentcomment, rhsParentcomment, "parentComment"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadstatesubject, rhs: rhsThreadstatesubject, with: matcher), lhsThreadstatesubject, rhsThreadstatesubject, "threadStateSubject"))
				return Matcher.ComparisonResult(results)

            case (.m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(let lhsCourseid, let lhsSelectedtopic, let lhsOnpostcreated), .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(let rhsCourseid, let rhsSelectedtopic, let rhsOnpostcreated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSelectedtopic, rhs: rhsSelectedtopic, with: matcher), lhsSelectedtopic, rhsSelectedtopic, "selectedTopic"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOnpostcreated, rhs: rhsOnpostcreated, with: matcher), lhsOnpostcreated, rhsOnpostcreated, "onPostCreated"))
				return Matcher.ComparisonResult(results)

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
            case let .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_showThread__thread_threadpostStateSubject_postStateSubject(p0, p1): return p0.intValue + p1.intValue
            case let .m_showDiscussionsSearch__courseID_courseID(p0): return p0.intValue
            case let .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
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
            case .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type: return ".showThreads(courseID:topics:title:type:)"
            case .m_showThread__thread_threadpostStateSubject_postStateSubject: return ".showThread(thread:postStateSubject:)"
            case .m_showDiscussionsSearch__courseID_courseID: return ".showDiscussionsSearch(courseID:)"
            case .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject: return ".showComments(commentID:parentComment:threadStateSubject:)"
            case .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated: return ".createNewThread(courseID:selectedTopic:onPostCreated:)"
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

        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>) -> Verify { return Verify(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(`courseID`, `topics`, `title`, `type`))}
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>) -> Verify { return Verify(method: .m_showThread__thread_threadpostStateSubject_postStateSubject(`thread`, `postStateSubject`))}
        public static func showDiscussionsSearch(courseID: Parameter<String>) -> Verify { return Verify(method: .m_showDiscussionsSearch__courseID_courseID(`courseID`))}
        public static func showComments(commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>) -> Verify { return Verify(method: .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(`commentID`, `parentComment`, `threadStateSubject`))}
        public static func createNewThread(courseID: Parameter<String>, selectedTopic: Parameter<String>, onPostCreated: Parameter<() -> Void>) -> Verify { return Verify(method: .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(`courseID`, `selectedTopic`, `onPostCreated`))}
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

        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>, perform: @escaping (String, Topics, String, ThreadType) -> Void) -> Perform {
            return Perform(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_type(`courseID`, `topics`, `title`, `type`), performs: perform)
        }
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>, perform: @escaping (UserThread, CurrentValueSubject<PostState?, Never>) -> Void) -> Perform {
            return Perform(method: .m_showThread__thread_threadpostStateSubject_postStateSubject(`thread`, `postStateSubject`), performs: perform)
        }
        public static func showDiscussionsSearch(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showDiscussionsSearch__courseID_courseID(`courseID`), performs: perform)
        }
        public static func showComments(commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>, perform: @escaping (String, Post, CurrentValueSubject<ThreadPostState?, Never>) -> Void) -> Perform {
            return Perform(method: .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubject(`commentID`, `parentComment`, `threadStateSubject`), performs: perform)
        }
        public static func createNewThread(courseID: Parameter<String>, selectedTopic: Parameter<String>, onPostCreated: Parameter<() -> Void>, perform: @escaping (String, String, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(`courseID`, `selectedTopic`, `onPostCreated`), performs: perform)
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

