// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
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

    open func showUpgradeInfo(productName: String, sku: String, courseID: String, screen: CourseUpgradeScreen) {
        addInvocation(.m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(Parameter<String>.value(`productName`), Parameter<String>.value(`sku`), Parameter<String>.value(`courseID`), Parameter<CourseUpgradeScreen>.value(`screen`)))
		let perform = methodPerformValue(.m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(Parameter<String>.value(`productName`), Parameter<String>.value(`sku`), Parameter<String>.value(`courseID`), Parameter<CourseUpgradeScreen>.value(`screen`))) as? (String, String, String, CourseUpgradeScreen) -> Void
		perform?(`productName`, `sku`, `courseID`, `screen`)
    }

    open func hideUpgradeInfo(animated: Bool, completion: (() -> Void)?) {
        addInvocation(.m_hideUpgradeInfo__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_hideUpgradeInfo__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (Bool, (() -> Void)?) -> Void
		perform?(`animated`, `completion`)
    }

    open func showUpgradeLoaderView(animated: Bool, completion: (() -> Void)?) {
        addInvocation(.m_showUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_showUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (Bool, (() -> Void)?) -> Void
		perform?(`animated`, `completion`)
    }

    open func hideUpgradeLoaderView(animated: Bool, completion: (() -> Void)?) {
        addInvocation(.m_hideUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_hideUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (Bool, (() -> Void)?) -> Void
		perform?(`animated`, `completion`)
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
        case m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<CourseUpgradeScreen>)
        case m_hideUpgradeInfo__animated_animatedcompletion_completion(Parameter<Bool>, Parameter<(() -> Void)?>)
        case m_showUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>, Parameter<(() -> Void)?>)
        case m_hideUpgradeLoaderView__animated_animatedcompletion_completion(Parameter<Bool>, Parameter<(() -> Void)?>)

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

            case (.m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(let lhsProductname, let lhsSku, let lhsCourseid, let lhsScreen), .m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(let rhsProductname, let rhsSku, let rhsCourseid, let rhsScreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsProductname, rhs: rhsProductname, with: matcher), lhsProductname, rhsProductname, "productName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				return Matcher.ComparisonResult(results)

            case (.m_hideUpgradeInfo__animated_animatedcompletion_completion(let lhsAnimated, let lhsCompletion), .m_hideUpgradeInfo__animated_animatedcompletion_completion(let rhsAnimated, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_showUpgradeLoaderView__animated_animatedcompletion_completion(let lhsAnimated, let lhsCompletion), .m_showUpgradeLoaderView__animated_animatedcompletion_completion(let rhsAnimated, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_hideUpgradeLoaderView__animated_animatedcompletion_completion(let lhsAnimated, let lhsCompletion), .m_hideUpgradeLoaderView__animated_animatedcompletion_completion(let rhsAnimated, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
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
            case let .m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_hideUpgradeInfo__animated_animatedcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_showUpgradeLoaderView__animated_animatedcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_hideUpgradeLoaderView__animated_animatedcompletion_completion(p0, p1): return p0.intValue + p1.intValue
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
            case .m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen: return ".showUpgradeInfo(productName:sku:courseID:screen:)"
            case .m_hideUpgradeInfo__animated_animatedcompletion_completion: return ".hideUpgradeInfo(animated:completion:)"
            case .m_showUpgradeLoaderView__animated_animatedcompletion_completion: return ".showUpgradeLoaderView(animated:completion:)"
            case .m_hideUpgradeLoaderView__animated_animatedcompletion_completion: return ".hideUpgradeLoaderView(animated:completion:)"
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
        public static func showUpgradeInfo(productName: Parameter<String>, sku: Parameter<String>, courseID: Parameter<String>, screen: Parameter<CourseUpgradeScreen>) -> Verify { return Verify(method: .m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(`productName`, `sku`, `courseID`, `screen`))}
        public static func hideUpgradeInfo(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_hideUpgradeInfo__animated_animatedcompletion_completion(`animated`, `completion`))}
        public static func showUpgradeLoaderView(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_showUpgradeLoaderView__animated_animatedcompletion_completion(`animated`, `completion`))}
        public static func hideUpgradeLoaderView(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_hideUpgradeLoaderView__animated_animatedcompletion_completion(`animated`, `completion`))}
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
        public static func showUpgradeInfo(productName: Parameter<String>, sku: Parameter<String>, courseID: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, perform: @escaping (String, String, String, CourseUpgradeScreen) -> Void) -> Perform {
            return Perform(method: .m_showUpgradeInfo__productName_productNamesku_skucourseID_courseIDscreen_screen(`productName`, `sku`, `courseID`, `screen`), performs: perform)
        }
        public static func hideUpgradeInfo(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_hideUpgradeInfo__animated_animatedcompletion_completion(`animated`, `completion`), performs: perform)
        }
        public static func showUpgradeLoaderView(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_showUpgradeLoaderView__animated_animatedcompletion_completion(`animated`, `completion`), performs: perform)
        }
        public static func hideUpgradeLoaderView(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_hideUpgradeLoaderView__animated_animatedcompletion_completion(`animated`, `completion`), performs: perform)
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

    open func trackCourseUpgradePaymentError(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String, blockID: String?, pacing: String, coursePrice: String, screen: CourseUpgradeScreen, error: String) {
        addInvocation(.m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`error`)))
		let perform = methodPerformValue(.m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`error`))) as? (AnalyticsEvent, EventBIValue, String, String?, String, String, CourseUpgradeScreen, String) -> Void
		perform?(`event`, `biValue`, `courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`)
    }

    open func trackCourseUpgradeError(courseID: String, blockID: String?, pacing: String, coursePrice: String?, screen: CourseUpgradeScreen, error: String, flowType: String) {
        addInvocation(.m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`error`), Parameter<String>.value(`flowType`)))
		let perform = methodPerformValue(.m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`error`), Parameter<String>.value(`flowType`))) as? (String, String?, String, String?, CourseUpgradeScreen, String, String) -> Void
		perform?(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`, `flowType`)
    }

    open func trackCourseUpgradeErrorAction(courseID: String, blockID: String?, pacing: String, coursePrice: String?, screen: CourseUpgradeScreen, errorAction: String, error: String, flowType: String) {
        addInvocation(.m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`errorAction`), Parameter<String>.value(`error`), Parameter<String>.value(`flowType`)))
		let perform = methodPerformValue(.m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`errorAction`), Parameter<String>.value(`error`), Parameter<String>.value(`flowType`))) as? (String, String?, String, String?, CourseUpgradeScreen, String, String, String) -> Void
		perform?(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `errorAction`, `error`, `flowType`)
    }

    open func trackCourseUpgradeSuccess(courseID: String, blockID: String?, pacing: String, coursePrice: String, screen: CourseUpgradeScreen, flowType: String) {
        addInvocation(.m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`flowType`)))
		let perform = methodPerformValue(.m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<String>.value(`coursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`flowType`))) as? (String, String?, String, String, CourseUpgradeScreen, String) -> Void
		perform?(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `flowType`)
    }

    open func trackUpgradeNow(courseID: String, blockID: String?, pacing: String, screen: CourseUpgradeScreen, coursePrice: String) {
        addInvocation(.m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`coursePrice`)))
		let perform = methodPerformValue(.m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`coursePrice`))) as? (String, String?, String, CourseUpgradeScreen, String) -> Void
		perform?(`courseID`, `blockID`, `pacing`, `screen`, `coursePrice`)
    }

    open func trackCourseUpgradeLoadError(courseID: String, blockID: String?, pacing: String, screen: CourseUpgradeScreen) {
        addInvocation(.m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`)))
		let perform = methodPerformValue(.m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(Parameter<String>.value(`courseID`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`))) as? (String, String?, String, CourseUpgradeScreen) -> Void
		perform?(`courseID`, `blockID`, `pacing`, `screen`)
    }

    open func trackCourseUnfulfilledPurchaseInitiated(courseID: String, pacing: String, screen: CourseUpgradeScreen, flowType: String) {
        addInvocation(.m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`flowType`)))
		let perform = methodPerformValue(.m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(Parameter<String>.value(`courseID`), Parameter<String>.value(`pacing`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<String>.value(`flowType`))) as? (String, String, CourseUpgradeScreen, String) -> Void
		perform?(`courseID`, `pacing`, `screen`, `flowType`)
    }

    open func trackRestorePurchaseClicked() {
        addInvocation(.m_trackRestorePurchaseClicked)
		let perform = methodPerformValue(.m_trackRestorePurchaseClicked) as? () -> Void
		perform?()
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


    fileprivate enum MethodType {
        case m_trackEvent__eventparameters_parameters(Parameter<AnalyticsEvent>, Parameter<[String: Any]?>)
        case m_trackEvent__eventbiValue_biValueparameters_parameters(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<[String: Any]?>)
        case m_appreview__eventbiValue_biValueaction_actionrating_rating(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String?>, Parameter<Int?>)
        case m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>)
        case m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<String>, Parameter<CourseUpgradeScreen>, Parameter<String>)
        case m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<String?>, Parameter<CourseUpgradeScreen>, Parameter<String>, Parameter<String>)
        case m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<String?>, Parameter<CourseUpgradeScreen>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<String>, Parameter<CourseUpgradeScreen>, Parameter<String>)
        case m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<CourseUpgradeScreen>, Parameter<String>)
        case m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<CourseUpgradeScreen>)
        case m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(Parameter<String>, Parameter<String>, Parameter<CourseUpgradeScreen>, Parameter<String>)
        case m_trackRestorePurchaseClicked
        case m_trackEvent__event(Parameter<AnalyticsEvent>)
        case m_trackEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)

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

            case (.m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(let lhsEvent, let lhsBivalue, let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsCourseprice, let lhsScreen, let lhsError), .m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(let rhsEvent, let rhsBivalue, let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsCourseprice, let rhsScreen, let rhsError)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseprice, rhs: rhsCourseprice, with: matcher), lhsCourseprice, rhsCourseprice, "coursePrice"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsError, rhs: rhsError, with: matcher), lhsError, rhsError, "error"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsCourseprice, let lhsScreen, let lhsError, let lhsFlowtype), .m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsCourseprice, let rhsScreen, let rhsError, let rhsFlowtype)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseprice, rhs: rhsCourseprice, with: matcher), lhsCourseprice, rhsCourseprice, "coursePrice"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsError, rhs: rhsError, with: matcher), lhsError, rhsError, "error"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFlowtype, rhs: rhsFlowtype, with: matcher), lhsFlowtype, rhsFlowtype, "flowType"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsCourseprice, let lhsScreen, let lhsErroraction, let lhsError, let lhsFlowtype), .m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsCourseprice, let rhsScreen, let rhsErroraction, let rhsError, let rhsFlowtype)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseprice, rhs: rhsCourseprice, with: matcher), lhsCourseprice, rhsCourseprice, "coursePrice"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsErroraction, rhs: rhsErroraction, with: matcher), lhsErroraction, rhsErroraction, "errorAction"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsError, rhs: rhsError, with: matcher), lhsError, rhsError, "error"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFlowtype, rhs: rhsFlowtype, with: matcher), lhsFlowtype, rhsFlowtype, "flowType"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsCourseprice, let lhsScreen, let lhsFlowtype), .m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsCourseprice, let rhsScreen, let rhsFlowtype)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseprice, rhs: rhsCourseprice, with: matcher), lhsCourseprice, rhsCourseprice, "coursePrice"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFlowtype, rhs: rhsFlowtype, with: matcher), lhsFlowtype, rhsFlowtype, "flowType"))
				return Matcher.ComparisonResult(results)

            case (.m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsScreen, let lhsCourseprice), .m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsScreen, let rhsCourseprice)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseprice, rhs: rhsCourseprice, with: matcher), lhsCourseprice, rhsCourseprice, "coursePrice"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(let lhsCourseid, let lhsBlockid, let lhsPacing, let lhsScreen), .m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(let rhsCourseid, let rhsBlockid, let rhsPacing, let rhsScreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(let lhsCourseid, let lhsPacing, let lhsScreen, let lhsFlowtype), .m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(let rhsCourseid, let rhsPacing, let rhsScreen, let rhsFlowtype)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFlowtype, rhs: rhsFlowtype, with: matcher), lhsFlowtype, rhsFlowtype, "flowType"))
				return Matcher.ComparisonResult(results)

            case (.m_trackRestorePurchaseClicked, .m_trackRestorePurchaseClicked): return .match

            case (.m_trackEvent__event(let lhsEvent), .m_trackEvent__event(let rhsEvent)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				return Matcher.ComparisonResult(results)

            case (.m_trackEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_trackEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
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
            case let .m_appreview__eventbiValue_biValueaction_actionrating_rating(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(p0, p1, p2, p3, p4, p5, p6): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue
            case let .m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case .m_trackRestorePurchaseClicked: return 0
            case let .m_trackEvent__event(p0): return p0.intValue
            case let .m_trackEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_trackEvent__eventparameters_parameters: return ".trackEvent(_:parameters:)"
            case .m_trackEvent__eventbiValue_biValueparameters_parameters: return ".trackEvent(_:biValue:parameters:)"
            case .m_appreview__eventbiValue_biValueaction_actionrating_rating: return ".appreview(_:biValue:action:rating:)"
            case .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue: return ".videoQualityChanged(_:bivalue:value:oldValue:)"
            case .m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error: return ".trackCourseUpgradePaymentError(_:biValue:courseID:blockID:pacing:coursePrice:screen:error:)"
            case .m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType: return ".trackCourseUpgradeError(courseID:blockID:pacing:coursePrice:screen:error:flowType:)"
            case .m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType: return ".trackCourseUpgradeErrorAction(courseID:blockID:pacing:coursePrice:screen:errorAction:error:flowType:)"
            case .m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType: return ".trackCourseUpgradeSuccess(courseID:blockID:pacing:coursePrice:screen:flowType:)"
            case .m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice: return ".trackUpgradeNow(courseID:blockID:pacing:screen:coursePrice:)"
            case .m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen: return ".trackCourseUpgradeLoadError(courseID:blockID:pacing:screen:)"
            case .m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType: return ".trackCourseUnfulfilledPurchaseInitiated(courseID:pacing:screen:flowType:)"
            case .m_trackRestorePurchaseClicked: return ".trackRestorePurchaseClicked()"
            case .m_trackEvent__event: return ".trackEvent(_:)"
            case .m_trackEvent__eventbiValue_biValue: return ".trackEvent(_:biValue:)"
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
        public static func appreview(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, action: Parameter<String?>, rating: Parameter<Int?>) -> Verify { return Verify(method: .m_appreview__eventbiValue_biValueaction_actionrating_rating(`event`, `biValue`, `action`, `rating`))}
        public static func videoQualityChanged(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, value: Parameter<String>, oldValue: Parameter<String>) -> Verify { return Verify(method: .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(`event`, `bivalue`, `value`, `oldValue`))}
        public static func trackCourseUpgradePaymentError(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, error: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(`event`, `biValue`, `courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`))}
        public static func trackCourseUpgradeError(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, error: Parameter<String>, flowType: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`, `flowType`))}
        public static func trackCourseUpgradeErrorAction(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, errorAction: Parameter<String>, error: Parameter<String>, flowType: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `errorAction`, `error`, `flowType`))}
        public static func trackCourseUpgradeSuccess(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, flowType: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `flowType`))}
        public static func trackUpgradeNow(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, coursePrice: Parameter<String>) -> Verify { return Verify(method: .m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(`courseID`, `blockID`, `pacing`, `screen`, `coursePrice`))}
        public static func trackCourseUpgradeLoadError(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>) -> Verify { return Verify(method: .m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(`courseID`, `blockID`, `pacing`, `screen`))}
        public static func trackCourseUnfulfilledPurchaseInitiated(courseID: Parameter<String>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, flowType: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(`courseID`, `pacing`, `screen`, `flowType`))}
        public static func trackRestorePurchaseClicked() -> Verify { return Verify(method: .m_trackRestorePurchaseClicked)}
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>) -> Verify { return Verify(method: .m_trackEvent__event(`event`))}
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_trackEvent__eventbiValue_biValue(`event`, `biValue`))}
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
        public static func appreview(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, action: Parameter<String?>, rating: Parameter<Int?>, perform: @escaping (AnalyticsEvent, EventBIValue, String?, Int?) -> Void) -> Perform {
            return Perform(method: .m_appreview__eventbiValue_biValueaction_actionrating_rating(`event`, `biValue`, `action`, `rating`), performs: perform)
        }
        public static func videoQualityChanged(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, value: Parameter<String>, oldValue: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String) -> Void) -> Perform {
            return Perform(method: .m_videoQualityChanged__eventbivalue_bivaluevalue_valueoldValue_oldValue(`event`, `bivalue`, `value`, `oldValue`), performs: perform)
        }
        public static func trackCourseUpgradePaymentError(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, error: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String?, String, String, CourseUpgradeScreen, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUpgradePaymentError__eventbiValue_biValuecourseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_error(`event`, `biValue`, `courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`), performs: perform)
        }
        public static func trackCourseUpgradeError(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, error: Parameter<String>, flowType: Parameter<String>, perform: @escaping (String, String?, String, String?, CourseUpgradeScreen, String, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUpgradeError__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerror_errorflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `error`, `flowType`), performs: perform)
        }
        public static func trackCourseUpgradeErrorAction(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, errorAction: Parameter<String>, error: Parameter<String>, flowType: Parameter<String>, perform: @escaping (String, String?, String, String?, CourseUpgradeScreen, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUpgradeErrorAction__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenerrorAction_errorActionerror_errorflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `errorAction`, `error`, `flowType`), performs: perform)
        }
        public static func trackCourseUpgradeSuccess(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, coursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, flowType: Parameter<String>, perform: @escaping (String, String?, String, String, CourseUpgradeScreen, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUpgradeSuccess__courseID_courseIDblockID_blockIDpacing_pacingcoursePrice_coursePricescreen_screenflowType_flowType(`courseID`, `blockID`, `pacing`, `coursePrice`, `screen`, `flowType`), performs: perform)
        }
        public static func trackUpgradeNow(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, coursePrice: Parameter<String>, perform: @escaping (String, String?, String, CourseUpgradeScreen, String) -> Void) -> Perform {
            return Perform(method: .m_trackUpgradeNow__courseID_courseIDblockID_blockIDpacing_pacingscreen_screencoursePrice_coursePrice(`courseID`, `blockID`, `pacing`, `screen`, `coursePrice`), performs: perform)
        }
        public static func trackCourseUpgradeLoadError(courseID: Parameter<String>, blockID: Parameter<String?>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, perform: @escaping (String, String?, String, CourseUpgradeScreen) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUpgradeLoadError__courseID_courseIDblockID_blockIDpacing_pacingscreen_screen(`courseID`, `blockID`, `pacing`, `screen`), performs: perform)
        }
        public static func trackCourseUnfulfilledPurchaseInitiated(courseID: Parameter<String>, pacing: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, flowType: Parameter<String>, perform: @escaping (String, String, CourseUpgradeScreen, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseUnfulfilledPurchaseInitiated__courseID_courseIDpacing_pacingscreen_screenflowType_flowType(`courseID`, `pacing`, `screen`, `flowType`), performs: perform)
        }
        public static func trackRestorePurchaseClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_trackRestorePurchaseClicked, performs: perform)
        }
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, perform: @escaping (AnalyticsEvent) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__event(`event`), performs: perform)
        }
        public static func trackEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_trackEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
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

// MARK: - CourseAnalytics

open class CourseAnalyticsMock: CourseAnalytics, Mock {
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





    open func resumeCourseClicked(courseId: String, courseName: String, blockId: String) {
        addInvocation(.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`)))
		let perform = methodPerformValue(.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`))) as? (String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`)
    }

    open func sequentialClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func verticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func nextBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func prevBlockClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalNextSectionClicked(courseId: String, courseName: String, blockId: String, blockName: String) {
        addInvocation(.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`)))
		let perform = methodPerformValue(.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`), Parameter<String>.value(`blockId`), Parameter<String>.value(`blockName`))) as? (String, String, String, String) -> Void
		perform?(`courseId`, `courseName`, `blockId`, `blockName`)
    }

    open func finishVerticalBackToOutlineClicked(courseId: String, courseName: String) {
        addInvocation(.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineCourseTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineVideosTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineDatesTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineDiscussionTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func courseOutlineHandoutsTabClicked(courseId: String, courseName: String) {
        addInvocation(.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`)))
		let perform = methodPerformValue(.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>.value(`courseId`), Parameter<String>.value(`courseName`))) as? (String, String) -> Void
		perform?(`courseId`, `courseName`)
    }

    open func datesComponentTapped(courseId: String, blockId: String, link: String, supported: Bool) {
        addInvocation(.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>.value(`courseId`), Parameter<String>.value(`blockId`), Parameter<String>.value(`link`), Parameter<Bool>.value(`supported`)))
		let perform = methodPerformValue(.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>.value(`courseId`), Parameter<String>.value(`blockId`), Parameter<String>.value(`link`), Parameter<Bool>.value(`supported`))) as? (String, String, String, Bool) -> Void
		perform?(`courseId`, `blockId`, `link`, `supported`)
    }

    open func calendarSyncToggle(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, action: CalendarDialogueAction) {
        addInvocation(.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueAction>.value(`action`)))
		let perform = methodPerformValue(.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueAction>.value(`action`))) as? (EnrollmentMode, CoursePacing, String, CalendarDialogueAction) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `action`)
    }

    open func calendarSyncDialogAction(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, dialog: CalendarDialogueType, action: CalendarDialogueAction) {
        addInvocation(.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueType>.value(`dialog`), Parameter<CalendarDialogueAction>.value(`action`)))
		let perform = methodPerformValue(.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<CalendarDialogueType>.value(`dialog`), Parameter<CalendarDialogueAction>.value(`action`))) as? (EnrollmentMode, CoursePacing, String, CalendarDialogueType, CalendarDialogueAction) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`)
    }

    open func calendarSyncSnackbar(enrollmentMode: EnrollmentMode, pacing: CoursePacing, courseId: String, snackbar: SnackbarType) {
        addInvocation(.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<SnackbarType>.value(`snackbar`)))
		let perform = methodPerformValue(.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>.value(`enrollmentMode`), Parameter<CoursePacing>.value(`pacing`), Parameter<String>.value(`courseId`), Parameter<SnackbarType>.value(`snackbar`))) as? (EnrollmentMode, CoursePacing, String, SnackbarType) -> Void
		perform?(`enrollmentMode`, `pacing`, `courseId`, `snackbar`)
    }

    open func trackCourseEvent(_ event: AnalyticsEvent, biValue: EventBIValue, courseID: String) {
        addInvocation(.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`), Parameter<String>.value(`courseID`))) as? (AnalyticsEvent, EventBIValue, String) -> Void
		perform?(`event`, `biValue`, `courseID`)
    }

    open func plsEvent(_ event: AnalyticsEvent, bivalue: EventBIValue, courseID: String, screenName: String, type: String) {
        addInvocation(.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`)))
		let perform = methodPerformValue(.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`))) as? (AnalyticsEvent, EventBIValue, String, String, String) -> Void
		perform?(`event`, `bivalue`, `courseID`, `screenName`, `type`)
    }

    open func plsSuccessEvent(_ event: AnalyticsEvent, bivalue: EventBIValue, courseID: String, screenName: String, type: String, success: Bool) {
        addInvocation(.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`), Parameter<Bool>.value(`success`)))
		let perform = methodPerformValue(.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`bivalue`), Parameter<String>.value(`courseID`), Parameter<String>.value(`screenName`), Parameter<String>.value(`type`), Parameter<Bool>.value(`success`))) as? (AnalyticsEvent, EventBIValue, String, String, String, Bool) -> Void
		perform?(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`)
    }

    open func bulkDownloadVideosToggle(courseID: String, action: Bool) {
        addInvocation(.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`action`)))
		let perform = methodPerformValue(.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>.value(`courseID`), Parameter<Bool>.value(`action`))) as? (String, Bool) -> Void
		perform?(`courseID`, `action`)
    }

    open func bulkDownloadVideosSubsection(courseID: String, sectionID: String, subSectionID: String, videos: Int) {
        addInvocation(.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`sectionID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`))) as? (String, String, String, Int) -> Void
		perform?(`courseID`, `sectionID`, `subSectionID`, `videos`)
    }

    open func bulkDeleteVideosSubsection(courseID: String, subSectionID: String, videos: Int) {
        addInvocation(.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`)))
		let perform = methodPerformValue(.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>.value(`courseID`), Parameter<String>.value(`subSectionID`), Parameter<Int>.value(`videos`))) as? (String, String, Int) -> Void
		perform?(`courseID`, `subSectionID`, `videos`)
    }


    fileprivate enum MethodType {
        case m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(Parameter<String>, Parameter<String>)
        case m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<CalendarDialogueAction>)
        case m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<CalendarDialogueType>, Parameter<CalendarDialogueAction>)
        case m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(Parameter<EnrollmentMode>, Parameter<CoursePacing>, Parameter<String>, Parameter<SnackbarType>)
        case m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>)
        case m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>, Parameter<String>)
        case m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(Parameter<AnalyticsEvent>, Parameter<EventBIValue>, Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Bool>)
        case m_bulkDownloadVideosToggle__courseID_courseIDaction_action(Parameter<String>, Parameter<Bool>)
        case m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<Int>)
        case m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(Parameter<String>, Parameter<String>, Parameter<Int>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(let lhsCourseid, let lhsCoursename, let lhsBlockid), .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(let rhsCourseid, let rhsCoursename, let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				return Matcher.ComparisonResult(results)

            case (.m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let lhsCourseid, let lhsCoursename, let lhsBlockid, let lhsBlockname), .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(let rhsCourseid, let rhsCoursename, let rhsBlockid, let rhsBlockname)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockname, rhs: rhsBlockname, with: matcher), lhsBlockname, rhsBlockname, "blockName"))
				return Matcher.ComparisonResult(results)

            case (.m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(let lhsCourseid, let lhsCoursename), .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(let rhsCourseid, let rhsCoursename)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				return Matcher.ComparisonResult(results)

            case (.m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(let lhsCourseid, let lhsBlockid, let lhsLink, let lhsSupported), .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(let rhsCourseid, let rhsBlockid, let rhsLink, let rhsSupported)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLink, rhs: rhsLink, with: matcher), lhsLink, rhsLink, "link"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSupported, rhs: rhsSupported, with: matcher), lhsSupported, rhsSupported, "supported"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsAction), .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsDialog, let lhsAction), .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsDialog, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDialog, rhs: rhsDialog, with: matcher), lhsDialog, rhsDialog, "dialog"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(let lhsEnrollmentmode, let lhsPacing, let lhsCourseid, let lhsSnackbar), .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(let rhsEnrollmentmode, let rhsPacing, let rhsCourseid, let rhsSnackbar)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEnrollmentmode, rhs: rhsEnrollmentmode, with: matcher), lhsEnrollmentmode, rhsEnrollmentmode, "enrollmentMode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSnackbar, rhs: rhsSnackbar, with: matcher), lhsSnackbar, rhsSnackbar, "snackbar"))
				return Matcher.ComparisonResult(results)

            case (.m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(let lhsEvent, let lhsBivalue, let lhsCourseid), .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(let rhsEvent, let rhsBivalue, let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(let lhsEvent, let lhsBivalue, let lhsCourseid, let lhsScreenname, let lhsType), .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(let rhsEvent, let rhsBivalue, let rhsCourseid, let rhsScreenname, let rhsType)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "bivalue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreenname, rhs: rhsScreenname, with: matcher), lhsScreenname, rhsScreenname, "screenName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				return Matcher.ComparisonResult(results)

            case (.m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(let lhsEvent, let lhsBivalue, let lhsCourseid, let lhsScreenname, let lhsType, let lhsSuccess), .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(let rhsEvent, let rhsBivalue, let rhsCourseid, let rhsScreenname, let rhsType, let rhsSuccess)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "bivalue"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreenname, rhs: rhsScreenname, with: matcher), lhsScreenname, rhsScreenname, "screenName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsType, rhs: rhsType, with: matcher), lhsType, rhsType, "type"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSuccess, rhs: rhsSuccess, with: matcher), lhsSuccess, rhsSuccess, "success"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDownloadVideosToggle__courseID_courseIDaction_action(let lhsCourseid, let lhsAction), .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(let rhsCourseid, let rhsAction)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAction, rhs: rhsAction, with: matcher), lhsAction, rhsAction, "action"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(let lhsCourseid, let lhsSectionid, let lhsSubsectionid, let lhsVideos), .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(let rhsCourseid, let rhsSectionid, let rhsSubsectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSectionid, rhs: rhsSectionid, with: matcher), lhsSectionid, rhsSectionid, "sectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSubsectionid, rhs: rhsSubsectionid, with: matcher), lhsSubsectionid, rhsSubsectionid, "subSectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)

            case (.m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(let lhsCourseid, let lhsSubsectionid, let lhsVideos), .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(let rhsCourseid, let rhsSubsectionid, let rhsVideos)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSubsectionid, rhs: rhsSubsectionid, with: matcher), lhsSubsectionid, rhsSubsectionid, "subSectionID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsVideos, rhs: rhsVideos, with: matcher), lhsVideos, rhsVideos, "videos"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(p0, p1): return p0.intValue + p1.intValue
            case let .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(p0, p1): return p0.intValue + p1.intValue
            case let .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            case let .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId: return ".resumeCourseClicked(courseId:courseName:blockId:)"
            case .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".sequentialClicked(courseId:courseName:blockId:blockName:)"
            case .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".verticalClicked(courseId:courseName:blockId:blockName:)"
            case .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".nextBlockClicked(courseId:courseName:blockId:blockName:)"
            case .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".prevBlockClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".finishVerticalClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName: return ".finishVerticalNextSectionClicked(courseId:courseName:blockId:blockName:)"
            case .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName: return ".finishVerticalBackToOutlineClicked(courseId:courseName:)"
            case .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineCourseTabClicked(courseId:courseName:)"
            case .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineVideosTabClicked(courseId:courseName:)"
            case .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineDatesTabClicked(courseId:courseName:)"
            case .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineDiscussionTabClicked(courseId:courseName:)"
            case .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName: return ".courseOutlineHandoutsTabClicked(courseId:courseName:)"
            case .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported: return ".datesComponentTapped(courseId:blockId:link:supported:)"
            case .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action: return ".calendarSyncToggle(enrollmentMode:pacing:courseId:action:)"
            case .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action: return ".calendarSyncDialogAction(enrollmentMode:pacing:courseId:dialog:action:)"
            case .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar: return ".calendarSyncSnackbar(enrollmentMode:pacing:courseId:snackbar:)"
            case .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID: return ".trackCourseEvent(_:biValue:courseID:)"
            case .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type: return ".plsEvent(_:bivalue:courseID:screenName:type:)"
            case .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success: return ".plsSuccessEvent(_:bivalue:courseID:screenName:type:success:)"
            case .m_bulkDownloadVideosToggle__courseID_courseIDaction_action: return ".bulkDownloadVideosToggle(courseID:action:)"
            case .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos: return ".bulkDownloadVideosSubsection(courseID:sectionID:subSectionID:videos:)"
            case .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos: return ".bulkDeleteVideosSubsection(courseID:subSectionID:videos:)"
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

        public static func resumeCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>) -> Verify { return Verify(method: .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(`courseId`, `courseName`, `blockId`))}
        public static func sequentialClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func verticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func nextBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func prevBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalNextSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`))}
        public static func finishVerticalBackToOutlineClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineCourseTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineDatesTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineDiscussionTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func courseOutlineHandoutsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>) -> Verify { return Verify(method: .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`))}
        public static func datesComponentTapped(courseId: Parameter<String>, blockId: Parameter<String>, link: Parameter<String>, supported: Parameter<Bool>) -> Verify { return Verify(method: .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(`courseId`, `blockId`, `link`, `supported`))}
        public static func calendarSyncToggle(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, action: Parameter<CalendarDialogueAction>) -> Verify { return Verify(method: .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(`enrollmentMode`, `pacing`, `courseId`, `action`))}
        public static func calendarSyncDialogAction(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, dialog: Parameter<CalendarDialogueType>, action: Parameter<CalendarDialogueAction>) -> Verify { return Verify(method: .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`))}
        public static func calendarSyncSnackbar(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, snackbar: Parameter<SnackbarType>) -> Verify { return Verify(method: .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(`enrollmentMode`, `pacing`, `courseId`, `snackbar`))}
        public static func trackCourseEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>) -> Verify { return Verify(method: .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`))}
        public static func plsEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>) -> Verify { return Verify(method: .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(`event`, `bivalue`, `courseID`, `screenName`, `type`))}
        public static func plsSuccessEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, success: Parameter<Bool>) -> Verify { return Verify(method: .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`))}
        public static func bulkDownloadVideosToggle(courseID: Parameter<String>, action: Parameter<Bool>) -> Verify { return Verify(method: .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(`courseID`, `action`))}
        public static func bulkDownloadVideosSubsection(courseID: Parameter<String>, sectionID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(`courseID`, `sectionID`, `subSectionID`, `videos`))}
        public static func bulkDeleteVideosSubsection(courseID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>) -> Verify { return Verify(method: .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(`courseID`, `subSectionID`, `videos`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func resumeCourseClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_resumeCourseClicked__courseId_courseIdcourseName_courseNameblockId_blockId(`courseId`, `courseName`, `blockId`), performs: perform)
        }
        public static func sequentialClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_sequentialClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func verticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_verticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func nextBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_nextBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func prevBlockClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_prevBlockClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalNextSectionClicked(courseId: Parameter<String>, courseName: Parameter<String>, blockId: Parameter<String>, blockName: Parameter<String>, perform: @escaping (String, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalNextSectionClicked__courseId_courseIdcourseName_courseNameblockId_blockIdblockName_blockName(`courseId`, `courseName`, `blockId`, `blockName`), performs: perform)
        }
        public static func finishVerticalBackToOutlineClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_finishVerticalBackToOutlineClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineCourseTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineCourseTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineVideosTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineVideosTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineDatesTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineDatesTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineDiscussionTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineDiscussionTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func courseOutlineHandoutsTabClicked(courseId: Parameter<String>, courseName: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_courseOutlineHandoutsTabClicked__courseId_courseIdcourseName_courseName(`courseId`, `courseName`), performs: perform)
        }
        public static func datesComponentTapped(courseId: Parameter<String>, blockId: Parameter<String>, link: Parameter<String>, supported: Parameter<Bool>, perform: @escaping (String, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_datesComponentTapped__courseId_courseIdblockId_blockIdlink_linksupported_supported(`courseId`, `blockId`, `link`, `supported`), performs: perform)
        }
        public static func calendarSyncToggle(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, action: Parameter<CalendarDialogueAction>, perform: @escaping (EnrollmentMode, CoursePacing, String, CalendarDialogueAction) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncToggle__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdaction_action(`enrollmentMode`, `pacing`, `courseId`, `action`), performs: perform)
        }
        public static func calendarSyncDialogAction(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, dialog: Parameter<CalendarDialogueType>, action: Parameter<CalendarDialogueAction>, perform: @escaping (EnrollmentMode, CoursePacing, String, CalendarDialogueType, CalendarDialogueAction) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncDialogAction__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIddialog_dialogaction_action(`enrollmentMode`, `pacing`, `courseId`, `dialog`, `action`), performs: perform)
        }
        public static func calendarSyncSnackbar(enrollmentMode: Parameter<EnrollmentMode>, pacing: Parameter<CoursePacing>, courseId: Parameter<String>, snackbar: Parameter<SnackbarType>, perform: @escaping (EnrollmentMode, CoursePacing, String, SnackbarType) -> Void) -> Perform {
            return Perform(method: .m_calendarSyncSnackbar__enrollmentMode_enrollmentModepacing_pacingcourseId_courseIdsnackbar_snackbar(`enrollmentMode`, `pacing`, `courseId`, `snackbar`), performs: perform)
        }
        public static func trackCourseEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, courseID: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String) -> Void) -> Perform {
            return Perform(method: .m_trackCourseEvent__eventbiValue_biValuecourseID_courseID(`event`, `biValue`, `courseID`), performs: perform)
        }
        public static func plsEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String, String) -> Void) -> Perform {
            return Perform(method: .m_plsEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_type(`event`, `bivalue`, `courseID`, `screenName`, `type`), performs: perform)
        }
        public static func plsSuccessEvent(_ event: Parameter<AnalyticsEvent>, bivalue: Parameter<EventBIValue>, courseID: Parameter<String>, screenName: Parameter<String>, type: Parameter<String>, success: Parameter<Bool>, perform: @escaping (AnalyticsEvent, EventBIValue, String, String, String, Bool) -> Void) -> Perform {
            return Perform(method: .m_plsSuccessEvent__eventbivalue_bivaluecourseID_courseIDscreenName_screenNametype_typesuccess_success(`event`, `bivalue`, `courseID`, `screenName`, `type`, `success`), performs: perform)
        }
        public static func bulkDownloadVideosToggle(courseID: Parameter<String>, action: Parameter<Bool>, perform: @escaping (String, Bool) -> Void) -> Perform {
            return Perform(method: .m_bulkDownloadVideosToggle__courseID_courseIDaction_action(`courseID`, `action`), performs: perform)
        }
        public static func bulkDownloadVideosSubsection(courseID: Parameter<String>, sectionID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDownloadVideosSubsection__courseID_courseIDsectionID_sectionIDsubSectionID_subSectionIDvideos_videos(`courseID`, `sectionID`, `subSectionID`, `videos`), performs: perform)
        }
        public static func bulkDeleteVideosSubsection(courseID: Parameter<String>, subSectionID: Parameter<String>, videos: Parameter<Int>, perform: @escaping (String, String, Int) -> Void) -> Perform {
            return Perform(method: .m_bulkDeleteVideosSubsection__courseID_courseIDsubSectionID_subSectionIDvideos_videos(`courseID`, `subSectionID`, `videos`), performs: perform)
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

    open func getLoadedCourseBlocks(courseID: String) throws -> CourseStructure {
        addInvocation(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseStructure
		do {
		    __value = try methodReturnValue(.m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getLoadedCourseBlocks(courseID: String). Use given")
			Failure("Stub return value not specified for getLoadedCourseBlocks(courseID: String). Use given")
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

    open func getCourseDeadlineInfo(courseID: String) throws -> CourseDateBanner {
        addInvocation(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: CourseDateBanner
		do {
		    __value = try methodReturnValue(.m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for getCourseDeadlineInfo(courseID: String). Use given")
			Failure("Stub return value not specified for getCourseDeadlineInfo(courseID: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func shiftDueDates(courseID: String) throws {
        addInvocation(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		do {
		    _ = try methodReturnValue(.m_shiftDueDates__courseID_courseID(Parameter<String>.value(`courseID`))).casted() as Void
		} catch MockError.notStubed {
			// do nothing
		} catch {
		    throw error
		}
    }


    fileprivate enum MethodType {
        case m_getCourseBlocks__courseID_courseID(Parameter<String>)
        case m_getCourseVideoBlocks__fullStructure_fullStructure(Parameter<CourseStructure>)
        case m_getLoadedCourseBlocks__courseID_courseID(Parameter<String>)
        case m_blockCompletionRequest__courseID_courseIDblockID_blockID(Parameter<String>, Parameter<String>)
        case m_getHandouts__courseID_courseID(Parameter<String>)
        case m_getUpdates__courseID_courseID(Parameter<String>)
        case m_resumeBlock__courseID_courseID(Parameter<String>)
        case m_getSubtitles__url_urlselectedLanguage_selectedLanguage(Parameter<String>, Parameter<String>)
        case m_getCourseDates__courseID_courseID(Parameter<String>)
        case m_getCourseDeadlineInfo__courseID_courseID(Parameter<String>)
        case m_shiftDueDates__courseID_courseID(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_getCourseBlocks__courseID_courseID(let lhsCourseid), .m_getCourseBlocks__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseVideoBlocks__fullStructure_fullStructure(let lhsFullstructure), .m_getCourseVideoBlocks__fullStructure_fullStructure(let rhsFullstructure)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFullstructure, rhs: rhsFullstructure, with: matcher), lhsFullstructure, rhsFullstructure, "fullStructure"))
				return Matcher.ComparisonResult(results)

            case (.m_getLoadedCourseBlocks__courseID_courseID(let lhsCourseid), .m_getLoadedCourseBlocks__courseID_courseID(let rhsCourseid)):
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

            case (.m_getCourseDates__courseID_courseID(let lhsCourseid), .m_getCourseDates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_getCourseDeadlineInfo__courseID_courseID(let lhsCourseid), .m_getCourseDeadlineInfo__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_shiftDueDates__courseID_courseID(let lhsCourseid), .m_shiftDueDates__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_getCourseBlocks__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseVideoBlocks__fullStructure_fullStructure(p0): return p0.intValue
            case let .m_getLoadedCourseBlocks__courseID_courseID(p0): return p0.intValue
            case let .m_blockCompletionRequest__courseID_courseIDblockID_blockID(p0, p1): return p0.intValue + p1.intValue
            case let .m_getHandouts__courseID_courseID(p0): return p0.intValue
            case let .m_getUpdates__courseID_courseID(p0): return p0.intValue
            case let .m_resumeBlock__courseID_courseID(p0): return p0.intValue
            case let .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(p0, p1): return p0.intValue + p1.intValue
            case let .m_getCourseDates__courseID_courseID(p0): return p0.intValue
            case let .m_getCourseDeadlineInfo__courseID_courseID(p0): return p0.intValue
            case let .m_shiftDueDates__courseID_courseID(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_getCourseBlocks__courseID_courseID: return ".getCourseBlocks(courseID:)"
            case .m_getCourseVideoBlocks__fullStructure_fullStructure: return ".getCourseVideoBlocks(fullStructure:)"
            case .m_getLoadedCourseBlocks__courseID_courseID: return ".getLoadedCourseBlocks(courseID:)"
            case .m_blockCompletionRequest__courseID_courseIDblockID_blockID: return ".blockCompletionRequest(courseID:blockID:)"
            case .m_getHandouts__courseID_courseID: return ".getHandouts(courseID:)"
            case .m_getUpdates__courseID_courseID: return ".getUpdates(courseID:)"
            case .m_resumeBlock__courseID_courseID: return ".resumeBlock(courseID:)"
            case .m_getSubtitles__url_urlselectedLanguage_selectedLanguage: return ".getSubtitles(url:selectedLanguage:)"
            case .m_getCourseDates__courseID_courseID: return ".getCourseDates(courseID:)"
            case .m_getCourseDeadlineInfo__courseID_courseID: return ".getCourseDeadlineInfo(courseID:)"
            case .m_shiftDueDates__courseID_courseID: return ".shiftDueDates(courseID:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func getCourseBlocks(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseBlocks__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willReturn: CourseStructure...) -> MethodStub {
            return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func getCourseDates(courseID: Parameter<String>, willReturn: CourseDates...) -> MethodStub {
            return Given(method: .m_getCourseDates__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willReturn: CourseDateBanner...) -> MethodStub {
            return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, willProduce: (Stubber<CourseStructure>) -> Void) -> MethodStub {
            let willReturn: [CourseStructure] = []
			let given: Given = { return Given(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (CourseStructure).self)
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
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, willProduce: (StubberThrows<CourseStructure>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseStructure).self)
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
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, willProduce: (StubberThrows<CourseDateBanner>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CourseDateBanner).self)
			willProduce(stubber)
			return given
        }
        public static func shiftDueDates(courseID: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_shiftDueDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func shiftDueDates(courseID: Parameter<String>, willProduce: (StubberThrows<Void>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_shiftDueDates__courseID_courseID(`courseID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (Void).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func getCourseBlocks(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseBlocks__courseID_courseID(`courseID`))}
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>) -> Verify { return Verify(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`))}
        public static func getLoadedCourseBlocks(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`))}
        public static func blockCompletionRequest(courseID: Parameter<String>, blockID: Parameter<String>) -> Verify { return Verify(method: .m_blockCompletionRequest__courseID_courseIDblockID_blockID(`courseID`, `blockID`))}
        public static func getHandouts(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getHandouts__courseID_courseID(`courseID`))}
        public static func getUpdates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getUpdates__courseID_courseID(`courseID`))}
        public static func resumeBlock(courseID: Parameter<String>) -> Verify { return Verify(method: .m_resumeBlock__courseID_courseID(`courseID`))}
        public static func getSubtitles(url: Parameter<String>, selectedLanguage: Parameter<String>) -> Verify { return Verify(method: .m_getSubtitles__url_urlselectedLanguage_selectedLanguage(`url`, `selectedLanguage`))}
        public static func getCourseDates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDates__courseID_courseID(`courseID`))}
        public static func getCourseDeadlineInfo(courseID: Parameter<String>) -> Verify { return Verify(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`))}
        public static func shiftDueDates(courseID: Parameter<String>) -> Verify { return Verify(method: .m_shiftDueDates__courseID_courseID(`courseID`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func getCourseBlocks(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseBlocks__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseVideoBlocks(fullStructure: Parameter<CourseStructure>, perform: @escaping (CourseStructure) -> Void) -> Perform {
            return Perform(method: .m_getCourseVideoBlocks__fullStructure_fullStructure(`fullStructure`), performs: perform)
        }
        public static func getLoadedCourseBlocks(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getLoadedCourseBlocks__courseID_courseID(`courseID`), performs: perform)
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
        public static func getCourseDates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDates__courseID_courseID(`courseID`), performs: perform)
        }
        public static func getCourseDeadlineInfo(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getCourseDeadlineInfo__courseID_courseID(`courseID`), performs: perform)
        }
        public static func shiftDueDates(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_shiftDueDates__courseID_courseID(`courseID`), performs: perform)
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

// MARK: - CourseUpgradeHandlerProtocol

open class CourseUpgradeHandlerProtocolMock: CourseUpgradeHandlerProtocol, Mock {
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





    open func upgradeCourse(sku: String?, mode: UpgradeMode, productInfo: StoreProductInfo?, pacing: String, courseID: String, componentID: String?, screen: CourseUpgradeScreen, completion: UpgradeCompletionHandler?) {
        addInvocation(.m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(Parameter<String?>.value(`sku`), Parameter<UpgradeMode>.value(`mode`), Parameter<StoreProductInfo?>.value(`productInfo`), Parameter<String>.value(`pacing`), Parameter<String>.value(`courseID`), Parameter<String?>.value(`componentID`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<UpgradeCompletionHandler?>.value(`completion`)))
		let perform = methodPerformValue(.m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(Parameter<String?>.value(`sku`), Parameter<UpgradeMode>.value(`mode`), Parameter<StoreProductInfo?>.value(`productInfo`), Parameter<String>.value(`pacing`), Parameter<String>.value(`courseID`), Parameter<String?>.value(`componentID`), Parameter<CourseUpgradeScreen>.value(`screen`), Parameter<UpgradeCompletionHandler?>.value(`completion`))) as? (String?, UpgradeMode, StoreProductInfo?, String, String, String?, CourseUpgradeScreen, UpgradeCompletionHandler?) -> Void
		perform?(`sku`, `mode`, `productInfo`, `pacing`, `courseID`, `componentID`, `screen`, `completion`)
    }

    open func fetchProduct(sku: String) throws -> StoreProductInfo {
        addInvocation(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`)))
		let perform = methodPerformValue(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`))) as? (String) -> Void
		perform?(`sku`)
		var __value: StoreProductInfo
		do {
		    __value = try methodReturnValue(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for fetchProduct(sku: String). Use given")
			Failure("Stub return value not specified for fetchProduct(sku: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(Parameter<String?>, Parameter<UpgradeMode>, Parameter<StoreProductInfo?>, Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<CourseUpgradeScreen>, Parameter<UpgradeCompletionHandler?>)
        case m_fetchProduct__sku_sku(Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(let lhsSku, let lhsMode, let lhsProductinfo, let lhsPacing, let lhsCourseid, let lhsComponentid, let lhsScreen, let lhsCompletion), .m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(let rhsSku, let rhsMode, let rhsProductinfo, let rhsPacing, let rhsCourseid, let rhsComponentid, let rhsScreen, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsMode, rhs: rhsMode, with: matcher), lhsMode, rhsMode, "mode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsProductinfo, rhs: rhsProductinfo, with: matcher), lhsProductinfo, rhsProductinfo, "productInfo"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsComponentid, rhs: rhsComponentid, with: matcher), lhsComponentid, rhsComponentid, "componentID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_fetchProduct__sku_sku(let lhsSku), .m_fetchProduct__sku_sku(let rhsSku)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_fetchProduct__sku_sku(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion: return ".upgradeCourse(sku:mode:productInfo:pacing:courseID:componentID:screen:completion:)"
            case .m_fetchProduct__sku_sku: return ".fetchProduct(sku:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func fetchProduct(sku: Parameter<String>, willReturn: StoreProductInfo...) -> MethodStub {
            return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func fetchProduct(sku: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func fetchProduct(sku: Parameter<String>, willProduce: (StubberThrows<StoreProductInfo>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (StoreProductInfo).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func upgradeCourse(sku: Parameter<String?>, mode: Parameter<UpgradeMode>, productInfo: Parameter<StoreProductInfo?>, pacing: Parameter<String>, courseID: Parameter<String>, componentID: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, completion: Parameter<UpgradeCompletionHandler?>) -> Verify { return Verify(method: .m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(`sku`, `mode`, `productInfo`, `pacing`, `courseID`, `componentID`, `screen`, `completion`))}
        public static func fetchProduct(sku: Parameter<String>) -> Verify { return Verify(method: .m_fetchProduct__sku_sku(`sku`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func upgradeCourse(sku: Parameter<String?>, mode: Parameter<UpgradeMode>, productInfo: Parameter<StoreProductInfo?>, pacing: Parameter<String>, courseID: Parameter<String>, componentID: Parameter<String?>, screen: Parameter<CourseUpgradeScreen>, completion: Parameter<UpgradeCompletionHandler?>, perform: @escaping (String?, UpgradeMode, StoreProductInfo?, String, String, String?, CourseUpgradeScreen, UpgradeCompletionHandler?) -> Void) -> Perform {
            return Perform(method: .m_upgradeCourse__sku_skumode_modeproductInfo_productInfopacing_pacingcourseID_courseIDcomponentID_componentIDscreen_screencompletion_completion(`sku`, `mode`, `productInfo`, `pacing`, `courseID`, `componentID`, `screen`, `completion`), performs: perform)
        }
        public static func fetchProduct(sku: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_fetchProduct__sku_sku(`sku`), performs: perform)
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

// MARK: - CourseUpgradeHelperProtocol

open class CourseUpgradeHelperProtocolMock: CourseUpgradeHelperProtocol, Mock {
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





    open func setData(courseID: String, pacing: String, blockID: String?, localizedCoursePrice: String, screen: CourseUpgradeScreen) {
        addInvocation(.m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(Parameter<String>.value(`courseID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`localizedCoursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`)))
		let perform = methodPerformValue(.m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(Parameter<String>.value(`courseID`), Parameter<String>.value(`pacing`), Parameter<String?>.value(`blockID`), Parameter<String>.value(`localizedCoursePrice`), Parameter<CourseUpgradeScreen>.value(`screen`))) as? (String, String, String?, String, CourseUpgradeScreen) -> Void
		perform?(`courseID`, `pacing`, `blockID`, `localizedCoursePrice`, `screen`)
    }

    open func handleCourseUpgrade(upgradeHadler: CourseUpgradeHandler, state: UpgradeCompletionState, delegate: CourseUpgradeHelperDelegate?) {
        addInvocation(.m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(Parameter<CourseUpgradeHandler>.value(`upgradeHadler`), Parameter<UpgradeCompletionState>.value(`state`), Parameter<CourseUpgradeHelperDelegate?>.value(`delegate`)))
		let perform = methodPerformValue(.m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(Parameter<CourseUpgradeHandler>.value(`upgradeHadler`), Parameter<UpgradeCompletionState>.value(`state`), Parameter<CourseUpgradeHelperDelegate?>.value(`delegate`))) as? (CourseUpgradeHandler, UpgradeCompletionState, CourseUpgradeHelperDelegate?) -> Void
		perform?(`upgradeHadler`, `state`, `delegate`)
    }

    open func showLoader(animated: Bool, completion: (() -> Void)?) {
        addInvocation(.m_showLoader__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_showLoader__animated_animatedcompletion_completion(Parameter<Bool>.value(`animated`), Parameter<(() -> Void)?>.value(`completion`))) as? (Bool, (() -> Void)?) -> Void
		perform?(`animated`, `completion`)
    }

    open func removeLoader(success: Bool?, removeView: Bool?, completion: (() -> Void)?) {
        addInvocation(.m_removeLoader__success_successremoveView_removeViewcompletion_completion(Parameter<Bool?>.value(`success`), Parameter<Bool?>.value(`removeView`), Parameter<(() -> Void)?>.value(`completion`)))
		let perform = methodPerformValue(.m_removeLoader__success_successremoveView_removeViewcompletion_completion(Parameter<Bool?>.value(`success`), Parameter<Bool?>.value(`removeView`), Parameter<(() -> Void)?>.value(`completion`))) as? (Bool?, Bool?, (() -> Void)?) -> Void
		perform?(`success`, `removeView`, `completion`)
    }


    fileprivate enum MethodType {
        case m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<CourseUpgradeScreen>)
        case m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(Parameter<CourseUpgradeHandler>, Parameter<UpgradeCompletionState>, Parameter<CourseUpgradeHelperDelegate?>)
        case m_showLoader__animated_animatedcompletion_completion(Parameter<Bool>, Parameter<(() -> Void)?>)
        case m_removeLoader__success_successremoveView_removeViewcompletion_completion(Parameter<Bool?>, Parameter<Bool?>, Parameter<(() -> Void)?>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(let lhsCourseid, let lhsPacing, let lhsBlockid, let lhsLocalizedcourseprice, let lhsScreen), .m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(let rhsCourseid, let rhsPacing, let rhsBlockid, let rhsLocalizedcourseprice, let rhsScreen)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPacing, rhs: rhsPacing, with: matcher), lhsPacing, rhsPacing, "pacing"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "blockID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsLocalizedcourseprice, rhs: rhsLocalizedcourseprice, with: matcher), lhsLocalizedcourseprice, rhsLocalizedcourseprice, "localizedCoursePrice"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsScreen, rhs: rhsScreen, with: matcher), lhsScreen, rhsScreen, "screen"))
				return Matcher.ComparisonResult(results)

            case (.m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(let lhsUpgradehadler, let lhsState, let lhsDelegate), .m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(let rhsUpgradehadler, let rhsState, let rhsDelegate)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUpgradehadler, rhs: rhsUpgradehadler, with: matcher), lhsUpgradehadler, rhsUpgradehadler, "upgradeHadler"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsState, rhs: rhsState, with: matcher), lhsState, rhsState, "state"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDelegate, rhs: rhsDelegate, with: matcher), lhsDelegate, rhsDelegate, "delegate"))
				return Matcher.ComparisonResult(results)

            case (.m_showLoader__animated_animatedcompletion_completion(let lhsAnimated, let lhsCompletion), .m_showLoader__animated_animatedcompletion_completion(let rhsAnimated, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsAnimated, rhs: rhsAnimated, with: matcher), lhsAnimated, rhsAnimated, "animated"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_removeLoader__success_successremoveView_removeViewcompletion_completion(let lhsSuccess, let lhsRemoveview, let lhsCompletion), .m_removeLoader__success_successremoveView_removeViewcompletion_completion(let rhsSuccess, let rhsRemoveview, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSuccess, rhs: rhsSuccess, with: matcher), lhsSuccess, rhsSuccess, "success"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRemoveview, rhs: rhsRemoveview, with: matcher), lhsRemoveview, rhsRemoveview, "removeView"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(p0, p1, p2, p3, p4): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue
            case let .m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_showLoader__animated_animatedcompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_removeLoader__success_successremoveView_removeViewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen: return ".setData(courseID:pacing:blockID:localizedCoursePrice:screen:)"
            case .m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate: return ".handleCourseUpgrade(upgradeHadler:state:delegate:)"
            case .m_showLoader__animated_animatedcompletion_completion: return ".showLoader(animated:completion:)"
            case .m_removeLoader__success_successremoveView_removeViewcompletion_completion: return ".removeLoader(success:removeView:completion:)"
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

        public static func setData(courseID: Parameter<String>, pacing: Parameter<String>, blockID: Parameter<String?>, localizedCoursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>) -> Verify { return Verify(method: .m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(`courseID`, `pacing`, `blockID`, `localizedCoursePrice`, `screen`))}
        public static func handleCourseUpgrade(upgradeHadler: Parameter<CourseUpgradeHandler>, state: Parameter<UpgradeCompletionState>, delegate: Parameter<CourseUpgradeHelperDelegate?>) -> Verify { return Verify(method: .m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(`upgradeHadler`, `state`, `delegate`))}
        public static func showLoader(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_showLoader__animated_animatedcompletion_completion(`animated`, `completion`))}
        public static func removeLoader(success: Parameter<Bool?>, removeView: Parameter<Bool?>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_removeLoader__success_successremoveView_removeViewcompletion_completion(`success`, `removeView`, `completion`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func setData(courseID: Parameter<String>, pacing: Parameter<String>, blockID: Parameter<String?>, localizedCoursePrice: Parameter<String>, screen: Parameter<CourseUpgradeScreen>, perform: @escaping (String, String, String?, String, CourseUpgradeScreen) -> Void) -> Perform {
            return Perform(method: .m_setData__courseID_courseIDpacing_pacingblockID_blockIDlocalizedCoursePrice_localizedCoursePricescreen_screen(`courseID`, `pacing`, `blockID`, `localizedCoursePrice`, `screen`), performs: perform)
        }
        public static func handleCourseUpgrade(upgradeHadler: Parameter<CourseUpgradeHandler>, state: Parameter<UpgradeCompletionState>, delegate: Parameter<CourseUpgradeHelperDelegate?>, perform: @escaping (CourseUpgradeHandler, UpgradeCompletionState, CourseUpgradeHelperDelegate?) -> Void) -> Perform {
            return Perform(method: .m_handleCourseUpgrade__upgradeHadler_upgradeHadlerstate_statedelegate_delegate(`upgradeHadler`, `state`, `delegate`), performs: perform)
        }
        public static func showLoader(animated: Parameter<Bool>, completion: Parameter<(() -> Void)?>, perform: @escaping (Bool, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_showLoader__animated_animatedcompletion_completion(`animated`, `completion`), performs: perform)
        }
        public static func removeLoader(success: Parameter<Bool?>, removeView: Parameter<Bool?>, completion: Parameter<(() -> Void)?>, perform: @escaping (Bool?, Bool?, (() -> Void)?) -> Void) -> Perform {
            return Perform(method: .m_removeLoader__success_successremoveView_removeViewcompletion_completion(`success`, `removeView`, `completion`), performs: perform)
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

// MARK: - CourseUpgradeInteractorProtocol

open class CourseUpgradeInteractorProtocolMock: CourseUpgradeInteractorProtocol, Mock {
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





    open func addBasket(sku: String) throws -> UpgradeBasket {
        addInvocation(.m_addBasket__sku_sku(Parameter<String>.value(`sku`)))
		let perform = methodPerformValue(.m_addBasket__sku_sku(Parameter<String>.value(`sku`))) as? (String) -> Void
		perform?(`sku`)
		var __value: UpgradeBasket
		do {
		    __value = try methodReturnValue(.m_addBasket__sku_sku(Parameter<String>.value(`sku`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for addBasket(sku: String). Use given")
			Failure("Stub return value not specified for addBasket(sku: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func checkoutBasket(basketID: Int) throws -> CheckoutBasket {
        addInvocation(.m_checkoutBasket__basketID_basketID(Parameter<Int>.value(`basketID`)))
		let perform = methodPerformValue(.m_checkoutBasket__basketID_basketID(Parameter<Int>.value(`basketID`))) as? (Int) -> Void
		perform?(`basketID`)
		var __value: CheckoutBasket
		do {
		    __value = try methodReturnValue(.m_checkoutBasket__basketID_basketID(Parameter<Int>.value(`basketID`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for checkoutBasket(basketID: Int). Use given")
			Failure("Stub return value not specified for checkoutBasket(basketID: Int). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    @discardableResult
	open func fulfillCheckout(basketID: Int, price: NSDecimalNumber, currencyCode: String, receipt: String) throws -> FulfillCheckout {
        addInvocation(.m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(Parameter<Int>.value(`basketID`), Parameter<NSDecimalNumber>.value(`price`), Parameter<String>.value(`currencyCode`), Parameter<String>.value(`receipt`)))
		let perform = methodPerformValue(.m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(Parameter<Int>.value(`basketID`), Parameter<NSDecimalNumber>.value(`price`), Parameter<String>.value(`currencyCode`), Parameter<String>.value(`receipt`))) as? (Int, NSDecimalNumber, String, String) -> Void
		perform?(`basketID`, `price`, `currencyCode`, `receipt`)
		var __value: FulfillCheckout
		do {
		    __value = try methodReturnValue(.m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(Parameter<Int>.value(`basketID`), Parameter<NSDecimalNumber>.value(`price`), Parameter<String>.value(`currencyCode`), Parameter<String>.value(`receipt`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for fulfillCheckout(basketID: Int, price: NSDecimalNumber, currencyCode: String, receipt: String). Use given")
			Failure("Stub return value not specified for fulfillCheckout(basketID: Int, price: NSDecimalNumber, currencyCode: String, receipt: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_addBasket__sku_sku(Parameter<String>)
        case m_checkoutBasket__basketID_basketID(Parameter<Int>)
        case m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(Parameter<Int>, Parameter<NSDecimalNumber>, Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_addBasket__sku_sku(let lhsSku), .m_addBasket__sku_sku(let rhsSku)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				return Matcher.ComparisonResult(results)

            case (.m_checkoutBasket__basketID_basketID(let lhsBasketid), .m_checkoutBasket__basketID_basketID(let rhsBasketid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBasketid, rhs: rhsBasketid, with: matcher), lhsBasketid, rhsBasketid, "basketID"))
				return Matcher.ComparisonResult(results)

            case (.m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(let lhsBasketid, let lhsPrice, let lhsCurrencycode, let lhsReceipt), .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(let rhsBasketid, let rhsPrice, let rhsCurrencycode, let rhsReceipt)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBasketid, rhs: rhsBasketid, with: matcher), lhsBasketid, rhsBasketid, "basketID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsPrice, rhs: rhsPrice, with: matcher), lhsPrice, rhsPrice, "price"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCurrencycode, rhs: rhsCurrencycode, with: matcher), lhsCurrencycode, rhsCurrencycode, "currencyCode"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsReceipt, rhs: rhsReceipt, with: matcher), lhsReceipt, rhsReceipt, "receipt"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_addBasket__sku_sku(p0): return p0.intValue
            case let .m_checkoutBasket__basketID_basketID(p0): return p0.intValue
            case let .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(p0, p1, p2, p3): return p0.intValue + p1.intValue + p2.intValue + p3.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_addBasket__sku_sku: return ".addBasket(sku:)"
            case .m_checkoutBasket__basketID_basketID: return ".checkoutBasket(basketID:)"
            case .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt: return ".fulfillCheckout(basketID:price:currencyCode:receipt:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func addBasket(sku: Parameter<String>, willReturn: UpgradeBasket...) -> MethodStub {
            return Given(method: .m_addBasket__sku_sku(`sku`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func checkoutBasket(basketID: Parameter<Int>, willReturn: CheckoutBasket...) -> MethodStub {
            return Given(method: .m_checkoutBasket__basketID_basketID(`basketID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        @discardableResult
		public static func fulfillCheckout(basketID: Parameter<Int>, price: Parameter<NSDecimalNumber>, currencyCode: Parameter<String>, receipt: Parameter<String>, willReturn: FulfillCheckout...) -> MethodStub {
            return Given(method: .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(`basketID`, `price`, `currencyCode`, `receipt`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func addBasket(sku: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_addBasket__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func addBasket(sku: Parameter<String>, willProduce: (StubberThrows<UpgradeBasket>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_addBasket__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (UpgradeBasket).self)
			willProduce(stubber)
			return given
        }
        public static func checkoutBasket(basketID: Parameter<Int>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_checkoutBasket__basketID_basketID(`basketID`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func checkoutBasket(basketID: Parameter<Int>, willProduce: (StubberThrows<CheckoutBasket>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_checkoutBasket__basketID_basketID(`basketID`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (CheckoutBasket).self)
			willProduce(stubber)
			return given
        }
        @discardableResult
		public static func fulfillCheckout(basketID: Parameter<Int>, price: Parameter<NSDecimalNumber>, currencyCode: Parameter<String>, receipt: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(`basketID`, `price`, `currencyCode`, `receipt`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        @discardableResult
		public static func fulfillCheckout(basketID: Parameter<Int>, price: Parameter<NSDecimalNumber>, currencyCode: Parameter<String>, receipt: Parameter<String>, willProduce: (StubberThrows<FulfillCheckout>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(`basketID`, `price`, `currencyCode`, `receipt`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (FulfillCheckout).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func addBasket(sku: Parameter<String>) -> Verify { return Verify(method: .m_addBasket__sku_sku(`sku`))}
        public static func checkoutBasket(basketID: Parameter<Int>) -> Verify { return Verify(method: .m_checkoutBasket__basketID_basketID(`basketID`))}
        @discardableResult
		public static func fulfillCheckout(basketID: Parameter<Int>, price: Parameter<NSDecimalNumber>, currencyCode: Parameter<String>, receipt: Parameter<String>) -> Verify { return Verify(method: .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(`basketID`, `price`, `currencyCode`, `receipt`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func addBasket(sku: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_addBasket__sku_sku(`sku`), performs: perform)
        }
        public static func checkoutBasket(basketID: Parameter<Int>, perform: @escaping (Int) -> Void) -> Perform {
            return Perform(method: .m_checkoutBasket__basketID_basketID(`basketID`), performs: perform)
        }
        @discardableResult
		public static func fulfillCheckout(basketID: Parameter<Int>, price: Parameter<NSDecimalNumber>, currencyCode: Parameter<String>, receipt: Parameter<String>, perform: @escaping (Int, NSDecimalNumber, String, String) -> Void) -> Perform {
            return Perform(method: .m_fulfillCheckout__basketID_basketIDprice_pricecurrencyCode_currencyCodereceipt_receipt(`basketID`, `price`, `currencyCode`, `receipt`), performs: perform)
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
        case m_resumeDownloading
        case m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>)
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

            case (.m_resumeDownloading, .m_resumeDownloading): return .match

            case (.m_isLargeVideosSize__blocks_blocks(let lhsBlocks), .m_isLargeVideosSize__blocks_blocks(let rhsBlocks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				return Matcher.ComparisonResult(results)
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
            case .m_resumeDownloading: return 0
            case let .m_isLargeVideosSize__blocks_blocks(p0): return p0.intValue
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
            case .m_resumeDownloading: return ".resumeDownloading()"
            case .m_isLargeVideosSize__blocks_blocks: return ".isLargeVideosSize(blocks:)"
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
        public static func resumeDownloading() -> Verify { return Verify(method: .m_resumeDownloading)}
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_isLargeVideosSize__blocks_blocks(`blocks`))}
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
        public static func resumeDownloading(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resumeDownloading, performs: perform)
        }
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>, perform: @escaping ([CourseBlock]) -> Void) -> Perform {
            return Perform(method: .m_isLargeVideosSize__blocks_blocks(`blocks`), performs: perform)
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

// MARK: - StoreKitHandlerProtocol

open class StoreKitHandlerProtocolMock: StoreKitHandlerProtocol, Mock {
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





    open func fetchProduct(sku: String) throws -> StoreProductInfo {
        addInvocation(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`)))
		let perform = methodPerformValue(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`))) as? (String) -> Void
		perform?(`sku`)
		var __value: StoreProductInfo
		do {
		    __value = try methodReturnValue(.m_fetchProduct__sku_sku(Parameter<String>.value(`sku`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for fetchProduct(sku: String). Use given")
			Failure("Stub return value not specified for fetchProduct(sku: String). Use given")
		} catch {
		    throw error
		}
		return __value
    }

    open func fetchProduct(sku: String, completion: @escaping (StoreProductInfo?, Error?) -> Void) {
        addInvocation(.m_fetchProduct__sku_skucompletion_completion(Parameter<String>.value(`sku`), Parameter<(StoreProductInfo?, Error?) -> Void>.value(`completion`)))
		let perform = methodPerformValue(.m_fetchProduct__sku_skucompletion_completion(Parameter<String>.value(`sku`), Parameter<(StoreProductInfo?, Error?) -> Void>.value(`completion`))) as? (String, @escaping (StoreProductInfo?, Error?) -> Void) -> Void
		perform?(`sku`, `completion`)
    }

    open func completeTransactions() {
        addInvocation(.m_completeTransactions)
		let perform = methodPerformValue(.m_completeTransactions) as? () -> Void
		perform?()
    }

    open func purchaseProduct(_ identifier: String) -> StoreKitUpgradeResponse {
        addInvocation(.m_purchaseProduct__identifier(Parameter<String>.value(`identifier`)))
		let perform = methodPerformValue(.m_purchaseProduct__identifier(Parameter<String>.value(`identifier`))) as? (String) -> Void
		perform?(`identifier`)
		var __value: StoreKitUpgradeResponse
		do {
		    __value = try methodReturnValue(.m_purchaseProduct__identifier(Parameter<String>.value(`identifier`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for purchaseProduct(_ identifier: String). Use given")
			Failure("Stub return value not specified for purchaseProduct(_ identifier: String). Use given")
		}
		return __value
    }

    open func purchaseProduct(_ identifier: String, completion: PurchaseCompletionHandler?) {
        addInvocation(.m_purchaseProduct__identifiercompletion_completion(Parameter<String>.value(`identifier`), Parameter<PurchaseCompletionHandler?>.value(`completion`)))
		let perform = methodPerformValue(.m_purchaseProduct__identifiercompletion_completion(Parameter<String>.value(`identifier`), Parameter<PurchaseCompletionHandler?>.value(`completion`))) as? (String, PurchaseCompletionHandler?) -> Void
		perform?(`identifier`, `completion`)
    }

    open func purchaseReceipt(completion: PurchaseCompletionHandler?) {
        addInvocation(.m_purchaseReceipt__completion_completion(Parameter<PurchaseCompletionHandler?>.value(`completion`)))
		let perform = methodPerformValue(.m_purchaseReceipt__completion_completion(Parameter<PurchaseCompletionHandler?>.value(`completion`))) as? (PurchaseCompletionHandler?) -> Void
		perform?(`completion`)
    }

    open func purchaseReceipt() -> StoreKitUpgradeResponse {
        addInvocation(.m_purchaseReceipt)
		let perform = methodPerformValue(.m_purchaseReceipt) as? () -> Void
		perform?()
		var __value: StoreKitUpgradeResponse
		do {
		    __value = try methodReturnValue(.m_purchaseReceipt).casted()
		} catch {
			onFatalFailure("Stub return value not specified for purchaseReceipt(). Use given")
			Failure("Stub return value not specified for purchaseReceipt(). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_fetchProduct__sku_sku(Parameter<String>)
        case m_fetchProduct__sku_skucompletion_completion(Parameter<String>, Parameter<(StoreProductInfo?, Error?) -> Void>)
        case m_completeTransactions
        case m_purchaseProduct__identifier(Parameter<String>)
        case m_purchaseProduct__identifiercompletion_completion(Parameter<String>, Parameter<PurchaseCompletionHandler?>)
        case m_purchaseReceipt__completion_completion(Parameter<PurchaseCompletionHandler?>)
        case m_purchaseReceipt

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_fetchProduct__sku_sku(let lhsSku), .m_fetchProduct__sku_sku(let rhsSku)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				return Matcher.ComparisonResult(results)

            case (.m_fetchProduct__sku_skucompletion_completion(let lhsSku, let lhsCompletion), .m_fetchProduct__sku_skucompletion_completion(let rhsSku, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSku, rhs: rhsSku, with: matcher), lhsSku, rhsSku, "sku"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_completeTransactions, .m_completeTransactions): return .match

            case (.m_purchaseProduct__identifier(let lhsIdentifier), .m_purchaseProduct__identifier(let rhsIdentifier)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIdentifier, rhs: rhsIdentifier, with: matcher), lhsIdentifier, rhsIdentifier, "_ identifier"))
				return Matcher.ComparisonResult(results)

            case (.m_purchaseProduct__identifiercompletion_completion(let lhsIdentifier, let lhsCompletion), .m_purchaseProduct__identifiercompletion_completion(let rhsIdentifier, let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIdentifier, rhs: rhsIdentifier, with: matcher), lhsIdentifier, rhsIdentifier, "_ identifier"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_purchaseReceipt__completion_completion(let lhsCompletion), .m_purchaseReceipt__completion_completion(let rhsCompletion)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCompletion, rhs: rhsCompletion, with: matcher), lhsCompletion, rhsCompletion, "completion"))
				return Matcher.ComparisonResult(results)

            case (.m_purchaseReceipt, .m_purchaseReceipt): return .match
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_fetchProduct__sku_sku(p0): return p0.intValue
            case let .m_fetchProduct__sku_skucompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case .m_completeTransactions: return 0
            case let .m_purchaseProduct__identifier(p0): return p0.intValue
            case let .m_purchaseProduct__identifiercompletion_completion(p0, p1): return p0.intValue + p1.intValue
            case let .m_purchaseReceipt__completion_completion(p0): return p0.intValue
            case .m_purchaseReceipt: return 0
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_fetchProduct__sku_sku: return ".fetchProduct(sku:)"
            case .m_fetchProduct__sku_skucompletion_completion: return ".fetchProduct(sku:completion:)"
            case .m_completeTransactions: return ".completeTransactions()"
            case .m_purchaseProduct__identifier: return ".purchaseProduct(_:)"
            case .m_purchaseProduct__identifiercompletion_completion: return ".purchaseProduct(_:completion:)"
            case .m_purchaseReceipt__completion_completion: return ".purchaseReceipt(completion:)"
            case .m_purchaseReceipt: return ".purchaseReceipt()"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func fetchProduct(sku: Parameter<String>, willReturn: StoreProductInfo...) -> MethodStub {
            return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func purchaseProduct(_ identifier: Parameter<String>, willReturn: StoreKitUpgradeResponse...) -> MethodStub {
            return Given(method: .m_purchaseProduct__identifier(`identifier`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func purchaseReceipt(willReturn: StoreKitUpgradeResponse...) -> MethodStub {
            return Given(method: .m_purchaseReceipt, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func purchaseProduct(_ identifier: Parameter<String>, willProduce: (Stubber<StoreKitUpgradeResponse>) -> Void) -> MethodStub {
            let willReturn: [StoreKitUpgradeResponse] = []
			let given: Given = { return Given(method: .m_purchaseProduct__identifier(`identifier`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (StoreKitUpgradeResponse).self)
			willProduce(stubber)
			return given
        }
        public static func purchaseReceipt(willProduce: (Stubber<StoreKitUpgradeResponse>) -> Void) -> MethodStub {
            let willReturn: [StoreKitUpgradeResponse] = []
			let given: Given = { return Given(method: .m_purchaseReceipt, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (StoreKitUpgradeResponse).self)
			willProduce(stubber)
			return given
        }
        public static func fetchProduct(sku: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func fetchProduct(sku: Parameter<String>, willProduce: (StubberThrows<StoreProductInfo>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_fetchProduct__sku_sku(`sku`), products: willThrow.map({ StubProduct.throw($0) })) }()
			let stubber = given.stubThrows(for: (StoreProductInfo).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func fetchProduct(sku: Parameter<String>) -> Verify { return Verify(method: .m_fetchProduct__sku_sku(`sku`))}
        public static func fetchProduct(sku: Parameter<String>, completion: Parameter<(StoreProductInfo?, Error?) -> Void>) -> Verify { return Verify(method: .m_fetchProduct__sku_skucompletion_completion(`sku`, `completion`))}
        public static func completeTransactions() -> Verify { return Verify(method: .m_completeTransactions)}
        public static func purchaseProduct(_ identifier: Parameter<String>) -> Verify { return Verify(method: .m_purchaseProduct__identifier(`identifier`))}
        public static func purchaseProduct(_ identifier: Parameter<String>, completion: Parameter<PurchaseCompletionHandler?>) -> Verify { return Verify(method: .m_purchaseProduct__identifiercompletion_completion(`identifier`, `completion`))}
        public static func purchaseReceipt(completion: Parameter<PurchaseCompletionHandler?>) -> Verify { return Verify(method: .m_purchaseReceipt__completion_completion(`completion`))}
        public static func purchaseReceipt() -> Verify { return Verify(method: .m_purchaseReceipt)}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func fetchProduct(sku: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_fetchProduct__sku_sku(`sku`), performs: perform)
        }
        public static func fetchProduct(sku: Parameter<String>, completion: Parameter<(StoreProductInfo?, Error?) -> Void>, perform: @escaping (String, @escaping (StoreProductInfo?, Error?) -> Void) -> Void) -> Perform {
            return Perform(method: .m_fetchProduct__sku_skucompletion_completion(`sku`, `completion`), performs: perform)
        }
        public static func completeTransactions(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_completeTransactions, performs: perform)
        }
        public static func purchaseProduct(_ identifier: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_purchaseProduct__identifier(`identifier`), performs: perform)
        }
        public static func purchaseProduct(_ identifier: Parameter<String>, completion: Parameter<PurchaseCompletionHandler?>, perform: @escaping (String, PurchaseCompletionHandler?) -> Void) -> Perform {
            return Perform(method: .m_purchaseProduct__identifiercompletion_completion(`identifier`, `completion`), performs: perform)
        }
        public static func purchaseReceipt(completion: Parameter<PurchaseCompletionHandler?>, perform: @escaping (PurchaseCompletionHandler?) -> Void) -> Perform {
            return Perform(method: .m_purchaseReceipt__completion_completion(`completion`), performs: perform)
        }
        public static func purchaseReceipt(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_purchaseReceipt, performs: perform)
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

