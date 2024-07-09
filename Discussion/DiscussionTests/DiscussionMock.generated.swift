// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
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

    @discardableResult
	open func login(externalToken: String, backend: String) throws -> User {
        addInvocation(.m_login__externalToken_externalTokenbackend_backend(Parameter<String>.value(`externalToken`), Parameter<String>.value(`backend`)))
		let perform = methodPerformValue(.m_login__externalToken_externalTokenbackend_backend(Parameter<String>.value(`externalToken`), Parameter<String>.value(`backend`))) as? (String, String) -> Void
		perform?(`externalToken`, `backend`)
		var __value: User
		do {
		    __value = try methodReturnValue(.m_login__externalToken_externalTokenbackend_backend(Parameter<String>.value(`externalToken`), Parameter<String>.value(`backend`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for login(externalToken: String, backend: String). Use given")
			Failure("Stub return value not specified for login(externalToken: String, backend: String). Use given")
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

    open func registerUser(fields: [String: String], isSocial: Bool) throws -> User {
        addInvocation(.m_registerUser__fields_fieldsisSocial_isSocial(Parameter<[String: String]>.value(`fields`), Parameter<Bool>.value(`isSocial`)))
		let perform = methodPerformValue(.m_registerUser__fields_fieldsisSocial_isSocial(Parameter<[String: String]>.value(`fields`), Parameter<Bool>.value(`isSocial`))) as? ([String: String], Bool) -> Void
		perform?(`fields`, `isSocial`)
		var __value: User
		do {
		    __value = try methodReturnValue(.m_registerUser__fields_fieldsisSocial_isSocial(Parameter<[String: String]>.value(`fields`), Parameter<Bool>.value(`isSocial`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for registerUser(fields: [String: String], isSocial: Bool). Use given")
			Failure("Stub return value not specified for registerUser(fields: [String: String], isSocial: Bool). Use given")
		} catch {
		    throw error
		}
		return __value
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
        case m_login__externalToken_externalTokenbackend_backend(Parameter<String>, Parameter<String>)
        case m_resetPassword__email_email(Parameter<String>)
        case m_getCookies__force_force(Parameter<Bool>)
        case m_getRegistrationFields
        case m_registerUser__fields_fieldsisSocial_isSocial(Parameter<[String: String]>, Parameter<Bool>)
        case m_validateRegistrationFields__fields_fields(Parameter<[String: String]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_login__username_usernamepassword_password(let lhsUsername, let lhsPassword), .m_login__username_usernamepassword_password(let rhsUsername, let rhsPassword)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPassword, rhs: rhsPassword, with: matcher), lhsPassword, rhsPassword, "password"))
				return Matcher.ComparisonResult(results)

            case (.m_login__externalToken_externalTokenbackend_backend(let lhsExternaltoken, let lhsBackend), .m_login__externalToken_externalTokenbackend_backend(let rhsExternaltoken, let rhsBackend)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsExternaltoken, rhs: rhsExternaltoken, with: matcher), lhsExternaltoken, rhsExternaltoken, "externalToken"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBackend, rhs: rhsBackend, with: matcher), lhsBackend, rhsBackend, "backend"))
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

            case (.m_registerUser__fields_fieldsisSocial_isSocial(let lhsFields, let lhsIssocial), .m_registerUser__fields_fieldsisSocial_isSocial(let rhsFields, let rhsIssocial)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFields, rhs: rhsFields, with: matcher), lhsFields, rhsFields, "fields"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIssocial, rhs: rhsIssocial, with: matcher), lhsIssocial, rhsIssocial, "isSocial"))
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
            case let .m_login__externalToken_externalTokenbackend_backend(p0, p1): return p0.intValue + p1.intValue
            case let .m_resetPassword__email_email(p0): return p0.intValue
            case let .m_getCookies__force_force(p0): return p0.intValue
            case .m_getRegistrationFields: return 0
            case let .m_registerUser__fields_fieldsisSocial_isSocial(p0, p1): return p0.intValue + p1.intValue
            case let .m_validateRegistrationFields__fields_fields(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_login__username_usernamepassword_password: return ".login(username:password:)"
            case .m_login__externalToken_externalTokenbackend_backend: return ".login(externalToken:backend:)"
            case .m_resetPassword__email_email: return ".resetPassword(email:)"
            case .m_getCookies__force_force: return ".getCookies(force:)"
            case .m_getRegistrationFields: return ".getRegistrationFields()"
            case .m_registerUser__fields_fieldsisSocial_isSocial: return ".registerUser(fields:isSocial:)"
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
        @discardableResult
		public static func login(externalToken: Parameter<String>, backend: Parameter<String>, willReturn: User...) -> MethodStub {
            return Given(method: .m_login__externalToken_externalTokenbackend_backend(`externalToken`, `backend`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func resetPassword(email: Parameter<String>, willReturn: ResetPassword...) -> MethodStub {
            return Given(method: .m_resetPassword__email_email(`email`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getRegistrationFields(willReturn: [PickerFields]...) -> MethodStub {
            return Given(method: .m_getRegistrationFields, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func registerUser(fields: Parameter<[String: String]>, isSocial: Parameter<Bool>, willReturn: User...) -> MethodStub {
            return Given(method: .m_registerUser__fields_fieldsisSocial_isSocial(`fields`, `isSocial`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        @discardableResult
		public static func login(externalToken: Parameter<String>, backend: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_login__externalToken_externalTokenbackend_backend(`externalToken`, `backend`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        @discardableResult
		public static func login(externalToken: Parameter<String>, backend: Parameter<String>, willProduce: (StubberThrows<User>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_login__externalToken_externalTokenbackend_backend(`externalToken`, `backend`), products: willThrow.map({ StubProduct.throw($0) })) }()
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
        public static func registerUser(fields: Parameter<[String: String]>, isSocial: Parameter<Bool>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_registerUser__fields_fieldsisSocial_isSocial(`fields`, `isSocial`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func registerUser(fields: Parameter<[String: String]>, isSocial: Parameter<Bool>, willProduce: (StubberThrows<User>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_registerUser__fields_fieldsisSocial_isSocial(`fields`, `isSocial`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (User).self)
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
        @discardableResult
		public static func login(externalToken: Parameter<String>, backend: Parameter<String>) -> Verify { return Verify(method: .m_login__externalToken_externalTokenbackend_backend(`externalToken`, `backend`))}
        public static func resetPassword(email: Parameter<String>) -> Verify { return Verify(method: .m_resetPassword__email_email(`email`))}
        public static func getCookies(force: Parameter<Bool>) -> Verify { return Verify(method: .m_getCookies__force_force(`force`))}
        public static func getRegistrationFields() -> Verify { return Verify(method: .m_getRegistrationFields)}
        public static func registerUser(fields: Parameter<[String: String]>, isSocial: Parameter<Bool>) -> Verify { return Verify(method: .m_registerUser__fields_fieldsisSocial_isSocial(`fields`, `isSocial`))}
        public static func validateRegistrationFields(fields: Parameter<[String: String]>) -> Verify { return Verify(method: .m_validateRegistrationFields__fields_fields(`fields`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        @discardableResult
		public static func login(username: Parameter<String>, password: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_login__username_usernamepassword_password(`username`, `password`), performs: perform)
        }
        @discardableResult
		public static func login(externalToken: Parameter<String>, backend: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_login__externalToken_externalTokenbackend_backend(`externalToken`, `backend`), performs: perform)
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
        public static func registerUser(fields: Parameter<[String: String]>, isSocial: Parameter<Bool>, perform: @escaping ([String: String], Bool) -> Void) -> Perform {
            return Perform(method: .m_registerUser__fields_fieldsisSocial_isSocial(`fields`, `isSocial`), performs: perform)
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

    open func showMainOrWhatsNewScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
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
        case m_backToRoot__animated_animated(Parameter<Bool>)
        case m_back__animated_animated(Parameter<Bool>)
        case m_backWithFade
        case m_dismiss__animated_animated(Parameter<Bool>)
        case m_removeLastView__controllers_controllers(Parameter<Int>)
        case m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showStartupScreen
        case m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showForgotPasswordScreen
        case m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>, Parameter<LogistrationSourceScreen>)
        case m_showWebBrowser__title_titleurl_url(Parameter<String>, Parameter<URL>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>, Parameter<any View>, Parameter<(() -> Void)?>)
        case m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>, Parameter<Bool>, Parameter<() -> any View>)

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

            case (.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
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
            case let .m_backToRoot__animated_animated(p0): return p0.intValue
            case let .m_back__animated_animated(p0): return p0.intValue
            case .m_backWithFade: return 0
            case let .m_dismiss__animated_animated(p0): return p0.intValue
            case let .m_removeLastView__controllers_controllers(p0): return p0.intValue
            case let .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showStartupScreen: return 0
            case let .m_showLoginScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case let .m_showRegisterScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showForgotPasswordScreen: return 0
            case let .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(p0, p1): return p0.intValue + p1.intValue
            case let .m_showWebBrowser__title_titleurl_url(p0, p1): return p0.intValue + p1.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_backToRoot__animated_animated: return ".backToRoot(animated:)"
            case .m_back__animated_animated: return ".back(animated:)"
            case .m_backWithFade: return ".backWithFade()"
            case .m_dismiss__animated_animated: return ".dismiss(animated:)"
            case .m_removeLastView__controllers_controllers: return ".removeLastView(controllers:)"
            case .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen: return ".showMainOrWhatsNewScreen(sourceScreen:)"
            case .m_showStartupScreen: return ".showStartupScreen()"
            case .m_showLoginScreen__sourceScreen_sourceScreen: return ".showLoginScreen(sourceScreen:)"
            case .m_showRegisterScreen__sourceScreen_sourceScreen: return ".showRegisterScreen(sourceScreen:)"
            case .m_showForgotPasswordScreen: return ".showForgotPasswordScreen()"
            case .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen: return ".showDiscoveryScreen(searchQuery:sourceScreen:)"
            case .m_showWebBrowser__title_titleurl_url: return ".showWebBrowser(title:url:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type: return ".presentAlert(alertTitle:alertMessage:positiveAction:onCloseTapped:okTapped:type:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped: return ".presentAlert(alertTitle:alertMessage:nextSectionName:action:image:onCloseTapped:okTapped:nextSectionTapped:)"
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

        public static func backToRoot(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_backToRoot__animated_animated(`animated`))}
        public static func back(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_back__animated_animated(`animated`))}
        public static func backWithFade() -> Verify { return Verify(method: .m_backWithFade)}
        public static func dismiss(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_dismiss__animated_animated(`animated`))}
        public static func removeLastView(controllers: Parameter<Int>) -> Verify { return Verify(method: .m_removeLastView__controllers_controllers(`controllers`))}
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showStartupScreen() -> Verify { return Verify(method: .m_showStartupScreen)}
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showForgotPasswordScreen() -> Verify { return Verify(method: .m_showForgotPasswordScreen)}
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`))}
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>) -> Verify { return Verify(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`))}
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
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
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
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>, perform: @escaping (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>, perform: @escaping (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`), performs: perform)
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

// MARK: - CoreAnalytics

open class CoreAnalyticsMock: CoreAnalytics, Mock {
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





    open func trackEvent(_ event: AnalyticsEvent, parameters: [String: Any]?) {
        addInvocation(.m_trackEvent__eventparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<[String: Any]?>.value(`parameters`)))
		let perform = methodPerformValue(.m_trackEvent__eventparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<[String: Any]?>.value(`parameters`))) as? (AnalyticsEvent, [String: Any]?) -> Void
		perform?(`event`, `parameters`)
    }

    open func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?) {
        addInvocation(.m_trackEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<[String: Any]?>.value(`parameters`)))
		let perform = methodPerformValue(.m_trackEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<[String: Any]?>.value(`parameters`))) as? (AnalyticsEvent, EventBIValue, [String: Any]?) -> Void
		perform?(`event`, `biValue`, `parameters`)
    }

    open func trackScreenEvent(_ event: AnalyticsEvent, parameters: [String: Any]?) {
        addInvocation(.m_trackScreenEvent__eventparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<[String: Any]?>.value(`parameters`)))
		let perform = methodPerformValue(.m_trackScreenEvent__eventparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<[String: Any]?>.value(`parameters`))) as? (AnalyticsEvent, [String: Any]?) -> Void
		perform?(`event`, `parameters`)
    }

    open func trackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue, parameters: [String: Any]?) {
        addInvocation(.m_trackScreenEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<[String: Any]?>.value(`parameters`)))
		let perform = methodPerformValue(.m_trackScreenEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<[String: Any]?>.value(`parameters`))) as? (AnalyticsEvent, EventBIValue, [String: Any]?) -> Void
		perform?(`event`, `biValue`, `parameters`)
    }

    open func appreview(_ event: AnalyticsEvent, biValue: EventBIValue, action: String?, rating: Int?) {
        addInvocation(.m_appreview__eventbiValue_biValueaction_actionrating_rating(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String?>.value(`action`), Parameter<Int?>.value(`rating`)))
		let perform = methodPerformValue(.m_appreview__eventbiValue_biValueaction_actionrating_rating(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String?>.value(`action`), Parameter<Int?>.value(`rating`))) as? (AnalyticsEvent, EventBIValue, String?, Int?) -> Void
		perform?(`event`, `biValue`, `action`, `rating`)
    }

    open func videoQualityChanged(_ event: AnalyticsEvent, bivalue: EventBIValue, value: String, oldValue: String) {
        addInvocation(.m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`value`), Parameter<String>.value(`oldValue`)))
		let perform = methodPerformValue(.m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`value`), Parameter<String>.value(`oldValue`))) as? (AnalyticsEvent, EventBIValue, String, String) -> Void
		perform?(`event`, `bivalue`, `value`, `oldValue`)
    }

    open func trackEvent(_ event: AnalyticsEvent) {
        addInvocation(.m_trackEvent__event(Parameter<AnalyticsEvent>.value(`event`)))
		let perform = methodPerformValue(.m_trackEvent__event(Parameter<AnalyticsEvent>.value(`event`))) as? (AnalyticsEvent) -> Void
		perform?(`event`)
    }

    open func trackEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_trackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_trackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }

    open func trackScreenEvent(_ event: AnalyticsEvent) {
        addInvocation(.m_trackScreenEvent__event(Parameter<AnalyticsEvent>.value(`event`)))
		let perform = methodPerformValue(.m_trackScreenEvent__event(Parameter<AnalyticsEvent>.value(`event`))) as? (AnalyticsEvent) -> Void
		perform?(`event`)
    }

    open func trackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_trackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_trackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }


    fileprivate enum MethodType {
        case m_trackEvent__eventparameters_parameters(Parameter<AnalyticsEvent>, Parameter<[String: Any]?>)
        case m_trackEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<[String: Any]?>)
        case m_trackScreenEvent__eventparameters_parameters(Parameter<AnalyticsEvent>, Parameter<[String: Any]?>)
        case m_trackScreenEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<[String: Any]?>)
        case m_appreview__eventbiValue_biValueaction_actionrating_rating(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String?>, Parameter<Int?>)
        case m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>)
        case m_trackEvent__event(Parameter<AnalyticsEvent>)
        case m_trackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)
        case m_trackScreenEvent__event(Parameter<AnalyticsEvent>)
        case m_trackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_trackEvent__eventparameters_parameters(let lhsEvent, let lhsParameters), .m_trackEvent__eventparameters_parameters(let rhsEvent, let rhsParameters)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher), lhsParameters, rhsParameters, "parameters"))
				return Matcher.ComparisonResult(results)

            case (.m_trackEvent__eventbiValue_biValueparameters_parameters(let lhsEvent, let lhsBivalue, let lhsParameters), .m_trackEvent__eventbiValue_biValueparameters_parameters(let rhsEvent, let rhsBivalue, let rhsParameters)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher), lhsParameters, rhsParameters, "parameters"))
				return Matcher.ComparisonResult(results)

            case (.m_trackScreenEvent__eventparameters_parameters(let lhsEvent, let lhsParameters), .m_trackScreenEvent__eventparameters_parameters(let rhsEvent, let rhsParameters)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher), lhsParameters, rhsParameters, "parameters"))
				return Matcher.ComparisonResult(results)

            case (.m_trackScreenEvent__eventbiValue_biValueparameters_parameters(let lhsEvent, let lhsBivalue, let lhsParameters), .m_trackScreenEvent__eventbiValue_biValueparameters_parameters(let rhsEvent, let rhsBivalue, let rhsParameters)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParameters, rhs: rhsParameters, with: matcher), lhsParameters, rhsParameters, "parameters"))
				return Matcher.ComparisonResult(results)

            case (.m_appreview__eventbiValue_biValueaction_actionrating_rating(let lhsEvent, let lhsBivalue, let lhsAction, let lhsRating), .m_appreview__eventbiValue_biValueaction_actionrating_rating(let rhsEvent, let rhsBivalue, let rhsAction, let rhsRating)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRating, rhs: rhsRating, with: matcher), lhsRating, rhsRating, "rating"))
				return Matcher.ComparisonResult(results)

            case (.m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(let lhsEvent, let lhsBivalue, let lhsValue, let lhsOldvalue), .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(let rhsEvent, let rhsBivalue, let rhsValue, let rhsOldvalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "bivalue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsValue, rhs: rhsValue, with: matcher), lhsValue, rhsValue, "value"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsOldvalue, rhs: rhsOldvalue, with: matcher), lhsOldvalue, rhsOldvalue, "oldValue"))
				return Matcher.ComparisonResult(results)

            case (.m_trackEvent__event(let lhsEvent), .m_trackEvent__event(let rhsEvent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				return Matcher.ComparisonResult(results)

            case (.m_trackEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_trackEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)

            case (.m_trackScreenEvent__event(let lhsEvent), .m_trackScreenEvent__event(let rhsEvent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				return Matcher.ComparisonResult(results)

            case (.m_trackScreenEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_trackScreenEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_trackEvent__eventparameters_parameters(p0, p1): return p0.intValue + p1.intValue
            case let .m_trackEvent__eventbiValue_biValueparameters_parameters(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_trackScreenEvent__eventparameters_parameters(p0, p1): return p0.intValue + p1.intValue
            case let .m_trackScreenEvent__eventbiValue_biValueparameters_parameters(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_appreview__eventbiValue_biValueaction_actionrating_rating(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_trackEvent__event(p0): return p0.intValue
            case let .m_trackEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            case let .m_trackScreenEvent__event(p0): return p0.intValue
            case let .m_trackScreenEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_trackEvent__eventparameters_parameters: return ".trackEvent(_:parameters:)"
            case .m_trackEvent__eventbiValue_biValueparameters_parameters: return ".trackEvent(_:biValue:parameters:)"
            case .m_trackScreenEvent__eventparameters_parameters: return ".trackScreenEvent(_:parameters:)"
            case .m_trackScreenEvent__eventbiValue_biValueparameters_parameters: return ".trackScreenEvent(_:biValue:parameters:)"
            case .m_appreview__eventbiValue_biValueaction_actionrating_rating: return ".appreview(_:biValue:action:rating:)"
            case .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue: return ".videoQualityChanged(_:bivalue:value:oldValue:)"
            case .m_trackEvent__event: return ".trackEvent(_:)"
            case .m_trackEvent__eventbiValue_biValue: return ".trackEvent(_:biValue:)"
            case .m_trackScreenEvent__event: return ".trackScreenEvent(_:)"
            case .m_trackScreenEvent__eventbiValue_biValue: return ".trackScreenEvent(_:biValue:)"
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

        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, parameters: Parameter<[String: Any]?>) -> Verify { return Verify(method: .m_trackEvent__eventparameters_parameters(`event`, `parameters`))}
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, parameters: Parameter<[String: Any]?>) -> Verify { return Verify(method: .m_trackEvent__eventbiValue_biValueparameters_parameters(`event`, `biValue`, `parameters`))}
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, parameters: Parameter<[String: Any]?>) -> Verify { return Verify(method: .m_trackScreenEvent__eventparameters_parameters(`event`, `parameters`))}
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, parameters: Parameter<[String: Any]?>) -> Verify { return Verify(method: .m_trackScreenEvent__eventbiValue_biValueparameters_parameters(`event`, `biValue`, `parameters`))}
        public static func appreview(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, action: Parameter<String?>, rating: Parameter<Int?>) -> Verify { return Verify(method: .m_appreview__eventbiValue_biValueaction_actionrating_rating(`event`, `biValue`, `action`, `rating`))}
        public static func videoQualityChanged(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, value: Parameter<String>, oldValue: Parameter<String>) -> Verify { return Verify(method: .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(`event`, `bivalue`, `value`, `oldValue`))}
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>) -> Verify { return Verify(method: .m_trackEvent__event(`event`))}
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_trackEvent__eventbiValue_biValue(`event`, `biValue`))}
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>) -> Verify { return Verify(method: .m_trackScreenEvent__event(`event`))}
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_trackScreenEvent__eventbiValue_biValue(`event`, `biValue`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, parameters: Parameter<[String: Any]?>, perform: @escaping (AnalyticsEvent, [String: Any]?) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__eventparameters_parameters(`event`, `parameters`), performs: perform)
        }
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, parameters: Parameter<[String: Any]?>, perform: @escaping (AnalyticsEvent, EventBIValue, [String: Any]?) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__eventbiValue_biValueparameters_parameters(`event`, `biValue`, `parameters`), performs: perform)
        }
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, parameters: Parameter<[String: Any]?>, perform: @escaping (AnalyticsEvent, [String: Any]?) -> Void) -> Perform {
            return Perform(method: .m_trackScreenEvent__eventparameters_parameters(`event`, `parameters`), performs: perform)
        }
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, parameters: Parameter<[String: Any]?>, perform: @escaping (AnalyticsEvent, EventBIValue, [String: Any]?) -> Void) -> Perform {
            return Perform(method: .m_trackScreenEvent__eventbiValue_biValueparameters_parameters(`event`, `biValue`, `parameters`), performs: perform)
        }
        public static func appreview(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, action: Parameter<String?>, rating: Parameter<Int?>, perform: @escaping (AnalyticsEvent, EventBIValue, String?, Int?) -> Void) -> Perform {
            return Perform(method: .m_appreview__eventbiValue_biValueaction_actionrating_rating(`event`, `biValue`, `action`, `rating`), performs: perform)
        }
        public static func videoQualityChanged(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, value: Parameter<String>, oldValue: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String) -> Void) -> Perform {
            return Perform(method: .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(`event`, `bivalue`, `value`, `oldValue`), performs: perform)
        }
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, perform: @escaping (AnalyticsEvent) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__event(`event`), performs: perform)
        }
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
        }
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, perform: @escaping (AnalyticsEvent) -> Void) -> Perform {
            return Perform(method: .m_trackScreenEvent__event(`event`), performs: perform)
        }
        public static func trackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_trackScreenEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
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

// MARK: - CorePersistenceProtocol

open class CorePersistenceProtocolMock: CorePersistenceProtocol, Mock {
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





    open func set(userId: Int) {
        addInvocation(.m_set__userId_userId(Parameter<Int>.value(`userId`)))
		let perform = methodPerformValue(.m_set__userId_userId(Parameter<Int>.value(`userId`))) as? (Int) -> Void
		perform?(`userId`)
    }

    open func getUserID() -> Int? {
        addInvocation(.m_getUserID)
		let perform = methodPerformValue(.m_getUserID) as? () -> Void
		perform?()
		var __value: Int? = nil
		do {
		    __value = try methodReturnValue(.m_getUserID).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func publisher() -> AnyPublisher<Int, Never> {
        addInvocation(.m_publisher)
		let perform = methodPerformValue(.m_publisher) as? () -> Void
		perform?()
		var __value: AnyPublisher<Int, Never>
		do {
		    __value = try methodReturnValue(.m_publisher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for publisher(). Use given")
			Failure("Stub return value not specified for publisher(). Use given")
		}
		return __value
    }

    open func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) {
        addInvocation(.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>.value(`blocks`), Parameter<DownloadQuality>.value(`downloadQuality`)))
		let perform = methodPerformValue(.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>.value(`blocks`), Parameter<DownloadQuality>.value(`downloadQuality`))) as? ([CourseBlock], DownloadQuality) -> Void
		perform?(`blocks`, `downloadQuality`)
    }

    open func addToDownloadQueue(tasks: [DownloadDataTask]) {
        addInvocation(.m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>.value(`tasks`)))
		let perform = methodPerformValue(.m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>.value(`tasks`))) as? ([DownloadDataTask]) -> Void
		perform?(`tasks`)
    }

    open func nextBlockForDownloading() -> DownloadDataTask? {
        addInvocation(.m_nextBlockForDownloading)
		let perform = methodPerformValue(.m_nextBlockForDownloading) as? () -> Void
		perform?()
		var __value: DownloadDataTask? = nil
		do {
		    __value = try methodReturnValue(.m_nextBlockForDownloading).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func updateDownloadState(id: String, state: DownloadState, resumeData: Data?) {
        addInvocation(.m_updateDownloadState__id_idstate_stateresumeData_resumeData(Parameter<String>.value(`id`), Parameter<DownloadState>.value(`state`), Parameter<Data?>.value(`resumeData`)))
		let perform = methodPerformValue(.m_updateDownloadState__id_idstate_stateresumeData_resumeData(Parameter<String>.value(`id`), Parameter<DownloadState>.value(`state`), Parameter<Data?>.value(`resumeData`))) as? (String, DownloadState, Data?) -> Void
		perform?(`id`, `state`, `resumeData`)
    }

    open func deleteDownloadDataTask(id: String) throws {
        addInvocation(.m_deleteDownloadDataTask__id_id(Parameter<String>.value(`id`)))
		let perform = methodPerformValue(.m_deleteDownloadDataTask__id_id(Parameter<String>.value(`id`))) as? (String) -> Void
		perform?(`id`)
		do {
		    _ = try methodReturnValue(.m_deleteDownloadDataTask__id_id(Parameter<String>.value(`id`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func downloadDataTask(for blockId: String) -> DownloadDataTask? {
        addInvocation(.m_downloadDataTask__for_blockId(Parameter<String>.value(`blockId`)))
		let perform = methodPerformValue(.m_downloadDataTask__for_blockId(Parameter<String>.value(`blockId`))) as? (String) -> Void
		perform?(`blockId`)
		var __value: DownloadDataTask? = nil
		do {
		    __value = try methodReturnValue(.m_downloadDataTask__for_blockId(Parameter<String>.value(`blockId`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func downloadDataTask(for blockId: String, completion: @escaping (DownloadDataTask?) -> Void) {
        addInvocation(.m_downloadDataTask__for_blockIdcompletion_completion(Parameter<String>.value(`blockId`), Parameter<(DownloadDataTask?) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_downloadDataTask__for_blockIdcompletion_completion(Parameter<String>.value(`blockId`), Parameter<(DownloadDataTask?) -> Void>.value(`completion`))) as? (String, @escaping (DownloadDataTask?) -> Void) -> Void
		perform?(`blockId`, `completion`)
    }

    open func getDownloadDataTasks(completion: @escaping ([DownloadDataTask]) -> Void) {
        addInvocation(.m_getDownloadDataTasks__completion_completion(Parameter<([DownloadDataTask]) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_getDownloadDataTasks__completion_completion(Parameter<([DownloadDataTask]) -> Void>.value(`completion`))) as? (@escaping ([DownloadDataTask]) -> Void) -> Void
		perform?(`completion`)
    }

    open func getDownloadDataTasksForCourse(_ courseId: String, completion: @escaping ([DownloadDataTask]) -> Void) {
        addInvocation(.m_getDownloadDataTasksForCourse__courseIdcompletion_completion(Parameter<String>.value(`courseId`), Parameter<([DownloadDataTask]) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_getDownloadDataTasksForCourse__courseIdcompletion_completion(Parameter<String>.value(`courseId`), Parameter<([DownloadDataTask]) -> Void>.value(`completion`))) as? (String, @escaping ([DownloadDataTask]) -> Void) -> Void
		perform?(`courseId`, `completion`)
    }

    open func saveOfflineProgress(progress: OfflineProgress) {
        addInvocation(.m_saveOfflineProgress__progress_progress(Parameter<OfflineProgress>.value(`progress`)))
		let perform = methodPerformValue(.m_saveOfflineProgress__progress_progress(Parameter<OfflineProgress>.value(`progress`))) as? (OfflineProgress) -> Void
		perform?(`progress`)
    }

    open func loadProgress(for blockID: String) -> OfflineProgress? {
        addInvocation(.m_loadProgress__for_blockID(Parameter<String>.value(`blockID`)))
		let perform = methodPerformValue(.m_loadProgress__for_blockID(Parameter<String>.value(`blockID`))) as? (String) -> Void
		perform?(`blockID`)
		var __value: OfflineProgress? = nil
		do {
		    __value = try methodReturnValue(.m_loadProgress__for_blockID(Parameter<String>.value(`blockID`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func loadAllOfflineProgress() -> [OfflineProgress] {
        addInvocation(.m_loadAllOfflineProgress)
		let perform = methodPerformValue(.m_loadAllOfflineProgress) as? () -> Void
		perform?()
		var __value: [OfflineProgress]
		do {
		    __value = try methodReturnValue(.m_loadAllOfflineProgress).casted()
		} catch {
			onFatalFailure("Stub return value not specified for loadAllOfflineProgress(). Use given")
			Failure("Stub return value not specified for loadAllOfflineProgress(). Use given")
		}
		return __value
    }

    open func deleteProgress(for blockID: String) {
        addInvocation(.m_deleteProgress__for_blockID(Parameter<String>.value(`blockID`)))
		let perform = methodPerformValue(.m_deleteProgress__for_blockID(Parameter<String>.value(`blockID`))) as? (String) -> Void
		perform?(`blockID`)
    }

    open func deleteAllProgress() {
        addInvocation(.m_deleteAllProgress)
		let perform = methodPerformValue(.m_deleteAllProgress) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_set__userId_userId(Parameter<Int>)
        case m_getUserID
        case m_publisher
        case m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>, Parameter<DownloadQuality>)
        case m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>)
        case m_nextBlockForDownloading
        case m_updateDownloadState__id_idstate_stateresumeData_resumeData(Parameter<String>, Parameter<DownloadState>, Parameter<Data?>)
        case m_deleteDownloadDataTask__id_id(Parameter<String>)
        case m_downloadDataTask__for_blockId(Parameter<String>)
        case m_downloadDataTask__for_blockIdcompletion_completion(Parameter<String>, Parameter<(DownloadDataTask?) -> Void>)
        case m_getDownloadDataTasks__completion_completion(Parameter<([DownloadDataTask]) -> Void>)
        case m_getDownloadDataTasksForCourse__courseIdcompletion_completion(Parameter<String>, Parameter<([DownloadDataTask]) -> Void>)
        case m_saveOfflineProgress__progress_progress(Parameter<OfflineProgress>)
        case m_loadProgress__for_blockID(Parameter<String>)
        case m_loadAllOfflineProgress
        case m_deleteProgress__for_blockID(Parameter<String>)
        case m_deleteAllProgress

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_set__userId_userId(let lhsUserid), .m_set__userId_userId(let rhsUserid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUserid, rhs: rhsUserid, with: matcher), lhsUserid, rhsUserid, "userId"))
				return Matcher.ComparisonResult(results)

            case (.m_getUserID, .m_getUserID): return .match

            case (.m_publisher, .m_publisher): return .match

            case (.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(let lhsBlocks, let lhsDownloadquality), .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(let rhsBlocks, let rhsDownloadquality)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadquality, rhs: rhsDownloadquality, with: matcher), lhsDownloadquality, rhsDownloadquality, "downloadQuality"))
				return Matcher.ComparisonResult(results)

            case (.m_addToDownloadQueue__tasks_tasks(let lhsTasks), .m_addToDownloadQueue__tasks_tasks(let rhsTasks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTasks, rhs: rhsTasks, with: matcher), lhsTasks, rhsTasks, "tasks"))
				return Matcher.ComparisonResult(results)

            case (.m_nextBlockForDownloading, .m_nextBlockForDownloading): return .match

            case (.m_updateDownloadState__id_idstate_stateresumeData_resumeData(let lhsId, let lhsState, let lhsResumedata), .m_updateDownloadState__id_idstate_stateresumeData_resumeData(let rhsId, let rhsState, let rhsResumedata)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher), lhsId, rhsId, "id"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsState, rhs: rhsState, with: matcher), lhsState, rhsState, "state"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResumedata, rhs: rhsResumedata, with: matcher), lhsResumedata, rhsResumedata, "resumeData"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteDownloadDataTask__id_id(let lhsId), .m_deleteDownloadDataTask__id_id(let rhsId)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher), lhsId, rhsId, "id"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadDataTask__for_blockId(let lhsBlockid), .m_downloadDataTask__for_blockId(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockId"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadDataTask__for_blockIdcompletion_completion(let lhsBlockid, let lhsCompletion), .m_downloadDataTask__for_blockIdcompletion_completion(let rhsBlockid, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_getDownloadDataTasks__completion_completion(let lhsCompletion), .m_getDownloadDataTasks__completion_completion(let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_getDownloadDataTasksForCourse__courseIdcompletion_completion(let lhsCourseid, let lhsCompletion), .m_getDownloadDataTasksForCourse__courseIdcompletion_completion(let rhsCourseid, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "_ courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_saveOfflineProgress__progress_progress(let lhsProgress), .m_saveOfflineProgress__progress_progress(let rhsProgress)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsProgress, rhs: rhsProgress, with: matcher), lhsProgress, rhsProgress, "progress"))
				return Matcher.ComparisonResult(results)

            case (.m_loadProgress__for_blockID(let lhsBlockid), .m_loadProgress__for_blockID(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockID"))
				return Matcher.ComparisonResult(results)

            case (.m_loadAllOfflineProgress, .m_loadAllOfflineProgress): return .match

            case (.m_deleteProgress__for_blockID(let lhsBlockid), .m_deleteProgress__for_blockID(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockID"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteAllProgress, .m_deleteAllProgress): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_set__userId_userId(p0): return p0.intValue
            case .m_getUserID: return 0
            case .m_publisher: return 0
            case let .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(p0, p1): return p0.intValue + p1.intValue
            case let .m_addToDownloadQueue__tasks_tasks(p0): return p0.intValue
            case .m_nextBlockForDownloading: return 0
            case let .m_updateDownloadState__id_idstate_stateresumeData_resumeData(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_deleteDownloadDataTask__id_id(p0): return p0.intValue
            case let .m_downloadDataTask__for_blockId(p0): return p0.intValue
            case let .m_downloadDataTask__for_blockIdcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_getDownloadDataTasks__completion_completion(p0): return p0.intValue
            case let .m_getDownloadDataTasksForCourse__courseIdcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_saveOfflineProgress__progress_progress(p0): return p0.intValue
            case let .m_loadProgress__for_blockID(p0): return p0.intValue
            case .m_loadAllOfflineProgress: return 0
            case let .m_deleteProgress__for_blockID(p0): return p0.intValue
            case .m_deleteAllProgress: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_set__userId_userId: return ".set(userId:)"
            case .m_getUserID: return ".getUserID()"
            case .m_publisher: return ".publisher()"
            case .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality: return ".addToDownloadQueue(blocks:downloadQuality:)"
            case .m_addToDownloadQueue__tasks_tasks: return ".addToDownloadQueue(tasks:)"
            case .m_nextBlockForDownloading: return ".nextBlockForDownloading()"
            case .m_updateDownloadState__id_idstate_stateresumeData_resumeData: return ".updateDownloadState(id:state:resumeData:)"
            case .m_deleteDownloadDataTask__id_id: return ".deleteDownloadDataTask(id:)"
            case .m_downloadDataTask__for_blockId: return ".downloadDataTask(for:)"
            case .m_downloadDataTask__for_blockIdcompletion_completion: return ".downloadDataTask(for:completion:)"
            case .m_getDownloadDataTasks__completion_completion: return ".getDownloadDataTasks(completion:)"
            case .m_getDownloadDataTasksForCourse__courseIdcompletion_completion: return ".getDownloadDataTasksForCourse(_:completion:)"
            case .m_saveOfflineProgress__progress_progress: return ".saveOfflineProgress(progress:)"
            case .m_loadProgress__for_blockID: return ".loadProgress(for:)"
            case .m_loadAllOfflineProgress: return ".loadAllOfflineProgress()"
            case .m_deleteProgress__for_blockID: return ".deleteProgress(for:)"
            case .m_deleteAllProgress: return ".deleteAllProgress()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getUserID(willReturn: Int?...) -> MethodStub {
            return Given(method: .m_getUserID, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func publisher(willReturn: AnyPublisher<Int, Never>...) -> MethodStub {
            return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func nextBlockForDownloading(willReturn: DownloadDataTask?...) -> MethodStub {
            return Given(method: .m_nextBlockForDownloading, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func downloadDataTask(for blockId: Parameter<String>, willReturn: DownloadDataTask?...) -> MethodStub {
            return Given(method: .m_downloadDataTask__for_blockId(`blockId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func loadProgress(for blockID: Parameter<String>, willReturn: OfflineProgress?...) -> MethodStub {
            return Given(method: .m_loadProgress__for_blockID(`blockID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func loadAllOfflineProgress(willReturn: [OfflineProgress]...) -> MethodStub {
            return Given(method: .m_loadAllOfflineProgress, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getUserID(willProduce: (Stubber<Int?>) -> Void) -> MethodStub {
            let willReturn: [Int?] = []
			let given: Given = { return Given(method: .m_getUserID, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Int?).self)
			willProduce(stubber)
			return given
        }
        public static func publisher(willProduce: (Stubber<AnyPublisher<Int, Never>>) -> Void) -> MethodStub {
            let willReturn: [AnyPublisher<Int, Never>] = []
			let given: Given = { return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AnyPublisher<Int, Never>).self)
			willProduce(stubber)
			return given
        }
        public static func nextBlockForDownloading(willProduce: (Stubber<DownloadDataTask?>) -> Void) -> MethodStub {
            let willReturn: [DownloadDataTask?] = []
			let given: Given = { return Given(method: .m_nextBlockForDownloading, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (DownloadDataTask?).self)
			willProduce(stubber)
			return given
        }
        public static func downloadDataTask(for blockId: Parameter<String>, willProduce: (Stubber<DownloadDataTask?>) -> Void) -> MethodStub {
            let willReturn: [DownloadDataTask?] = []
			let given: Given = { return Given(method: .m_downloadDataTask__for_blockId(`blockId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (DownloadDataTask?).self)
			willProduce(stubber)
			return given
        }
        public static func loadProgress(for blockID: Parameter<String>, willProduce: (Stubber<OfflineProgress?>) -> Void) -> MethodStub {
            let willReturn: [OfflineProgress?] = []
			let given: Given = { return Given(method: .m_loadProgress__for_blockID(`blockID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (OfflineProgress?).self)
			willProduce(stubber)
			return given
        }
        public static func loadAllOfflineProgress(willProduce: (Stubber<[OfflineProgress]>) -> Void) -> MethodStub {
            let willReturn: [[OfflineProgress]] = []
			let given: Given = { return Given(method: .m_loadAllOfflineProgress, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([OfflineProgress]).self)
			willProduce(stubber)
			return given
        }
        public static func deleteDownloadDataTask(id: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_deleteDownloadDataTask__id_id(`id`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func deleteDownloadDataTask(id: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_deleteDownloadDataTask__id_id(`id`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func set(userId: Parameter<Int>) -> Verify { return Verify(method: .m_set__userId_userId(`userId`))}
        public static func getUserID() -> Verify { return Verify(method: .m_getUserID)}
        public static func publisher() -> Verify { return Verify(method: .m_publisher)}
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, downloadQuality: Parameter<DownloadQuality>) -> Verify { return Verify(method: .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(`blocks`, `downloadQuality`))}
        public static func addToDownloadQueue(tasks: Parameter<[DownloadDataTask]>) -> Verify { return Verify(method: .m_addToDownloadQueue__tasks_tasks(`tasks`))}
        public static func nextBlockForDownloading() -> Verify { return Verify(method: .m_nextBlockForDownloading)}
        public static func updateDownloadState(id: Parameter<String>, state: Parameter<DownloadState>, resumeData: Parameter<Data?>) -> Verify { return Verify(method: .m_updateDownloadState__id_idstate_stateresumeData_resumeData(`id`, `state`, `resumeData`))}
        public static func deleteDownloadDataTask(id: Parameter<String>) -> Verify { return Verify(method: .m_deleteDownloadDataTask__id_id(`id`))}
        public static func downloadDataTask(for blockId: Parameter<String>) -> Verify { return Verify(method: .m_downloadDataTask__for_blockId(`blockId`))}
        public static func downloadDataTask(for blockId: Parameter<String>, completion: Parameter<(DownloadDataTask?) -> Void>) -> Verify { return Verify(method: .m_downloadDataTask__for_blockIdcompletion_completion(`blockId`, `completion`))}
        public static func getDownloadDataTasks(completion: Parameter<([DownloadDataTask]) -> Void>) -> Verify { return Verify(method: .m_getDownloadDataTasks__completion_completion(`completion`))}
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>, completion: Parameter<([DownloadDataTask]) -> Void>) -> Verify { return Verify(method: .m_getDownloadDataTasksForCourse__courseIdcompletion_completion(`courseId`, `completion`))}
        public static func saveOfflineProgress(progress: Parameter<OfflineProgress>) -> Verify { return Verify(method: .m_saveOfflineProgress__progress_progress(`progress`))}
        public static func loadProgress(for blockID: Parameter<String>) -> Verify { return Verify(method: .m_loadProgress__for_blockID(`blockID`))}
        public static func loadAllOfflineProgress() -> Verify { return Verify(method: .m_loadAllOfflineProgress)}
        public static func deleteProgress(for blockID: Parameter<String>) -> Verify { return Verify(method: .m_deleteProgress__for_blockID(`blockID`))}
        public static func deleteAllProgress() -> Verify { return Verify(method: .m_deleteAllProgress)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func set(userId: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_set__userId_userId(`userId`), performs: perform)
        }
        public static func getUserID(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getUserID, performs: perform)
        }
        public static func publisher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_publisher, performs: perform)
        }
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, downloadQuality: Parameter<DownloadQuality>, perform: @escaping ([CourseBlock], DownloadQuality) -> Void) -> Perform {
            return Perform(method: .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(`blocks`, `downloadQuality`), performs: perform)
        }
        public static func addToDownloadQueue(tasks: Parameter<[DownloadDataTask]>, perform: @escaping ([DownloadDataTask]) -> Void) -> Perform {
            return Perform(method: .m_addToDownloadQueue__tasks_tasks(`tasks`), performs: perform)
        }
        public static func nextBlockForDownloading(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_nextBlockForDownloading, performs: perform)
        }
        public static func updateDownloadState(id: Parameter<String>, state: Parameter<DownloadState>, resumeData: Parameter<Data?>, perform: @escaping (String, DownloadState, Data?) -> Void) -> Perform {
            return Perform(method: .m_updateDownloadState__id_idstate_stateresumeData_resumeData(`id`, `state`, `resumeData`), performs: perform)
        }
        public static func deleteDownloadDataTask(id: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_deleteDownloadDataTask__id_id(`id`), performs: perform)
        }
        public static func downloadDataTask(for blockId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_downloadDataTask__for_blockId(`blockId`), performs: perform)
        }
        public static func downloadDataTask(for blockId: Parameter<String>, completion: Parameter<(DownloadDataTask?) -> Void>, perform: @escaping (String, @escaping (DownloadDataTask?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_downloadDataTask__for_blockIdcompletion_completion(`blockId`, `completion`), performs: perform)
        }
        public static func getDownloadDataTasks(completion: Parameter<([DownloadDataTask]) -> Void>, perform: @escaping (@escaping ([DownloadDataTask]) -> Void) -> Void) -> Perform {
            return Perform(method: .m_getDownloadDataTasks__completion_completion(`completion`), performs: perform)
        }
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>, completion: Parameter<([DownloadDataTask]) -> Void>, perform: @escaping (String, @escaping ([DownloadDataTask]) -> Void) -> Void) -> Perform {
            return Perform(method: .m_getDownloadDataTasksForCourse__courseIdcompletion_completion(`courseId`, `completion`), performs: perform)
        }
        public static func saveOfflineProgress(progress: Parameter<OfflineProgress>, perform: @escaping (OfflineProgress) -> Void) -> Perform {
            return Perform(method: .m_saveOfflineProgress__progress_progress(`progress`), performs: perform)
        }
        public static func loadProgress(for blockID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_loadProgress__for_blockID(`blockID`), performs: perform)
        }
        public static func loadAllOfflineProgress(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_loadAllOfflineProgress, performs: perform)
        }
        public static func deleteProgress(for blockID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_deleteProgress__for_blockID(`blockID`), performs: perform)
        }
        public static func deleteAllProgress(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteAllProgress, performs: perform)
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

// MARK: - DiscussionAnalytics

open class DiscussionAnalyticsMock: DiscussionAnalytics, Mock {
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





    open func discussionAllPostsClicked(courseId: String, courseName: String) {
        addInvocation(.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func discussionFollowingClicked(courseId: String, courseName: String) {
        addInvocation(.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func discussionTopicClicked(courseId: String, courseName: String, topicId: String, topicName: String) {
        addInvocation(.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`topicId`), Parameter<String>.value(`topicName`)))
		let perform = methodPerformValue(.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`topicId`), Parameter<String>.value(`topicName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `topicId`, `topicName`)
    }


    fileprivate enum MethodType {
        case m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(let lhsCourseid, let lhsCoursename, let lhsTopicid, let lhsTopicname), .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(let rhsCourseid, let rhsCoursename, let rhsTopicid, let rhsTopicname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicid, rhs: rhsTopicid, with: matcher), lhsTopicid, rhsTopicid, "topicId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicname, rhs: rhsTopicname, with: matcher), lhsTopicname, rhsTopicname, "topicName"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName: return ".discussionAllPostsClicked(courseId:courseName:)"
            case .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName: return ".discussionFollowingClicked(courseId:courseName:)"
            case .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName: return ".discussionTopicClicked(courseId:courseName:topicId:topicName:)"
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

        public static func discussionAllPostsClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func discussionFollowingClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func discussionTopicClicked(courseId: Parameter<String>, courseName: Parameter<String>, topicId: Parameter<String>, topicName: Parameter<String>) -> Verify { return Verify(method: .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(`courseId`, `courseName`, `topicId`, `topicName`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func discussionAllPostsClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionAllPostsClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func discussionFollowingClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionFollowingClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func discussionTopicClicked(courseId: Parameter<String>, courseName: Parameter<String>, topicId: Parameter<String>, topicName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_discussionTopicClicked__courseId_courseIdcourseName_courseNametopicId_topicIdtopicName_topicName(`courseId`, `courseName`, `topicId`, `topicName`), performs: perform)
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





    open func getCourseDiscussionInfo(courseID: String) throws -> DiscussionInfo {
        addInvocation(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: DiscussionInfo
		do {
		    __value = try methodReturnValue(.m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDiscussionInfo(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDiscussionInfo(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
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

    open func getTopic(courseID: String, topicID: String) throws -> Topics {
        addInvocation(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`)))
		let perform = methodPerformValue(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`))) as? (String, String) -> Void
		perform?(`courseID`, `topicID`)
		var __value: Topics
		do {
		    __value = try methodReturnValue(.m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>.value(`courseID`), Parameter<String>.value(`topicID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getTopic(courseID: String, topicID: String). Use given")
			Failure("Stub return value not specified for getTopic(courseID: String, topicID: String). Use given")
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

    open func getThread(threadID: String) throws -> UserThread {
        addInvocation(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`)))
		let perform = methodPerformValue(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`))) as? (String) -> Void
		perform?(`threadID`)
		var __value: UserThread
		do {
		    __value = try methodReturnValue(.m_getThread__threadID_threadID(Parameter<String>.value(`threadID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getThread(threadID: String). Use given")
			Failure("Stub return value not specified for getThread(threadID: String). Use given")
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

    open func getResponse(responseID: String) throws -> UserComment {
        addInvocation(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`)))
		let perform = methodPerformValue(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`))) as? (String) -> Void
		perform?(`responseID`)
		var __value: UserComment
		do {
		    __value = try methodReturnValue(.m_getResponse__responseID_responseID(Parameter<String>.value(`responseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getResponse(responseID: String). Use given")
			Failure("Stub return value not specified for getResponse(responseID: String). Use given")
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
        case m_getCourseDiscussionInfo__courseID_courseID(Parameter<String>)
        case m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(Parameter<String>, Parameter<ThreadType>, Parameter<SortType>, Parameter<ThreadsFilter>, Parameter<Int>)
        case m_getTopics__courseID_courseID(Parameter<String>)
        case m_getTopic__courseID_courseIDtopicID_topicID(Parameter<String>, Parameter<String>)
        case m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_getThread__threadID_threadID(Parameter<String>)
        case m_getDiscussionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getQuestionComments__threadID_threadIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getCommentResponses__commentID_commentIDpage_page(Parameter<String>, Parameter<Int>)
        case m_getResponse__responseID_responseID(Parameter<String>)
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
            case (.m_getCourseDiscussionInfo__courseID_courseID(let lhsCourseid), .m_getCourseDiscussionInfo__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

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

            case (.m_getTopic__courseID_courseIDtopicID_topicID(let lhsCourseid, let lhsTopicid), .m_getTopic__courseID_courseIDtopicID_topicID(let rhsCourseid, let rhsTopicid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopicid, rhs: rhsTopicid, with: matcher), lhsTopicid, rhsTopicid, "topicID"))
				return Matcher.ComparisonResult(results)

            case (.m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let lhsCourseid, let lhsSearchtext, let lhsPagenumber), .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(let rhsCourseid, let rhsSearchtext, let rhsPagenumber)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSearchtext, rhs: rhsSearchtext, with: matcher), lhsSearchtext, rhsSearchtext, "searchText"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPagenumber, rhs: rhsPagenumber, with: matcher), lhsPagenumber, rhsPagenumber, "pageNumber"))
				return Matcher.ComparisonResult(results)

            case (.m_getThread__threadID_threadID(let lhsThreadid), .m_getThread__threadID_threadID(let rhsThreadid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadid, rhs: rhsThreadid, with: matcher), lhsThreadid, rhsThreadid, "threadID"))
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

            case (.m_getResponse__responseID_responseID(let lhsResponseid), .m_getResponse__responseID_responseID(let rhsResponseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsResponseid, rhs: rhsResponseid, with: matcher), lhsResponseid, rhsResponseid, "responseID"))
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
            case let .m_getCourseDiscussionInfo__courseID_courseID(p0): return p0.intValue
            case let .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_getTopics__courseID_courseID(p0): return p0.intValue
            case let .m_getTopic__courseID_courseIDtopicID_topicID(p0, p1): return p0.intValue + p1.intValue
            case let .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_getThread__threadID_threadID(p0): return p0.intValue
            case let .m_getDiscussionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getQuestionComments__threadID_threadIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getCommentResponses__commentID_commentIDpage_page(p0, p1): return p0.intValue + p1.intValue
            case let .m_getResponse__responseID_responseID(p0): return p0.intValue
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
            case .m_getCourseDiscussionInfo__courseID_courseID: return ".getCourseDiscussionInfo(courseID:)"
            case .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page: return ".getThreadsList(courseID:type:sort:filter:page:)"
            case .m_getTopics__courseID_courseID: return ".getTopics(courseID:)"
            case .m_getTopic__courseID_courseIDtopicID_topicID: return ".getTopic(courseID:topicID:)"
            case .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber: return ".searchThreads(courseID:searchText:pageNumber:)"
            case .m_getThread__threadID_threadID: return ".getThread(threadID:)"
            case .m_getDiscussionComments__threadID_threadIDpage_page: return ".getDiscussionComments(threadID:page:)"
            case .m_getQuestionComments__threadID_threadIDpage_page: return ".getQuestionComments(threadID:page:)"
            case .m_getCommentResponses__commentID_commentIDpage_page: return ".getCommentResponses(commentID:page:)"
            case .m_getResponse__responseID_responseID: return ".getResponse(responseID:)"
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


        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willReturn: DiscussionInfo...) -> MethodStub {
            return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTopics(courseID: Parameter<String>, willReturn: Topics...) -> MethodStub {
            return Given(method: .m_getTopics__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willReturn: Topics...) -> MethodStub {
            return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, willReturn: ThreadLists...) -> MethodStub {
            return Given(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getThread(threadID: Parameter<String>, willReturn: UserThread...) -> MethodStub {
            return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func getResponse(responseID: Parameter<String>, willReturn: UserComment...) -> MethodStub {
            return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func addCommentTo(threadID: Parameter<String>, rawBody: Parameter<String>, parentID: Parameter<String?>, willReturn: Post...) -> MethodStub {
            return Given(method: .m_addCommentTo__threadID_threadIDrawBody_rawBodyparentID_parentID(`threadID`, `rawBody`, `parentID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDiscussionInfo(courseID: Parameter<String>, willProduce: (StubberThrows<DiscussionInfo>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (DiscussionInfo).self)
			willProduce(stubber)
			return given
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
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, willProduce: (StubberThrows<Topics>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), products: willThrow.map({ StubProduct.throw($0) })) }()
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
        public static func getThread(threadID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getThread(threadID: Parameter<String>, willProduce: (StubberThrows<UserThread>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getThread__threadID_threadID(`threadID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserThread).self)
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
        public static func getResponse(responseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getResponse(responseID: Parameter<String>, willProduce: (StubberThrows<UserComment>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getResponse__responseID_responseID(`responseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UserComment).self)
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

        public static func getCourseDiscussionInfo(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`))}
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`))}
        public static func getTopics(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getTopics__courseID_courseID(`courseID`))}
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>) -> Verify { return Verify(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`))}
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>) -> Verify { return Verify(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`))}
        public static func getThread(threadID: Parameter<String>) -> Verify { return Verify(method: .m_getThread__threadID_threadID(`threadID`))}
        public static func getDiscussionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getDiscussionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getQuestionComments(threadID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getQuestionComments__threadID_threadIDpage_page(`threadID`, `page`))}
        public static func getCommentResponses(commentID: Parameter<String>, page: Parameter<Int>) -> Verify { return Verify(method: .m_getCommentResponses__commentID_commentIDpage_page(`commentID`, `page`))}
        public static func getResponse(responseID: Parameter<String>) -> Verify { return Verify(method: .m_getResponse__responseID_responseID(`responseID`))}
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

        public static func getCourseDiscussionInfo(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDiscussionInfo__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getThreadsList(courseID: Parameter<String>, type: Parameter<ThreadType>, sort: Parameter<SortType>, filter: Parameter<ThreadsFilter>, page: Parameter<Int>, perform: @escaping (String, ThreadType, SortType, ThreadsFilter, Int) -> Void) -> Perform {
            return Perform(method: .m_getThreadsList__courseID_courseIDtype_typesort_sortfilter_filterpage_page(`courseID`, `type`, `sort`, `filter`, `page`), performs: perform)
        }
        public static func getTopics(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getTopics__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getTopic(courseID: Parameter<String>, topicID: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_getTopic__courseID_courseIDtopicID_topicID(`courseID`, `topicID`), performs: perform)
        }
        public static func searchThreads(courseID: Parameter<String>, searchText: Parameter<String>, pageNumber: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_searchThreads__courseID_courseIDsearchText_searchTextpageNumber_pageNumber(`courseID`, `searchText`, `pageNumber`), performs: perform)
        }
        public static func getThread(threadID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getThread__threadID_threadID(`threadID`), performs: perform)
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
        public static func getResponse(responseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getResponse__responseID_responseID(`responseID`), performs: perform)
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





    open func showUserDetails(username: String) {
        addInvocation(.m_showUserDetails__username_username(Parameter<String>.value(`username`)))
		let perform = methodPerformValue(.m_showUserDetails__username_username(Parameter<String>.value(`username`))) as? (String) -> Void
		perform?(`username`)
    }

    open func showThreads(courseID: String, topics: Topics, title: String, type: ThreadType, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`courseID`), Parameter<Topics>.value(`topics`), Parameter<String>.value(`title`), Parameter<ThreadType>.value(`type`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (String, Topics, String, ThreadType, Bool, Bool) -> Void
		perform?(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`)
    }

    open func showThread(thread: UserThread, postStateSubject: CurrentValueSubject<PostState?, Never>, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>.value(`thread`), Parameter<CurrentValueSubject<PostState?, Never>>.value(`postStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (UserThread, CurrentValueSubject<PostState?, Never>, Bool, Bool) -> Void
		perform?(`thread`, `postStateSubject`, `isBlackedOut`, `animated`)
    }

    open func showDiscussionsSearch(courseID: String, isBlackedOut: Bool) {
        addInvocation(.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`isBlackedOut`)))
		let perform = methodPerformValue(.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`isBlackedOut`))) as? (String, Bool) -> Void
		perform?(`courseID`, `isBlackedOut`)
    }

    open func showComments(commentID: String, parentComment: Post, threadStateSubject: CurrentValueSubject<ThreadPostState?, Never>, isBlackedOut: Bool, animated: Bool) {
        addInvocation(.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`)))
		let perform = methodPerformValue(.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>.value(`commentID`), Parameter<Post>.value(`parentComment`), Parameter<CurrentValueSubject<ThreadPostState?, Never>>.value(`threadStateSubject`), Parameter<Bool>.value(`isBlackedOut`), Parameter<Bool>.value(`animated`))) as? (String, Post, CurrentValueSubject<ThreadPostState?, Never>, Bool, Bool) -> Void
		perform?(`commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`)
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

    open func showMainOrWhatsNewScreen(sourceScreen: LogistrationSourceScreen) {
        addInvocation(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`)))
		let perform = methodPerformValue(.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>.value(`sourceScreen`))) as? (LogistrationSourceScreen) -> Void
		perform?(`sourceScreen`)
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
        case m_showUserDetails__username_username(Parameter<String>)
        case m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(Parameter<String>, Parameter<Topics>, Parameter<String>, Parameter<ThreadType>, Parameter<Bool>, Parameter<Bool>)
        case m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<UserThread>, Parameter<CurrentValueSubject<PostState?, Never>>, Parameter<Bool>, Parameter<Bool>)
        case m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(Parameter<String>, Parameter<Bool>)
        case m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(Parameter<String>, Parameter<Post>, Parameter<CurrentValueSubject<ThreadPostState?, Never>>, Parameter<Bool>, Parameter<Bool>)
        case m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(Parameter<String>, Parameter<String>, Parameter<() -> Void>)
        case m_backToRoot__animated_animated(Parameter<Bool>)
        case m_back__animated_animated(Parameter<Bool>)
        case m_backWithFade
        case m_dismiss__animated_animated(Parameter<Bool>)
        case m_removeLastView__controllers_controllers(Parameter<Int>)
        case m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showStartupScreen
        case m_showLoginScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showRegisterScreen__sourceScreen_sourceScreen(Parameter<LogistrationSourceScreen>)
        case m_showForgotPasswordScreen
        case m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(Parameter<String?>, Parameter<LogistrationSourceScreen>)
        case m_showWebBrowser__title_titleurl_url(Parameter<String>, Parameter<URL>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>, Parameter<any View>, Parameter<(() -> Void)?>)
        case m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>, Parameter<Bool>, Parameter<() -> any View>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_showUserDetails__username_username(let lhsUsername), .m_showUserDetails__username_username(let rhsUsername)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				return Matcher.ComparisonResult(results)

            case (.m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(let lhsCourseid, let lhsTopics, let lhsTitle, let lhsType, let lhsIsblackedout, let lhsAnimated), .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(let rhsCourseid, let rhsTopics, let rhsTitle, let rhsType, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTopics, rhs: rhsTopics, with: matcher), lhsTopics, rhsTopics, "topics"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(let lhsThread, let lhsPoststatesubject, let lhsIsblackedout, let lhsAnimated), .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(let rhsThread, let rhsPoststatesubject, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThread, rhs: rhsThread, with: matcher), lhsThread, rhsThread, "thread"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPoststatesubject, rhs: rhsPoststatesubject, with: matcher), lhsPoststatesubject, rhsPoststatesubject, "postStateSubject"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				return Matcher.ComparisonResult(results)

            case (.m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(let lhsCourseid, let lhsIsblackedout), .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(let rhsCourseid, let rhsIsblackedout)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				return Matcher.ComparisonResult(results)

            case (.m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(let lhsCommentid, let lhsParentcomment, let lhsThreadstatesubject, let lhsIsblackedout, let lhsAnimated), .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(let rhsCommentid, let rhsParentcomment, let rhsThreadstatesubject, let rhsIsblackedout, let rhsAnimated)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCommentid, rhs: rhsCommentid, with: matcher), lhsCommentid, rhsCommentid, "commentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsParentcomment, rhs: rhsParentcomment, with: matcher), lhsParentcomment, rhsParentcomment, "parentComment"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsThreadstatesubject, rhs: rhsThreadstatesubject, with: matcher), lhsThreadstatesubject, rhsThreadstatesubject, "threadStateSubject"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIsblackedout, rhs: rhsIsblackedout, with: matcher), lhsIsblackedout, rhsIsblackedout, "isBlackedOut"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
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

            case (.m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(let lhsSourcescreen), .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(let rhsSourcescreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSourcescreen, rhs: rhsSourcescreen, with: matcher), lhsSourcescreen, rhsSourcescreen, "sourceScreen"))
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
            case let .m_showUserDetails__username_username(p0): return p0.intValue
            case let .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(p0, p1): return p0.intValue + p1.intValue
            case let .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_backToRoot__animated_animated(p0): return p0.intValue
            case let .m_back__animated_animated(p0): return p0.intValue
            case .m_backWithFade: return 0
            case let .m_dismiss__animated_animated(p0): return p0.intValue
            case let .m_removeLastView__controllers_controllers(p0): return p0.intValue
            case let .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showStartupScreen: return 0
            case let .m_showLoginScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case let .m_showRegisterScreen__sourceScreen_sourceScreen(p0): return p0.intValue
            case .m_showForgotPasswordScreen: return 0
            case let .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(p0, p1): return p0.intValue + p1.intValue
            case let .m_showWebBrowser__title_titleurl_url(p0, p1): return p0.intValue + p1.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_showUserDetails__username_username: return ".showUserDetails(username:)"
            case .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated: return ".showThreads(courseID:topics:title:type:isBlackedOut:animated:)"
            case .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated: return ".showThread(thread:postStateSubject:isBlackedOut:animated:)"
            case .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut: return ".showDiscussionsSearch(courseID:isBlackedOut:)"
            case .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated: return ".showComments(commentID:parentComment:threadStateSubject:isBlackedOut:animated:)"
            case .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated: return ".createNewThread(courseID:selectedTopic:onPostCreated:)"
            case .m_backToRoot__animated_animated: return ".backToRoot(animated:)"
            case .m_back__animated_animated: return ".back(animated:)"
            case .m_backWithFade: return ".backWithFade()"
            case .m_dismiss__animated_animated: return ".dismiss(animated:)"
            case .m_removeLastView__controllers_controllers: return ".removeLastView(controllers:)"
            case .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen: return ".showMainOrWhatsNewScreen(sourceScreen:)"
            case .m_showStartupScreen: return ".showStartupScreen()"
            case .m_showLoginScreen__sourceScreen_sourceScreen: return ".showLoginScreen(sourceScreen:)"
            case .m_showRegisterScreen__sourceScreen_sourceScreen: return ".showRegisterScreen(sourceScreen:)"
            case .m_showForgotPasswordScreen: return ".showForgotPasswordScreen()"
            case .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen: return ".showDiscoveryScreen(searchQuery:sourceScreen:)"
            case .m_showWebBrowser__title_titleurl_url: return ".showWebBrowser(title:url:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type: return ".presentAlert(alertTitle:alertMessage:positiveAction:onCloseTapped:okTapped:type:)"
            case .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped: return ".presentAlert(alertTitle:alertMessage:nextSectionName:action:image:onCloseTapped:okTapped:nextSectionTapped:)"
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

        public static func showUserDetails(username: Parameter<String>) -> Verify { return Verify(method: .m_showUserDetails__username_username(`username`))}
        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`))}
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(`thread`, `postStateSubject`, `isBlackedOut`, `animated`))}
        public static func showDiscussionsSearch(courseID: Parameter<String>, isBlackedOut: Parameter<Bool>) -> Verify { return Verify(method: .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(`courseID`, `isBlackedOut`))}
        public static func showComments(commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>) -> Verify { return Verify(method: .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(`commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`))}
        public static func createNewThread(courseID: Parameter<String>, selectedTopic: Parameter<String>, onPostCreated: Parameter<() -> Void>) -> Verify { return Verify(method: .m_createNewThread__courseID_courseIDselectedTopic_selectedTopiconPostCreated_onPostCreated(`courseID`, `selectedTopic`, `onPostCreated`))}
        public static func backToRoot(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_backToRoot__animated_animated(`animated`))}
        public static func back(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_back__animated_animated(`animated`))}
        public static func backWithFade() -> Verify { return Verify(method: .m_backWithFade)}
        public static func dismiss(animated: Parameter<Bool>) -> Verify { return Verify(method: .m_dismiss__animated_animated(`animated`))}
        public static func removeLastView(controllers: Parameter<Int>) -> Verify { return Verify(method: .m_removeLastView__controllers_controllers(`controllers`))}
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showStartupScreen() -> Verify { return Verify(method: .m_showStartupScreen)}
        public static func showLoginScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showLoginScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showRegisterScreen(sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showRegisterScreen__sourceScreen_sourceScreen(`sourceScreen`))}
        public static func showForgotPasswordScreen() -> Verify { return Verify(method: .m_showForgotPasswordScreen)}
        public static func showDiscoveryScreen(searchQuery: Parameter<String?>, sourceScreen: Parameter<LogistrationSourceScreen>) -> Verify { return Verify(method: .m_showDiscoveryScreen__searchQuery_searchQuerysourceScreen_sourceScreen(`searchQuery`, `sourceScreen`))}
        public static func showWebBrowser(title: Parameter<String>, url: Parameter<URL>) -> Verify { return Verify(method: .m_showWebBrowser__title_titleurl_url(`title`, `url`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func showUserDetails(username: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showUserDetails__username_username(`username`), performs: perform)
        }
        public static func showThreads(courseID: Parameter<String>, topics: Parameter<Topics>, title: Parameter<String>, type: Parameter<ThreadType>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (String, Topics, String, ThreadType, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showThreads__courseID_courseIDtopics_topicstitle_titletype_typeisBlackedOut_isBlackedOutanimated_animated(`courseID`, `topics`, `title`, `type`, `isBlackedOut`, `animated`), performs: perform)
        }
        public static func showThread(thread: Parameter<UserThread>, postStateSubject: Parameter<CurrentValueSubject<PostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (UserThread, CurrentValueSubject<PostState?, Never>, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showThread__thread_threadpostStateSubject_postStateSubjectisBlackedOut_isBlackedOutanimated_animated(`thread`, `postStateSubject`, `isBlackedOut`, `animated`), performs: perform)
        }
        public static func showDiscussionsSearch(courseID: Parameter<String>, isBlackedOut: Parameter<Bool>, perform: @escaping (String, Bool) -> Void) -> Perform {
            return Perform(method: .m_showDiscussionsSearch__courseID_courseIDisBlackedOut_isBlackedOut(`courseID`, `isBlackedOut`), performs: perform)
        }
        public static func showComments(commentID: Parameter<String>, parentComment: Parameter<Post>, threadStateSubject: Parameter<CurrentValueSubject<ThreadPostState?, Never>>, isBlackedOut: Parameter<Bool>, animated: Parameter<Bool>, perform: @escaping (String, Post, CurrentValueSubject<ThreadPostState?, Never>, Bool, Bool) -> Void) -> Perform {
            return Perform(method: .m_showComments__commentID_commentIDparentComment_parentCommentthreadStateSubject_threadStateSubjectisBlackedOut_isBlackedOutanimated_animated(`commentID`, `parentComment`, `threadStateSubject`, `isBlackedOut`, `animated`), performs: perform)
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
        public static func showMainOrWhatsNewScreen(sourceScreen: Parameter<LogistrationSourceScreen>, perform: @escaping (LogistrationSourceScreen) -> Void) -> Perform {
            return Perform(method: .m_showMainOrWhatsNewScreen__sourceScreen_sourceScreen(`sourceScreen`), performs: perform)
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
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>, perform: @escaping (String, String, String, @escaping () -> Void, @escaping () -> Void, AlertViewType) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`), performs: perform)
        }
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>, perform: @escaping (String, String, String?, String, SwiftUI.Image, @escaping () -> Void, @escaping () -> Void, @escaping () -> Void) -> Void) -> Perform {
            return Perform(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`), performs: perform)
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

// MARK: - DownloadManagerProtocol

open class DownloadManagerProtocolMock: DownloadManagerProtocol, Mock {
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

    public var currentDownloadTask: DownloadDataTask? {
		get {	invocations.append(.p_currentDownloadTask_get); return __p_currentDownloadTask ?? optionalGivenGetterValue(.p_currentDownloadTask_get, "DownloadManagerProtocolMock - stub value for currentDownloadTask was not defined") }
	}
	private var __p_currentDownloadTask: (DownloadDataTask)?





    open func publisher() -> AnyPublisher<Int, Never> {
        addInvocation(.m_publisher)
		let perform = methodPerformValue(.m_publisher) as? () -> Void
		perform?()
		var __value: AnyPublisher<Int, Never>
		do {
		    __value = try methodReturnValue(.m_publisher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for publisher(). Use given")
			Failure("Stub return value not specified for publisher(). Use given")
		}
		return __value
    }

    open func eventPublisher() -> AnyPublisher<DownloadManagerEvent, Never> {
        addInvocation(.m_eventPublisher)
		let perform = methodPerformValue(.m_eventPublisher) as? () -> Void
		perform?()
		var __value: AnyPublisher<DownloadManagerEvent, Never>
		do {
		    __value = try methodReturnValue(.m_eventPublisher).casted()
		} catch {
			onFatalFailure("Stub return value not specified for eventPublisher(). Use given")
			Failure("Stub return value not specified for eventPublisher(). Use given")
		}
		return __value
    }

    open func addToDownloadQueue(blocks: [CourseBlock]) throws {
        addInvocation(.m_addToDownloadQueue__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`)))
		let perform = methodPerformValue(.m_addToDownloadQueue__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))) as? ([CourseBlock]) -> Void
		perform?(`blocks`)
		do {
		    _ = try methodReturnValue(.m_addToDownloadQueue__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func getDownloadTasks() -> [DownloadDataTask] {
        addInvocation(.m_getDownloadTasks)
		let perform = methodPerformValue(.m_getDownloadTasks) as? () -> Void
		perform?()
		var __value: [DownloadDataTask]
		do {
		    __value = try methodReturnValue(.m_getDownloadTasks).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getDownloadTasks(). Use given")
			Failure("Stub return value not specified for getDownloadTasks(). Use given")
		}
		return __value
    }

    open func getDownloadTasksForCourse(_ courseId: String) -> [DownloadDataTask] {
        addInvocation(.m_getDownloadTasksForCourse__courseId(Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_getDownloadTasksForCourse__courseId(Parameter<String>.value(`courseId`))) as? (String) -> Void
		perform?(`courseId`)
		var __value: [DownloadDataTask]
		do {
		    __value = try methodReturnValue(.m_getDownloadTasksForCourse__courseId(Parameter<String>.value(`courseId`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getDownloadTasksForCourse(_ courseId: String). Use given")
			Failure("Stub return value not specified for getDownloadTasksForCourse(_ courseId: String). Use given")
		}
		return __value
    }

    open func cancelDownloading(courseId: String, blocks: [CourseBlock]) throws {
        addInvocation(.m_cancelDownloading__courseId_courseIdblocks_blocks(Parameter<String>.value(`courseId`), Parameter<[CourseBlock]>.value(`blocks`)))
		let perform = methodPerformValue(.m_cancelDownloading__courseId_courseIdblocks_blocks(Parameter<String>.value(`courseId`), Parameter<[CourseBlock]>.value(`blocks`))) as? (String, [CourseBlock]) -> Void
		perform?(`courseId`, `blocks`)
		do {
		    _ = try methodReturnValue(.m_cancelDownloading__courseId_courseIdblocks_blocks(Parameter<String>.value(`courseId`), Parameter<[CourseBlock]>.value(`blocks`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func cancelDownloading(task: DownloadDataTask) throws {
        addInvocation(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`)))
		let perform = methodPerformValue(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`))) as? (DownloadDataTask) -> Void
		perform?(`task`)
		do {
		    _ = try methodReturnValue(.m_cancelDownloading__task_task(Parameter<DownloadDataTask>.value(`task`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func cancelDownloading(courseId: String) throws {
        addInvocation(.m_cancelDownloading__courseId_courseId(Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_cancelDownloading__courseId_courseId(Parameter<String>.value(`courseId`))) as? (String) -> Void
		perform?(`courseId`)
		do {
		    _ = try methodReturnValue(.m_cancelDownloading__courseId_courseId(Parameter<String>.value(`courseId`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func cancelAllDownloading() throws {
        addInvocation(.m_cancelAllDownloading)
		let perform = methodPerformValue(.m_cancelAllDownloading) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_cancelAllDownloading).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func deleteFile(blocks: [CourseBlock]) {
        addInvocation(.m_deleteFile__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`)))
		let perform = methodPerformValue(.m_deleteFile__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))) as? ([CourseBlock]) -> Void
		perform?(`blocks`)
    }

    open func deleteAllFiles() {
        addInvocation(.m_deleteAllFiles)
		let perform = methodPerformValue(.m_deleteAllFiles) as? () -> Void
		perform?()
    }

    open func fileUrl(for blockId: String) -> URL? {
        addInvocation(.m_fileUrl__for_blockId(Parameter<String>.value(`blockId`)))
		let perform = methodPerformValue(.m_fileUrl__for_blockId(Parameter<String>.value(`blockId`))) as? (String) -> Void
		perform?(`blockId`)
		var __value: URL? = nil
		do {
		    __value = try methodReturnValue(.m_fileUrl__for_blockId(Parameter<String>.value(`blockId`))).casted()
		} catch {
			// do nothing
		}
		return __value
    }

    open func updateUnzippedFileSize(for sequentials: [CourseSequential]) -> [CourseSequential] {
        addInvocation(.m_updateUnzippedFileSize__for_sequentials(Parameter<[CourseSequential]>.value(`sequentials`)))
		let perform = methodPerformValue(.m_updateUnzippedFileSize__for_sequentials(Parameter<[CourseSequential]>.value(`sequentials`))) as? ([CourseSequential]) -> Void
		perform?(`sequentials`)
		var __value: [CourseSequential]
		do {
		    __value = try methodReturnValue(.m_updateUnzippedFileSize__for_sequentials(Parameter<[CourseSequential]>.value(`sequentials`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for updateUnzippedFileSize(for sequentials: [CourseSequential]). Use given")
			Failure("Stub return value not specified for updateUnzippedFileSize(for sequentials: [CourseSequential]). Use given")
		}
		return __value
    }

    open func resumeDownloading() throws {
        addInvocation(.m_resumeDownloading)
		let perform = methodPerformValue(.m_resumeDownloading) as? () -> Void
		perform?()
		do {
		    _ = try methodReturnValue(.m_resumeDownloading).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }

    open func isLargeVideosSize(blocks: [CourseBlock]) -> Bool {
        addInvocation(.m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`)))
		let perform = methodPerformValue(.m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))) as? ([CourseBlock]) -> Void
		perform?(`blocks`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>.value(`blocks`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isLargeVideosSize(blocks: [CourseBlock]). Use given")
			Failure("Stub return value not specified for isLargeVideosSize(blocks: [CourseBlock]). Use given")
		}
		return __value
    }

    open func removeAppSupportDirectoryUnusedContent() {
        addInvocation(.m_removeAppSupportDirectoryUnusedContent)
		let perform = methodPerformValue(.m_removeAppSupportDirectoryUnusedContent) as? () -> Void
		perform?()
    }


    fileprivate enum MethodType {
        case m_publisher
        case m_eventPublisher
        case m_addToDownloadQueue__blocks_blocks(Parameter<[CourseBlock]>)
        case m_getDownloadTasks
        case m_getDownloadTasksForCourse__courseId(Parameter<String>)
        case m_cancelDownloading__courseId_courseIdblocks_blocks(Parameter<String>, Parameter<[CourseBlock]>)
        case m_cancelDownloading__task_task(Parameter<DownloadDataTask>)
        case m_cancelDownloading__courseId_courseId(Parameter<String>)
        case m_cancelAllDownloading
        case m_deleteFile__blocks_blocks(Parameter<[CourseBlock]>)
        case m_deleteAllFiles
        case m_fileUrl__for_blockId(Parameter<String>)
        case m_updateUnzippedFileSize__for_sequentials(Parameter<[CourseSequential]>)
        case m_resumeDownloading
        case m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>)
        case m_removeAppSupportDirectoryUnusedContent
        case p_currentDownloadTask_get

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_publisher, .m_publisher): return .match

            case (.m_eventPublisher, .m_eventPublisher): return .match

            case (.m_addToDownloadQueue__blocks_blocks(let lhsBlocks), .m_addToDownloadQueue__blocks_blocks(let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)

            case (.m_getDownloadTasks, .m_getDownloadTasks): return .match

            case (.m_getDownloadTasksForCourse__courseId(let lhsCourseid), .m_getDownloadTasksForCourse__courseId(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "_ courseId"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelDownloading__courseId_courseIdblocks_blocks(let lhsCourseid, let lhsBlocks), .m_cancelDownloading__courseId_courseIdblocks_blocks(let rhsCourseid, let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelDownloading__task_task(let lhsTask), .m_cancelDownloading__task_task(let rhsTask)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTask, rhs: rhsTask, with: matcher), lhsTask, rhsTask, "task"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelDownloading__courseId_courseId(let lhsCourseid), .m_cancelDownloading__courseId_courseId(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				return Matcher.ComparisonResult(results)

            case (.m_cancelAllDownloading, .m_cancelAllDownloading): return .match

            case (.m_deleteFile__blocks_blocks(let lhsBlocks), .m_deleteFile__blocks_blocks(let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)

            case (.m_deleteAllFiles, .m_deleteAllFiles): return .match

            case (.m_fileUrl__for_blockId(let lhsBlockid), .m_fileUrl__for_blockId(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockId"))
				return Matcher.ComparisonResult(results)

            case (.m_updateUnzippedFileSize__for_sequentials(let lhsSequentials), .m_updateUnzippedFileSize__for_sequentials(let rhsSequentials)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSequentials, rhs: rhsSequentials, with: matcher), lhsSequentials, rhsSequentials, "for sequentials"))
				return Matcher.ComparisonResult(results)

            case (.m_resumeDownloading, .m_resumeDownloading): return .match

            case (.m_isLargeVideosSize__blocks_blocks(let lhsBlocks), .m_isLargeVideosSize__blocks_blocks(let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)

            case (.m_removeAppSupportDirectoryUnusedContent, .m_removeAppSupportDirectoryUnusedContent): return .match
            case (.p_currentDownloadTask_get,.p_currentDownloadTask_get): return Matcher.ComparisonResult.match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_publisher: return 0
            case .m_eventPublisher: return 0
            case let .m_addToDownloadQueue__blocks_blocks(p0): return p0.intValue
            case .m_getDownloadTasks: return 0
            case let .m_getDownloadTasksForCourse__courseId(p0): return p0.intValue
            case let .m_cancelDownloading__courseId_courseIdblocks_blocks(p0, p1): return p0.intValue + p1.intValue
            case let .m_cancelDownloading__task_task(p0): return p0.intValue
            case let .m_cancelDownloading__courseId_courseId(p0): return p0.intValue
            case .m_cancelAllDownloading: return 0
            case let .m_deleteFile__blocks_blocks(p0): return p0.intValue
            case .m_deleteAllFiles: return 0
            case let .m_fileUrl__for_blockId(p0): return p0.intValue
            case let .m_updateUnzippedFileSize__for_sequentials(p0): return p0.intValue
            case .m_resumeDownloading: return 0
            case let .m_isLargeVideosSize__blocks_blocks(p0): return p0.intValue
            case .m_removeAppSupportDirectoryUnusedContent: return 0
            case .p_currentDownloadTask_get: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_publisher: return ".publisher()"
            case .m_eventPublisher: return ".eventPublisher()"
            case .m_addToDownloadQueue__blocks_blocks: return ".addToDownloadQueue(blocks:)"
            case .m_getDownloadTasks: return ".getDownloadTasks()"
            case .m_getDownloadTasksForCourse__courseId: return ".getDownloadTasksForCourse(_:)"
            case .m_cancelDownloading__courseId_courseIdblocks_blocks: return ".cancelDownloading(courseId:blocks:)"
            case .m_cancelDownloading__task_task: return ".cancelDownloading(task:)"
            case .m_cancelDownloading__courseId_courseId: return ".cancelDownloading(courseId:)"
            case .m_cancelAllDownloading: return ".cancelAllDownloading()"
            case .m_deleteFile__blocks_blocks: return ".deleteFile(blocks:)"
            case .m_deleteAllFiles: return ".deleteAllFiles()"
            case .m_fileUrl__for_blockId: return ".fileUrl(for:)"
            case .m_updateUnzippedFileSize__for_sequentials: return ".updateUnzippedFileSize(for:)"
            case .m_resumeDownloading: return ".resumeDownloading()"
            case .m_isLargeVideosSize__blocks_blocks: return ".isLargeVideosSize(blocks:)"
            case .m_removeAppSupportDirectoryUnusedContent: return ".removeAppSupportDirectoryUnusedContent()"
            case .p_currentDownloadTask_get: return "[get] .currentDownloadTask"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func currentDownloadTask(getter defaultValue: DownloadDataTask?...) -> PropertyStub {
            return Given(method: .p_currentDownloadTask_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

        public static func publisher(willReturn: AnyPublisher<Int, Never>...) -> MethodStub {
            return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func eventPublisher(willReturn: AnyPublisher<DownloadManagerEvent, Never>...) -> MethodStub {
            return Given(method: .m_eventPublisher, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadTasks(willReturn: [DownloadDataTask]...) -> MethodStub {
            return Given(method: .m_getDownloadTasks, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadTasksForCourse(_ courseId: Parameter<String>, willReturn: [DownloadDataTask]...) -> MethodStub {
            return Given(method: .m_getDownloadTasksForCourse__courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fileUrl(for blockId: Parameter<String>, willReturn: URL?...) -> MethodStub {
            return Given(method: .m_fileUrl__for_blockId(`blockId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func updateUnzippedFileSize(for sequentials: Parameter<[CourseSequential]>, willReturn: [CourseSequential]...) -> MethodStub {
            return Given(method: .m_updateUnzippedFileSize__for_sequentials(`sequentials`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isLargeVideosSize__blocks_blocks(`blocks`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func publisher(willProduce: (Stubber<AnyPublisher<Int, Never>>) -> Void) -> MethodStub {
            let willReturn: [AnyPublisher<Int, Never>] = []
			let given: Given = { return Given(method: .m_publisher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AnyPublisher<Int, Never>).self)
			willProduce(stubber)
			return given
        }
        public static func eventPublisher(willProduce: (Stubber<AnyPublisher<DownloadManagerEvent, Never>>) -> Void) -> MethodStub {
            let willReturn: [AnyPublisher<DownloadManagerEvent, Never>] = []
			let given: Given = { return Given(method: .m_eventPublisher, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (AnyPublisher<DownloadManagerEvent, Never>).self)
			willProduce(stubber)
			return given
        }
        public static func getDownloadTasks(willProduce: (Stubber<[DownloadDataTask]>) -> Void) -> MethodStub {
            let willReturn: [[DownloadDataTask]] = []
			let given: Given = { return Given(method: .m_getDownloadTasks, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DownloadDataTask]).self)
			willProduce(stubber)
			return given
        }
        public static func getDownloadTasksForCourse(_ courseId: Parameter<String>, willProduce: (Stubber<[DownloadDataTask]>) -> Void) -> MethodStub {
            let willReturn: [[DownloadDataTask]] = []
			let given: Given = { return Given(method: .m_getDownloadTasksForCourse__courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DownloadDataTask]).self)
			willProduce(stubber)
			return given
        }
        public static func fileUrl(for blockId: Parameter<String>, willProduce: (Stubber<URL?>) -> Void) -> MethodStub {
            let willReturn: [URL?] = []
			let given: Given = { return Given(method: .m_fileUrl__for_blockId(`blockId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (URL?).self)
			willProduce(stubber)
			return given
        }
        public static func updateUnzippedFileSize(for sequentials: Parameter<[CourseSequential]>, willProduce: (Stubber<[CourseSequential]>) -> Void) -> MethodStub {
            let willReturn: [[CourseSequential]] = []
			let given: Given = { return Given(method: .m_updateUnzippedFileSize__for_sequentials(`sequentials`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([CourseSequential]).self)
			willProduce(stubber)
			return given
        }
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isLargeVideosSize__blocks_blocks(`blocks`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_addToDownloadQueue__blocks_blocks(`blocks`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_addToDownloadQueue__blocks_blocks(`blocks`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func cancelDownloading(courseId: Parameter<String>, blocks: Parameter<[CourseBlock]>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_cancelDownloading__courseId_courseIdblocks_blocks(`courseId`, `blocks`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func cancelDownloading(courseId: Parameter<String>, blocks: Parameter<[CourseBlock]>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_cancelDownloading__courseId_courseIdblocks_blocks(`courseId`, `blocks`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_cancelDownloading__task_task(`task`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_cancelDownloading__task_task(`task`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func cancelDownloading(courseId: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_cancelDownloading__courseId_courseId(`courseId`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func cancelDownloading(courseId: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_cancelDownloading__courseId_courseId(`courseId`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func cancelAllDownloading(willThrow: Error...) -> MethodStub {
            return Given(method: .m_cancelAllDownloading, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func cancelAllDownloading(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_cancelAllDownloading, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
        public static func resumeDownloading(willThrow: Error...) -> MethodStub {
            return Given(method: .m_resumeDownloading, products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func resumeDownloading(willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_resumeDownloading, products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func publisher() -> Verify { return Verify(method: .m_publisher)}
        public static func eventPublisher() -> Verify { return Verify(method: .m_eventPublisher)}
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_addToDownloadQueue__blocks_blocks(`blocks`))}
        public static func getDownloadTasks() -> Verify { return Verify(method: .m_getDownloadTasks)}
        public static func getDownloadTasksForCourse(_ courseId: Parameter<String>) -> Verify { return Verify(method: .m_getDownloadTasksForCourse__courseId(`courseId`))}
        public static func cancelDownloading(courseId: Parameter<String>, blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_cancelDownloading__courseId_courseIdblocks_blocks(`courseId`, `blocks`))}
        public static func cancelDownloading(task: Parameter<DownloadDataTask>) -> Verify { return Verify(method: .m_cancelDownloading__task_task(`task`))}
        public static func cancelDownloading(courseId: Parameter<String>) -> Verify { return Verify(method: .m_cancelDownloading__courseId_courseId(`courseId`))}
        public static func cancelAllDownloading() -> Verify { return Verify(method: .m_cancelAllDownloading)}
        public static func deleteFile(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_deleteFile__blocks_blocks(`blocks`))}
        public static func deleteAllFiles() -> Verify { return Verify(method: .m_deleteAllFiles)}
        public static func fileUrl(for blockId: Parameter<String>) -> Verify { return Verify(method: .m_fileUrl__for_blockId(`blockId`))}
        public static func updateUnzippedFileSize(for sequentials: Parameter<[CourseSequential]>) -> Verify { return Verify(method: .m_updateUnzippedFileSize__for_sequentials(`sequentials`))}
        public static func resumeDownloading() -> Verify { return Verify(method: .m_resumeDownloading)}
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_isLargeVideosSize__blocks_blocks(`blocks`))}
        public static func removeAppSupportDirectoryUnusedContent() -> Verify { return Verify(method: .m_removeAppSupportDirectoryUnusedContent)}
        public static var currentDownloadTask: Verify { return Verify(method: .p_currentDownloadTask_get) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func publisher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_publisher, performs: perform)
        }
        public static func eventPublisher(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_eventPublisher, performs: perform)
        }
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, perform: @escaping ([CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_addToDownloadQueue__blocks_blocks(`blocks`), performs: perform)
        }
        public static func getDownloadTasks(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getDownloadTasks, performs: perform)
        }
        public static func getDownloadTasksForCourse(_ courseId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getDownloadTasksForCourse__courseId(`courseId`), performs: perform)
        }
        public static func cancelDownloading(courseId: Parameter<String>, blocks: Parameter<[CourseBlock]>, perform: @escaping (String, [CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_cancelDownloading__courseId_courseIdblocks_blocks(`courseId`, `blocks`), performs: perform)
        }
        public static func cancelDownloading(task: Parameter<DownloadDataTask>, perform: @escaping (DownloadDataTask) -> Void) -> Perform {
            return Perform(method: .m_cancelDownloading__task_task(`task`), performs: perform)
        }
        public static func cancelDownloading(courseId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_cancelDownloading__courseId_courseId(`courseId`), performs: perform)
        }
        public static func cancelAllDownloading(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_cancelAllDownloading, performs: perform)
        }
        public static func deleteFile(blocks: Parameter<[CourseBlock]>, perform: @escaping ([CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_deleteFile__blocks_blocks(`blocks`), performs: perform)
        }
        public static func deleteAllFiles(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteAllFiles, performs: perform)
        }
        public static func fileUrl(for blockId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_fileUrl__for_blockId(`blockId`), performs: perform)
        }
        public static func updateUnzippedFileSize(for sequentials: Parameter<[CourseSequential]>, perform: @escaping ([CourseSequential]) -> Void) -> Perform {
            return Perform(method: .m_updateUnzippedFileSize__for_sequentials(`sequentials`), performs: perform)
        }
        public static func resumeDownloading(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resumeDownloading, performs: perform)
        }
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>, perform: @escaping ([CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_isLargeVideosSize__blocks_blocks(`blocks`), performs: perform)
        }
        public static func removeAppSupportDirectoryUnusedContent(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_removeAppSupportDirectoryUnusedContent, performs: perform)
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

// MARK: - OfflineSyncInteractorProtocol

open class OfflineSyncInteractorProtocolMock: OfflineSyncInteractorProtocol, Mock {
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





    open func submitOfflineProgress(courseID: String, blockID: String, data: String) throws -> Bool {
        addInvocation(.m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`data`)))
		let perform = methodPerformValue(.m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`data`))) as? (String, String, String) -> Void
		perform?(`courseID`, `blockID`, `data`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(Parameter<String>.value(`courseID`), Parameter<String>.value(`blockID`), Parameter<String>.value(`data`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for submitOfflineProgress(courseID: String, blockID: String, data: String). Use given")
			Failure("Stub return value not specified for submitOfflineProgress(courseID: String, blockID: String, data: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(Parameter<String>, Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(let lhsCourseid, let lhsBlockid, let lhsData), .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(let rhsCourseid, let rhsBlockid, let rhsData)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsData, rhs: rhsData, with: matcher), lhsData, rhsData, "data"))
				return Matcher.ComparisonResult(results)
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data: return ".submitOfflineProgress(courseID:blockID:data:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func submitOfflineProgress(courseID: Parameter<String>, blockID: Parameter<String>, data: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(`courseID`, `blockID`, `data`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func submitOfflineProgress(courseID: Parameter<String>, blockID: Parameter<String>, data: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(`courseID`, `blockID`, `data`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func submitOfflineProgress(courseID: Parameter<String>, blockID: Parameter<String>, data: Parameter<String>, willProduce: (StubberThrows<Bool>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(`courseID`, `blockID`, `data`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func submitOfflineProgress(courseID: Parameter<String>, blockID: Parameter<String>, data: Parameter<String>) -> Verify { return Verify(method: .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(`courseID`, `blockID`, `data`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func submitOfflineProgress(courseID: Parameter<String>, blockID: Parameter<String>, data: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_submitOfflineProgress__courseID_courseIDblockID_blockIDdata_data(`courseID`, `blockID`, `data`), performs: perform)
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

// MARK: - WebviewCookiesUpdateProtocol

open class WebviewCookiesUpdateProtocolMock: WebviewCookiesUpdateProtocol, Mock {
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

    public var authInteractor: AuthInteractorProtocol {
		get {	invocations.append(.p_authInteractor_get); return __p_authInteractor ?? givenGetterValue(.p_authInteractor_get, "WebviewCookiesUpdateProtocolMock - stub value for authInteractor was not defined") }
	}
	private var __p_authInteractor: (AuthInteractorProtocol)?

    public var cookiesReady: Bool {
		get {	invocations.append(.p_cookiesReady_get); return __p_cookiesReady ?? givenGetterValue(.p_cookiesReady_get, "WebviewCookiesUpdateProtocolMock - stub value for cookiesReady was not defined") }
		set {	invocations.append(.p_cookiesReady_set(.value(newValue))); __p_cookiesReady = newValue }
	}
	private var __p_cookiesReady: (Bool)?

    public var updatingCookies: Bool {
		get {	invocations.append(.p_updatingCookies_get); return __p_updatingCookies ?? givenGetterValue(.p_updatingCookies_get, "WebviewCookiesUpdateProtocolMock - stub value for updatingCookies was not defined") }
		set {	invocations.append(.p_updatingCookies_set(.value(newValue))); __p_updatingCookies = newValue }
	}
	private var __p_updatingCookies: (Bool)?

    public var errorMessage: String? {
		get {	invocations.append(.p_errorMessage_get); return __p_errorMessage ?? optionalGivenGetterValue(.p_errorMessage_get, "WebviewCookiesUpdateProtocolMock - stub value for errorMessage was not defined") }
		set {	invocations.append(.p_errorMessage_set(.value(newValue))); __p_errorMessage = newValue }
	}
	private var __p_errorMessage: (String)?





    open func updateCookies(force: Bool, retryCount: Int) {
        addInvocation(.m_updateCookies__force_forceretryCount_retryCount(Parameter<Bool>.value(`force`), Parameter<Int>.value(`retryCount`)))
		let perform = methodPerformValue(.m_updateCookies__force_forceretryCount_retryCount(Parameter<Bool>.value(`force`), Parameter<Int>.value(`retryCount`))) as? (Bool, Int) -> Void
		perform?(`force`, `retryCount`)
    }


    fileprivate enum MethodType {
        case m_updateCookies__force_forceretryCount_retryCount(Parameter<Bool>, Parameter<Int>)
        case p_authInteractor_get
        case p_cookiesReady_get
		case p_cookiesReady_set(Parameter<Bool>)
        case p_updatingCookies_get
		case p_updatingCookies_set(Parameter<Bool>)
        case p_errorMessage_get
		case p_errorMessage_set(Parameter<String?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_updateCookies__force_forceretryCount_retryCount(let lhsForce, let lhsRetrycount), .m_updateCookies__force_forceretryCount_retryCount(let rhsForce, let rhsRetrycount)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsForce, rhs: rhsForce, with: matcher), lhsForce, rhsForce, "force"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRetrycount, rhs: rhsRetrycount, with: matcher), lhsRetrycount, rhsRetrycount, "retryCount"))
				return Matcher.ComparisonResult(results)
            case (.p_authInteractor_get,.p_authInteractor_get): return Matcher.ComparisonResult.match
            case (.p_cookiesReady_get,.p_cookiesReady_get): return Matcher.ComparisonResult.match
			case (.p_cookiesReady_set(let left),.p_cookiesReady_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_updatingCookies_get,.p_updatingCookies_get): return Matcher.ComparisonResult.match
			case (.p_updatingCookies_set(let left),.p_updatingCookies_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<Bool>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            case (.p_errorMessage_get,.p_errorMessage_get): return Matcher.ComparisonResult.match
			case (.p_errorMessage_set(let left),.p_errorMessage_set(let right)): return Matcher.ComparisonResult([Matcher.ParameterComparisonResult(Parameter<String?>.compare(lhs: left, rhs: right, with: matcher), left, right, "newValue")])
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_updateCookies__force_forceretryCount_retryCount(p0, p1): return p0.intValue + p1.intValue
            case .p_authInteractor_get: return 0
            case .p_cookiesReady_get: return 0
			case .p_cookiesReady_set(let newValue): return newValue.intValue
            case .p_updatingCookies_get: return 0
			case .p_updatingCookies_set(let newValue): return newValue.intValue
            case .p_errorMessage_get: return 0
			case .p_errorMessage_set(let newValue): return newValue.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_updateCookies__force_forceretryCount_retryCount: return ".updateCookies(force:retryCount:)"
            case .p_authInteractor_get: return "[get] .authInteractor"
            case .p_cookiesReady_get: return "[get] .cookiesReady"
			case .p_cookiesReady_set: return "[set] .cookiesReady"
            case .p_updatingCookies_get: return "[get] .updatingCookies"
			case .p_updatingCookies_set: return "[set] .updatingCookies"
            case .p_errorMessage_get: return "[get] .errorMessage"
			case .p_errorMessage_set: return "[set] .errorMessage"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }

        public static func authInteractor(getter defaultValue: AuthInteractorProtocol...) -> PropertyStub {
            return Given(method: .p_authInteractor_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func cookiesReady(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_cookiesReady_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func updatingCookies(getter defaultValue: Bool...) -> PropertyStub {
            return Given(method: .p_updatingCookies_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }
        public static func errorMessage(getter defaultValue: String?...) -> PropertyStub {
            return Given(method: .p_errorMessage_get, products: defaultValue.map({ StubProduct.return($0 as Any) }))
        }

    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func updateCookies(force: Parameter<Bool>, retryCount: Parameter<Int>) -> Verify { return Verify(method: .m_updateCookies__force_forceretryCount_retryCount(`force`, `retryCount`))}
        public static var authInteractor: Verify { return Verify(method: .p_authInteractor_get) }
        public static var cookiesReady: Verify { return Verify(method: .p_cookiesReady_get) }
		public static func cookiesReady(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_cookiesReady_set(newValue)) }
        public static var updatingCookies: Verify { return Verify(method: .p_updatingCookies_get) }
		public static func updatingCookies(set newValue: Parameter<Bool>) -> Verify { return Verify(method: .p_updatingCookies_set(newValue)) }
        public static var errorMessage: Verify { return Verify(method: .p_errorMessage_get) }
		public static func errorMessage(set newValue: Parameter<String?>) -> Verify { return Verify(method: .p_errorMessage_set(newValue)) }
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func updateCookies(force: Parameter<Bool>, retryCount: Parameter<Int>, perform: @escaping (Bool, Int) -> Void) -> Perform {
            return Perform(method: .m_updateCookies__force_forceretryCount_retryCount(`force`, `retryCount`), performs: perform)
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

