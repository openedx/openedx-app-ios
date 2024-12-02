// Generated using Sourcery 2.1.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


// Generated with SwiftyMocky 4.2.0
// Required Sourcery: 1.8.0


import SwiftyMocky
import XCTest
import Core
import Authorization
import Foundation
import SwiftUI
import Combine
import OEXFoundation


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

    open func login(ssoToken: String) throws -> User {
        addInvocation(.m_login__ssoToken_ssoToken(Parameter<String>.value(`ssoToken`)))
		let perform = methodPerformValue(.m_login__ssoToken_ssoToken(Parameter<String>.value(`ssoToken`))) as? (String) -> Void
		perform?(`ssoToken`)
		var __value: User
		do {
		    __value = try methodReturnValue(.m_login__ssoToken_ssoToken(Parameter<String>.value(`ssoToken`))).casted()
		} catch MockError.notStubed {
			onFatalFailure("Stub return value not specified for login(ssoToken: String). Use given")
			Failure("Stub return value not specified for login(ssoToken: String). Use given")
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
        case m_login__ssoToken_ssoToken(Parameter<String>)
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

            case (.m_login__ssoToken_ssoToken(let lhsSsotoken), .m_login__ssoToken_ssoToken(let rhsSsotoken)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSsotoken, rhs: rhsSsotoken, with: matcher), lhsSsotoken, rhsSsotoken, "ssoToken"))
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
            case let .m_login__ssoToken_ssoToken(p0): return p0.intValue
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
            case .m_login__ssoToken_ssoToken: return ".login(ssoToken:)"
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
        public static func login(ssoToken: Parameter<String>, willReturn: User...) -> MethodStub {
            return Given(method: .m_login__ssoToken_ssoToken(`ssoToken`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func login(ssoToken: Parameter<String>, willThrow: Error...) -> MethodStub {
            return Given(method: .m_login__ssoToken_ssoToken(`ssoToken`), products: willThrow.map({ StubProduct.throw($0) }))
        }
        public static func login(ssoToken: Parameter<String>, willProduce: (StubberThrows<User>) -> Void) -> MethodStub {
            let willThrow: [Error] = []
			let given: Given = { return Given(method: .m_login__ssoToken_ssoToken(`ssoToken`), products: willThrow.map({ StubProduct.throw($0) })) }()
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
        public static func login(ssoToken: Parameter<String>) -> Verify { return Verify(method: .m_login__ssoToken_ssoToken(`ssoToken`))}
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
        public static func login(ssoToken: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_login__ssoToken_ssoToken(`ssoToken`), performs: perform)
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

// MARK: - AuthorizationAnalytics

open class AuthorizationAnalyticsMock: AuthorizationAnalytics, Mock {
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





    open func identify(id: String, username: String, email: String) {
        addInvocation(.m_identify__id_idusername_usernameemail_email(Parameter<String>.value(`id`), Parameter<String>.value(`username`), Parameter<String>.value(`email`)))
		let perform = methodPerformValue(.m_identify__id_idusername_usernameemail_email(Parameter<String>.value(`id`), Parameter<String>.value(`username`), Parameter<String>.value(`email`))) as? (String, String, String) -> Void
		perform?(`id`, `username`, `email`)
    }

    open func userLogin(method: AuthMethod) {
        addInvocation(.m_userLogin__method_method(Parameter<AuthMethod>.value(`method`)))
		let perform = methodPerformValue(.m_userLogin__method_method(Parameter<AuthMethod>.value(`method`))) as? (AuthMethod) -> Void
		perform?(`method`)
    }

    open func registerClicked() {
        addInvocation(.m_registerClicked)
		let perform = methodPerformValue(.m_registerClicked) as? () -> Void
		perform?()
    }

    open func signInClicked() {
        addInvocation(.m_signInClicked)
		let perform = methodPerformValue(.m_signInClicked) as? () -> Void
		perform?()
    }

    open func userSignInClicked() {
        addInvocation(.m_userSignInClicked)
		let perform = methodPerformValue(.m_userSignInClicked) as? () -> Void
		perform?()
    }

    open func createAccountClicked() {
        addInvocation(.m_createAccountClicked)
		let perform = methodPerformValue(.m_createAccountClicked) as? () -> Void
		perform?()
    }

    open func registrationSuccess(method: String) {
        addInvocation(.m_registrationSuccess__method_method(Parameter<String>.value(`method`)))
		let perform = methodPerformValue(.m_registrationSuccess__method_method(Parameter<String>.value(`method`))) as? (String) -> Void
		perform?(`method`)
    }

    open func forgotPasswordClicked() {
        addInvocation(.m_forgotPasswordClicked)
		let perform = methodPerformValue(.m_forgotPasswordClicked) as? () -> Void
		perform?()
    }

    open func resetPasswordClicked() {
        addInvocation(.m_resetPasswordClicked)
		let perform = methodPerformValue(.m_resetPasswordClicked) as? () -> Void
		perform?()
    }

    open func resetPassword(success: Bool) {
        addInvocation(.m_resetPassword__success_success(Parameter<Bool>.value(`success`)))
		let perform = methodPerformValue(.m_resetPassword__success_success(Parameter<Bool>.value(`success`))) as? (Bool) -> Void
		perform?(`success`)
    }

    open func authTrackScreenEvent(_ event: AnalyticsEvent, biValue: EventBIValue) {
        addInvocation(.m_authTrackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`)))
		let perform = methodPerformValue(.m_authTrackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>.value(`event`), Parameter<EventBIValue>.value(`biValue`))) as? (AnalyticsEvent, EventBIValue) -> Void
		perform?(`event`, `biValue`)
    }


    fileprivate enum MethodType {
        case m_identify__id_idusername_usernameemail_email(Parameter<String>, Parameter<String>, Parameter<String>)
        case m_userLogin__method_method(Parameter<AuthMethod>)
        case m_registerClicked
        case m_signInClicked
        case m_userSignInClicked
        case m_createAccountClicked
        case m_registrationSuccess__method_method(Parameter<String>)
        case m_forgotPasswordClicked
        case m_resetPasswordClicked
        case m_resetPassword__success_success(Parameter<Bool>)
        case m_authTrackScreenEvent__eventbiValue_biValue(Parameter<AnalyticsEvent>, Parameter<EventBIValue>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_identify__id_idusername_usernameemail_email(let lhsId, let lhsUsername, let lhsEmail), .m_identify__id_idusername_usernameemail_email(let rhsId, let rhsUsername, let rhsEmail)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsId, rhs: rhsId, with: matcher), lhsId, rhsId, "id"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUsername, rhs: rhsUsername, with: matcher), lhsUsername, rhsUsername, "username"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEmail, rhs: rhsEmail, with: matcher), lhsEmail, rhsEmail, "email"))
				return Matcher.ComparisonResult(results)

            case (.m_userLogin__method_method(let lhsMethod), .m_userLogin__method_method(let rhsMethod)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsMethod, rhs: rhsMethod, with: matcher), lhsMethod, rhsMethod, "method"))
				return Matcher.ComparisonResult(results)

            case (.m_registerClicked, .m_registerClicked): return .match

            case (.m_signInClicked, .m_signInClicked): return .match

            case (.m_userSignInClicked, .m_userSignInClicked): return .match

            case (.m_createAccountClicked, .m_createAccountClicked): return .match

            case (.m_registrationSuccess__method_method(let lhsMethod), .m_registrationSuccess__method_method(let rhsMethod)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsMethod, rhs: rhsMethod, with: matcher), lhsMethod, rhsMethod, "method"))
				return Matcher.ComparisonResult(results)

            case (.m_forgotPasswordClicked, .m_forgotPasswordClicked): return .match

            case (.m_resetPasswordClicked, .m_resetPasswordClicked): return .match

            case (.m_resetPassword__success_success(let lhsSuccess), .m_resetPassword__success_success(let rhsSuccess)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsSuccess, rhs: rhsSuccess, with: matcher), lhsSuccess, rhsSuccess, "success"))
				return Matcher.ComparisonResult(results)

            case (.m_authTrackScreenEvent__eventbiValue_biValue(let lhsEvent, let lhsBivalue), .m_authTrackScreenEvent__eventbiValue_biValue(let rhsEvent, let rhsBivalue)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsEvent, rhs: rhsEvent, with: matcher), lhsEvent, rhsEvent, "_ event"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBivalue, rhs: rhsBivalue, with: matcher), lhsBivalue, rhsBivalue, "biValue"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_identify__id_idusername_usernameemail_email(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_userLogin__method_method(p0): return p0.intValue
            case .m_registerClicked: return 0
            case .m_signInClicked: return 0
            case .m_userSignInClicked: return 0
            case .m_createAccountClicked: return 0
            case let .m_registrationSuccess__method_method(p0): return p0.intValue
            case .m_forgotPasswordClicked: return 0
            case .m_resetPasswordClicked: return 0
            case let .m_resetPassword__success_success(p0): return p0.intValue
            case let .m_authTrackScreenEvent__eventbiValue_biValue(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_identify__id_idusername_usernameemail_email: return ".identify(id:username:email:)"
            case .m_userLogin__method_method: return ".userLogin(method:)"
            case .m_registerClicked: return ".registerClicked()"
            case .m_signInClicked: return ".signInClicked()"
            case .m_userSignInClicked: return ".userSignInClicked()"
            case .m_createAccountClicked: return ".createAccountClicked()"
            case .m_registrationSuccess__method_method: return ".registrationSuccess(method:)"
            case .m_forgotPasswordClicked: return ".forgotPasswordClicked()"
            case .m_resetPasswordClicked: return ".resetPasswordClicked()"
            case .m_resetPassword__success_success: return ".resetPassword(success:)"
            case .m_authTrackScreenEvent__eventbiValue_biValue: return ".authTrackScreenEvent(_:biValue:)"
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

        public static func identify(id: Parameter<String>, username: Parameter<String>, email: Parameter<String>) -> Verify { return Verify(method: .m_identify__id_idusername_usernameemail_email(`id`, `username`, `email`))}
        public static func userLogin(method: Parameter<AuthMethod>) -> Verify { return Verify(method: .m_userLogin__method_method(`method`))}
        public static func registerClicked() -> Verify { return Verify(method: .m_registerClicked)}
        public static func signInClicked() -> Verify { return Verify(method: .m_signInClicked)}
        public static func userSignInClicked() -> Verify { return Verify(method: .m_userSignInClicked)}
        public static func createAccountClicked() -> Verify { return Verify(method: .m_createAccountClicked)}
        public static func registrationSuccess(method: Parameter<String>) -> Verify { return Verify(method: .m_registrationSuccess__method_method(`method`))}
        public static func forgotPasswordClicked() -> Verify { return Verify(method: .m_forgotPasswordClicked)}
        public static func resetPasswordClicked() -> Verify { return Verify(method: .m_resetPasswordClicked)}
        public static func resetPassword(success: Parameter<Bool>) -> Verify { return Verify(method: .m_resetPassword__success_success(`success`))}
        public static func authTrackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>) -> Verify { return Verify(method: .m_authTrackScreenEvent__eventbiValue_biValue(`event`, `biValue`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func identify(id: Parameter<String>, username: Parameter<String>, email: Parameter<String>, perform: @escaping (String, String, String) -> Void) -> Perform {
            return Perform(method: .m_identify__id_idusername_usernameemail_email(`id`, `username`, `email`), performs: perform)
        }
        public static func userLogin(method: Parameter<AuthMethod>, perform: @escaping (AuthMethod) -> Void) -> Perform {
            return Perform(method: .m_userLogin__method_method(`method`), performs: perform)
        }
        public static func registerClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_registerClicked, performs: perform)
        }
        public static func signInClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_signInClicked, performs: perform)
        }
        public static func userSignInClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_userSignInClicked, performs: perform)
        }
        public static func createAccountClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_createAccountClicked, performs: perform)
        }
        public static func registrationSuccess(method: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_registrationSuccess__method_method(`method`), performs: perform)
        }
        public static func forgotPasswordClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_forgotPasswordClicked, performs: perform)
        }
        public static func resetPasswordClicked(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_resetPasswordClicked, performs: perform)
        }
        public static func resetPassword(success: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_resetPassword__success_success(`success`), performs: perform)
        }
        public static func authTrackScreenEvent(_ event: Parameter<AnalyticsEvent>, biValue: Parameter<EventBIValue>, perform: @escaping (AnalyticsEvent, EventBIValue) -> Void) -> Perform {
            return Perform(method: .m_authTrackScreenEvent__eventbiValue_biValue(`event`, `biValue`), performs: perform)
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

// MARK: - AuthorizationRouter

open class AuthorizationRouterMock: AuthorizationRouter, Mock {
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





    open func showUpdateRequiredView(showAccountLink: Bool) {
        addInvocation(.m_showUpdateRequiredView__showAccountLink_showAccountLink(Parameter<Bool>.value(`showAccountLink`)))
		let perform = methodPerformValue(.m_showUpdateRequiredView__showAccountLink_showAccountLink(Parameter<Bool>.value(`showAccountLink`))) as? (Bool) -> Void
		perform?(`showAccountLink`)
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

    open func showSSOWebBrowser(title: String) {
        addInvocation(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
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
        case m_showUpdateRequiredView__showAccountLink_showAccountLink(Parameter<Bool>)
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
        case m_showSSOWebBrowser__title_title(Parameter<String>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(Parameter<String>, Parameter<String>, Parameter<String>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<AlertViewType>)
        case m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(Parameter<String>, Parameter<String>, Parameter<String?>, Parameter<String>, Parameter<SwiftUI.Image>, Parameter<() -> Void>, Parameter<() -> Void>, Parameter<() -> Void>)
        case m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(Parameter<UIModalTransitionStyle>, Parameter<any View>, Parameter<(() -> Void)?>)
        case m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(Parameter<UIModalTransitionStyle>, Parameter<Bool>, Parameter<() -> any View>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_showUpdateRequiredView__showAccountLink_showAccountLink(let lhsShowaccountlink), .m_showUpdateRequiredView__showAccountLink_showAccountLink(let rhsShowaccountlink)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsShowaccountlink, rhs: rhsShowaccountlink, with: matcher), lhsShowaccountlink, rhsShowaccountlink, "showAccountLink"))
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

            case (.m_showSSOWebBrowser__title_title(let lhsTitle), .m_showSSOWebBrowser__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
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
            case let .m_showUpdateRequiredView__showAccountLink_showAccountLink(p0): return p0.intValue
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
            case let .m_showSSOWebBrowser__title_title(p0): return p0.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(p0, p1, p2, p3, p4, p5): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue
            case let .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(p0, p1, p2, p3, p4, p5, p6, p7): return p0.intValue + p1.intValue + p2.intValue + p3.intValue + p4.intValue + p5.intValue + p6.intValue + p7.intValue
            case let .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_showUpdateRequiredView__showAccountLink_showAccountLink: return ".showUpdateRequiredView(showAccountLink:)"
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
            case .m_showSSOWebBrowser__title_title: return ".showSSOWebBrowser(title:)"
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

        public static func showUpdateRequiredView(showAccountLink: Parameter<Bool>) -> Verify { return Verify(method: .m_showUpdateRequiredView__showAccountLink_showAccountLink(`showAccountLink`))}
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
        public static func showSSOWebBrowser(title: Parameter<String>) -> Verify { return Verify(method: .m_showSSOWebBrowser__title_title(`title`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, positiveAction: Parameter<String>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, type: Parameter<AlertViewType>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagepositiveAction_positiveActiononCloseTapped_onCloseTappedokTapped_okTappedtype_type(`alertTitle`, `alertMessage`, `positiveAction`, `onCloseTapped`, `okTapped`, `type`))}
        public static func presentAlert(alertTitle: Parameter<String>, alertMessage: Parameter<String>, nextSectionName: Parameter<String?>, action: Parameter<String>, image: Parameter<SwiftUI.Image>, onCloseTapped: Parameter<() -> Void>, okTapped: Parameter<() -> Void>, nextSectionTapped: Parameter<() -> Void>) -> Verify { return Verify(method: .m_presentAlert__alertTitle_alertTitlealertMessage_alertMessagenextSectionName_nextSectionNameaction_actionimage_imageonCloseTapped_onCloseTappedokTapped_okTappednextSectionTapped_nextSectionTapped(`alertTitle`, `alertMessage`, `nextSectionName`, `action`, `image`, `onCloseTapped`, `okTapped`, `nextSectionTapped`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, view: Parameter<any View>, completion: Parameter<(() -> Void)?>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleview_viewcompletion_completion(`transitionStyle`, `view`, `completion`))}
        public static func presentView(transitionStyle: Parameter<UIModalTransitionStyle>, animated: Parameter<Bool>, content: Parameter<() -> any View>) -> Verify { return Verify(method: .m_presentView__transitionStyle_transitionStyleanimated_animatedcontent_content(`transitionStyle`, `animated`, `content`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func showUpdateRequiredView(showAccountLink: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_showUpdateRequiredView__showAccountLink_showAccountLink(`showAccountLink`), performs: perform)
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
        public static func showSSOWebBrowser(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showSSOWebBrowser__title_title(`title`), performs: perform)
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

    open func showSSOWebBrowser(title: String) {
        addInvocation(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`)))
		let perform = methodPerformValue(.m_showSSOWebBrowser__title_title(Parameter<String>.value(`title`))) as? (String) -> Void
		perform?(`title`)
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
        case m_showSSOWebBrowser__title_title(Parameter<String>)
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

            case (.m_showSSOWebBrowser__title_title(let lhsTitle), .m_showSSOWebBrowser__title_title(let rhsTitle)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTitle, rhs: rhsTitle, with: matcher), lhsTitle, rhsTitle, "title"))
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
            case let .m_showSSOWebBrowser__title_title(p0): return p0.intValue
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
            case .m_showSSOWebBrowser__title_title: return ".showSSOWebBrowser(title:)"
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
        public static func showSSOWebBrowser(title: Parameter<String>) -> Verify { return Verify(method: .m_showSSOWebBrowser__title_title(`title`))}
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
        public static func showSSOWebBrowser(title: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_showSSOWebBrowser__title_title(`title`), performs: perform)
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

// MARK: - CalendarManagerProtocol

open class CalendarManagerProtocolMock: CalendarManagerProtocol, Mock {
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





    open func createCalendarIfNeeded() {
        addInvocation(.m_createCalendarIfNeeded)
		let perform = methodPerformValue(.m_createCalendarIfNeeded) as? () -> Void
		perform?()
    }

    open func filterCoursesBySelected(fetchedCourses: [CourseForSync]) -> [CourseForSync] {
        addInvocation(.m_filterCoursesBySelected__fetchedCourses_fetchedCourses(Parameter<[CourseForSync]>.value(`fetchedCourses`)))
		let perform = methodPerformValue(.m_filterCoursesBySelected__fetchedCourses_fetchedCourses(Parameter<[CourseForSync]>.value(`fetchedCourses`))) as? ([CourseForSync]) -> Void
		perform?(`fetchedCourses`)
		var __value: [CourseForSync]
		do {
		    __value = try methodReturnValue(.m_filterCoursesBySelected__fetchedCourses_fetchedCourses(Parameter<[CourseForSync]>.value(`fetchedCourses`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for filterCoursesBySelected(fetchedCourses: [CourseForSync]). Use given")
			Failure("Stub return value not specified for filterCoursesBySelected(fetchedCourses: [CourseForSync]). Use given")
		}
		return __value
    }

    open func removeOldCalendar() {
        addInvocation(.m_removeOldCalendar)
		let perform = methodPerformValue(.m_removeOldCalendar) as? () -> Void
		perform?()
    }

    open func removeOutdatedEvents(courseID: String) {
        addInvocation(.m_removeOutdatedEvents__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_removeOutdatedEvents__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
    }

    open func syncCourse(courseID: String, courseName: String, dates: CourseDates) {
        addInvocation(.m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`), Parameter<CourseDates>.value(`dates`)))
		let perform = methodPerformValue(.m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(Parameter<String>.value(`courseID`), Parameter<String>.value(`courseName`), Parameter<CourseDates>.value(`dates`))) as? (String, String, CourseDates) -> Void
		perform?(`courseID`, `courseName`, `dates`)
    }

    open func requestAccess() -> Bool {
        addInvocation(.m_requestAccess)
		let perform = methodPerformValue(.m_requestAccess) as? () -> Void
		perform?()
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_requestAccess).casted()
		} catch {
			onFatalFailure("Stub return value not specified for requestAccess(). Use given")
			Failure("Stub return value not specified for requestAccess(). Use given")
		}
		return __value
    }

    open func courseStatus(courseID: String) -> SyncStatus {
        addInvocation(.m_courseStatus__courseID_courseID(Parameter<String>.value(`courseID`)))
		let perform = methodPerformValue(.m_courseStatus__courseID_courseID(Parameter<String>.value(`courseID`))) as? (String) -> Void
		perform?(`courseID`)
		var __value: SyncStatus
		do {
		    __value = try methodReturnValue(.m_courseStatus__courseID_courseID(Parameter<String>.value(`courseID`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for courseStatus(courseID: String). Use given")
			Failure("Stub return value not specified for courseStatus(courseID: String). Use given")
		}
		return __value
    }

    open func clearAllData(removeCalendar: Bool) {
        addInvocation(.m_clearAllData__removeCalendar_removeCalendar(Parameter<Bool>.value(`removeCalendar`)))
		let perform = methodPerformValue(.m_clearAllData__removeCalendar_removeCalendar(Parameter<Bool>.value(`removeCalendar`))) as? (Bool) -> Void
		perform?(`removeCalendar`)
    }

    open func isDatesChanged(courseID: String, checksum: String) -> Bool {
        addInvocation(.m_isDatesChanged__courseID_courseIDchecksum_checksum(Parameter<String>.value(`courseID`), Parameter<String>.value(`checksum`)))
		let perform = methodPerformValue(.m_isDatesChanged__courseID_courseIDchecksum_checksum(Parameter<String>.value(`courseID`), Parameter<String>.value(`checksum`))) as? (String, String) -> Void
		perform?(`courseID`, `checksum`)
		var __value: Bool
		do {
		    __value = try methodReturnValue(.m_isDatesChanged__courseID_courseIDchecksum_checksum(Parameter<String>.value(`courseID`), Parameter<String>.value(`checksum`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for isDatesChanged(courseID: String, checksum: String). Use given")
			Failure("Stub return value not specified for isDatesChanged(courseID: String, checksum: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_createCalendarIfNeeded
        case m_filterCoursesBySelected__fetchedCourses_fetchedCourses(Parameter<[CourseForSync]>)
        case m_removeOldCalendar
        case m_removeOutdatedEvents__courseID_courseID(Parameter<String>)
        case m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(Parameter<String>, Parameter<String>, Parameter<CourseDates>)
        case m_requestAccess
        case m_courseStatus__courseID_courseID(Parameter<String>)
        case m_clearAllData__removeCalendar_removeCalendar(Parameter<Bool>)
        case m_isDatesChanged__courseID_courseIDchecksum_checksum(Parameter<String>, Parameter<String>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_createCalendarIfNeeded, .m_createCalendarIfNeeded): return .match

            case (.m_filterCoursesBySelected__fetchedCourses_fetchedCourses(let lhsFetchedcourses), .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(let rhsFetchedcourses)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsFetchedcourses, rhs: rhsFetchedcourses, with: matcher), lhsFetchedcourses, rhsFetchedcourses, "fetchedCourses"))
				return Matcher.ComparisonResult(results)

            case (.m_removeOldCalendar, .m_removeOldCalendar): return .match

            case (.m_removeOutdatedEvents__courseID_courseID(let lhsCourseid), .m_removeOutdatedEvents__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(let lhsCourseid, let lhsCoursename, let lhsDates), .m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(let rhsCourseid, let rhsCoursename, let rhsDates)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCoursename, rhs: rhsCoursename, with: matcher), lhsCoursename, rhsCoursename, "courseName"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDates, rhs: rhsDates, with: matcher), lhsDates, rhsDates, "dates"))
				return Matcher.ComparisonResult(results)

            case (.m_requestAccess, .m_requestAccess): return .match

            case (.m_courseStatus__courseID_courseID(let lhsCourseid), .m_courseStatus__courseID_courseID(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				return Matcher.ComparisonResult(results)

            case (.m_clearAllData__removeCalendar_removeCalendar(let lhsRemovecalendar), .m_clearAllData__removeCalendar_removeCalendar(let rhsRemovecalendar)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsRemovecalendar, rhs: rhsRemovecalendar, with: matcher), lhsRemovecalendar, rhsRemovecalendar, "removeCalendar"))
				return Matcher.ComparisonResult(results)

            case (.m_isDatesChanged__courseID_courseIDchecksum_checksum(let lhsCourseid, let lhsChecksum), .m_isDatesChanged__courseID_courseIDchecksum_checksum(let rhsCourseid, let rhsChecksum)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseID"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsChecksum, rhs: rhsChecksum, with: matcher), lhsChecksum, rhsChecksum, "checksum"))
				return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case .m_createCalendarIfNeeded: return 0
            case let .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(p0): return p0.intValue
            case .m_removeOldCalendar: return 0
            case let .m_removeOutdatedEvents__courseID_courseID(p0): return p0.intValue
            case let .m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case .m_requestAccess: return 0
            case let .m_courseStatus__courseID_courseID(p0): return p0.intValue
            case let .m_clearAllData__removeCalendar_removeCalendar(p0): return p0.intValue
            case let .m_isDatesChanged__courseID_courseIDchecksum_checksum(p0, p1): return p0.intValue + p1.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_createCalendarIfNeeded: return ".createCalendarIfNeeded()"
            case .m_filterCoursesBySelected__fetchedCourses_fetchedCourses: return ".filterCoursesBySelected(fetchedCourses:)"
            case .m_removeOldCalendar: return ".removeOldCalendar()"
            case .m_removeOutdatedEvents__courseID_courseID: return ".removeOutdatedEvents(courseID:)"
            case .m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates: return ".syncCourse(courseID:courseName:dates:)"
            case .m_requestAccess: return ".requestAccess()"
            case .m_courseStatus__courseID_courseID: return ".courseStatus(courseID:)"
            case .m_clearAllData__removeCalendar_removeCalendar: return ".clearAllData(removeCalendar:)"
            case .m_isDatesChanged__courseID_courseIDchecksum_checksum: return ".isDatesChanged(courseID:checksum:)"
            }
        }
    }

    open class Given: StubbedMethod {
        fileprivate var method: MethodType

        private init(method: MethodType, products: [StubProduct]) {
            self.method = method
            super.init(products)
        }


        public static func filterCoursesBySelected(fetchedCourses: Parameter<[CourseForSync]>, willReturn: [CourseForSync]...) -> MethodStub {
            return Given(method: .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(`fetchedCourses`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func requestAccess(willReturn: Bool...) -> MethodStub {
            return Given(method: .m_requestAccess, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func courseStatus(courseID: Parameter<String>, willReturn: SyncStatus...) -> MethodStub {
            return Given(method: .m_courseStatus__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func isDatesChanged(courseID: Parameter<String>, checksum: Parameter<String>, willReturn: Bool...) -> MethodStub {
            return Given(method: .m_isDatesChanged__courseID_courseIDchecksum_checksum(`courseID`, `checksum`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func filterCoursesBySelected(fetchedCourses: Parameter<[CourseForSync]>, willProduce: (Stubber<[CourseForSync]>) -> Void) -> MethodStub {
            let willReturn: [[CourseForSync]] = []
			let given: Given = { return Given(method: .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(`fetchedCourses`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([CourseForSync]).self)
			willProduce(stubber)
			return given
        }
        public static func requestAccess(willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_requestAccess, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
        public static func courseStatus(courseID: Parameter<String>, willProduce: (Stubber<SyncStatus>) -> Void) -> MethodStub {
            let willReturn: [SyncStatus] = []
			let given: Given = { return Given(method: .m_courseStatus__courseID_courseID(`courseID`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (SyncStatus).self)
			willProduce(stubber)
			return given
        }
        public static func isDatesChanged(courseID: Parameter<String>, checksum: Parameter<String>, willProduce: (Stubber<Bool>) -> Void) -> MethodStub {
            let willReturn: [Bool] = []
			let given: Given = { return Given(method: .m_isDatesChanged__courseID_courseIDchecksum_checksum(`courseID`, `checksum`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: (Bool).self)
			willProduce(stubber)
			return given
        }
    }

    public struct Verify {
        fileprivate var method: MethodType

        public static func createCalendarIfNeeded() -> Verify { return Verify(method: .m_createCalendarIfNeeded)}
        public static func filterCoursesBySelected(fetchedCourses: Parameter<[CourseForSync]>) -> Verify { return Verify(method: .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(`fetchedCourses`))}
        public static func removeOldCalendar() -> Verify { return Verify(method: .m_removeOldCalendar)}
        public static func removeOutdatedEvents(courseID: Parameter<String>) -> Verify { return Verify(method: .m_removeOutdatedEvents__courseID_courseID(`courseID`))}
        public static func syncCourse(courseID: Parameter<String>, courseName: Parameter<String>, dates: Parameter<CourseDates>) -> Verify { return Verify(method: .m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(`courseID`, `courseName`, `dates`))}
        public static func requestAccess() -> Verify { return Verify(method: .m_requestAccess)}
        public static func courseStatus(courseID: Parameter<String>) -> Verify { return Verify(method: .m_courseStatus__courseID_courseID(`courseID`))}
        public static func clearAllData(removeCalendar: Parameter<Bool>) -> Verify { return Verify(method: .m_clearAllData__removeCalendar_removeCalendar(`removeCalendar`))}
        public static func isDatesChanged(courseID: Parameter<String>, checksum: Parameter<String>) -> Verify { return Verify(method: .m_isDatesChanged__courseID_courseIDchecksum_checksum(`courseID`, `checksum`))}
    }

    public struct Perform {
        fileprivate var method: MethodType
        var performs: Any

        public static func createCalendarIfNeeded(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_createCalendarIfNeeded, performs: perform)
        }
        public static func filterCoursesBySelected(fetchedCourses: Parameter<[CourseForSync]>, perform: @escaping ([CourseForSync]) -> Void) -> Perform {
            return Perform(method: .m_filterCoursesBySelected__fetchedCourses_fetchedCourses(`fetchedCourses`), performs: perform)
        }
        public static func removeOldCalendar(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_removeOldCalendar, performs: perform)
        }
        public static func removeOutdatedEvents(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_removeOutdatedEvents__courseID_courseID(`courseID`), performs: perform)
        }
        public static func syncCourse(courseID: Parameter<String>, courseName: Parameter<String>, dates: Parameter<CourseDates>, perform: @escaping (String, String, CourseDates) -> Void) -> Perform {
            return Perform(method: .m_syncCourse__courseID_courseIDcourseName_courseNamedates_dates(`courseID`, `courseName`, `dates`), performs: perform)
        }
        public static func requestAccess(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_requestAccess, performs: perform)
        }
        public static func courseStatus(courseID: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_courseStatus__courseID_courseID(`courseID`), performs: perform)
        }
        public static func clearAllData(removeCalendar: Parameter<Bool>, perform: @escaping (Bool) -> Void) -> Perform {
            return Perform(method: .m_clearAllData__removeCalendar_removeCalendar(`removeCalendar`), performs: perform)
        }
        public static func isDatesChanged(courseID: Parameter<String>, checksum: Parameter<String>, perform: @escaping (String, String) -> Void) -> Perform {
            return Perform(method: .m_isDatesChanged__courseID_courseIDchecksum_checksum(`courseID`, `checksum`), performs: perform)
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
    open func deleteDownloadDataTasks(ids: [String]) {
        addInvocation(.m_deleteDownloadDataTasks__ids_ids(Parameter<[String]>.value(`ids`)))
        let perform = methodPerformValue(.m_deleteDownloadDataTasks__ids_ids(Parameter<[String]>.value(`ids`))) as? ([String]) -> Void
        perform?(`ids`)
    }
    
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

    open func addToDownloadQueue(tasks: [DownloadDataTask]) {
        addInvocation(.m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>.value(`tasks`)))
		let perform = methodPerformValue(.m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>.value(`tasks`))) as? ([DownloadDataTask]) -> Void
		perform?(`tasks`)
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

    open func addToDownloadQueue(blocks: [CourseBlock], downloadQuality: DownloadQuality) {
        addInvocation(.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>.value(`blocks`), Parameter<DownloadQuality>.value(`downloadQuality`)))
		let perform = methodPerformValue(.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>.value(`blocks`), Parameter<DownloadQuality>.value(`downloadQuality`))) as? ([CourseBlock], DownloadQuality) -> Void
		perform?(`blocks`, `downloadQuality`)
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

    open func saveDownloadDataTask(_ task: DownloadDataTask) {
        addInvocation(.m_saveDownloadDataTask__task(Parameter<DownloadDataTask>.value(`task`)))
		let perform = methodPerformValue(.m_saveDownloadDataTask__task(Parameter<DownloadDataTask>.value(`task`))) as? (DownloadDataTask) -> Void
		perform?(`task`)
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

    open func getDownloadDataTasks() -> [DownloadDataTask] {
        addInvocation(.m_getDownloadDataTasks)
		let perform = methodPerformValue(.m_getDownloadDataTasks) as? () -> Void
		perform?()
		var __value: [DownloadDataTask]
		do {
		    __value = try methodReturnValue(.m_getDownloadDataTasks).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getDownloadDataTasks(). Use given")
			Failure("Stub return value not specified for getDownloadDataTasks(). Use given")
		}
		return __value
    }

    open func getDownloadDataTasksForCourse(_ courseId: String) -> [DownloadDataTask] {
        addInvocation(.m_getDownloadDataTasksForCourse__courseId(Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_getDownloadDataTasksForCourse__courseId(Parameter<String>.value(`courseId`))) as? (String) -> Void
		perform?(`courseId`)
		var __value: [DownloadDataTask]
		do {
		    __value = try methodReturnValue(.m_getDownloadDataTasksForCourse__courseId(Parameter<String>.value(`courseId`))).casted()
		} catch {
			onFatalFailure("Stub return value not specified for getDownloadDataTasksForCourse(_ courseId: String). Use given")
			Failure("Stub return value not specified for getDownloadDataTasksForCourse(_ courseId: String). Use given")
		}
		return __value
    }


    fileprivate enum MethodType {
        case m_set__userId_userId(Parameter<Int>)
        case m_getUserID
        case m_publisher
        case m_addToDownloadQueue__tasks_tasks(Parameter<[DownloadDataTask]>)
        case m_saveOfflineProgress__progress_progress(Parameter<OfflineProgress>)
        case m_loadProgress__for_blockID(Parameter<String>)
        case m_loadAllOfflineProgress
        case m_deleteProgress__for_blockID(Parameter<String>)
        case m_deleteAllProgress
        case m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(Parameter<[CourseBlock]>, Parameter<DownloadQuality>)
        case m_nextBlockForDownloading
        case m_updateDownloadState__id_idstate_stateresumeData_resumeData(Parameter<String>, Parameter<DownloadState>, Parameter<Data?>)
        case m_deleteDownloadDataTask__id_id(Parameter<String>)
        case m_saveDownloadDataTask__task(Parameter<DownloadDataTask>)
        case m_downloadDataTask__for_blockId(Parameter<String>)
        case m_getDownloadDataTasks
        case m_getDownloadDataTasksForCourse__courseId(Parameter<String>)
        case m_deleteDownloadDataTasks__ids_ids(Parameter<[String]>)

        static func compareParameters(lhs: MethodType, rhs: MethodType, matcher: Matcher) -> Matcher.ComparisonResult {
            switch (lhs, rhs) {
            case (.m_set__userId_userId(let lhsUserid), .m_set__userId_userId(let rhsUserid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsUserid, rhs: rhsUserid, with: matcher), lhsUserid, rhsUserid, "userId"))
				return Matcher.ComparisonResult(results)

            case (.m_getUserID, .m_getUserID): return .match

            case (.m_publisher, .m_publisher): return .match

            case (.m_addToDownloadQueue__tasks_tasks(let lhsTasks), .m_addToDownloadQueue__tasks_tasks(let rhsTasks)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTasks, rhs: rhsTasks, with: matcher), lhsTasks, rhsTasks, "tasks"))
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

            case (.m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(let lhsBlocks, let lhsDownloadquality), .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(let rhsBlocks, let rhsDownloadquality)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsDownloadquality, rhs: rhsDownloadquality, with: matcher), lhsDownloadquality, rhsDownloadquality, "downloadQuality"))
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

            case (.m_saveDownloadDataTask__task(let lhsTask), .m_saveDownloadDataTask__task(let rhsTask)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsTask, rhs: rhsTask, with: matcher), lhsTask, rhsTask, "_ task"))
				return Matcher.ComparisonResult(results)

            case (.m_downloadDataTask__for_blockId(let lhsBlockid), .m_downloadDataTask__for_blockId(let rhsBlockid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlockid, rhs: rhsBlockid, with: matcher), lhsBlockid, rhsBlockid, "for blockId"))
				return Matcher.ComparisonResult(results)

            case (.m_getDownloadDataTasks, .m_getDownloadDataTasks): return .match

            case (.m_getDownloadDataTasksForCourse__courseId(let lhsCourseid), .m_getDownloadDataTasksForCourse__courseId(let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "_ courseId"))
				return Matcher.ComparisonResult(results)
            case (.m_deleteDownloadDataTasks__ids_ids(let lhsIds), .m_deleteDownloadDataTasks__ids_ids(let rhsIds)):
                var results: [Matcher.ParameterComparisonResult] = []
                results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsIds, rhs: rhsIds, with: matcher), lhsIds, rhsIds, "ids"))
                return Matcher.ComparisonResult(results)
            default: return .none
            }
        }

        func intValue() -> Int {
            switch self {
            case let .m_set__userId_userId(p0): return p0.intValue
            case .m_getUserID: return 0
            case .m_publisher: return 0
            case let .m_addToDownloadQueue__tasks_tasks(p0): return p0.intValue
            case let .m_saveOfflineProgress__progress_progress(p0): return p0.intValue
            case let .m_loadProgress__for_blockID(p0): return p0.intValue
            case .m_loadAllOfflineProgress: return 0
            case let .m_deleteProgress__for_blockID(p0): return p0.intValue
            case .m_deleteAllProgress: return 0
            case let .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(p0, p1): return p0.intValue + p1.intValue
            case .m_nextBlockForDownloading: return 0
            case let .m_updateDownloadState__id_idstate_stateresumeData_resumeData(p0, p1, p2): return p0.intValue + p1.intValue + p2.intValue
            case let .m_deleteDownloadDataTask__id_id(p0): return p0.intValue
            case let .m_saveDownloadDataTask__task(p0): return p0.intValue
            case let .m_downloadDataTask__for_blockId(p0): return p0.intValue
            case .m_getDownloadDataTasks: return 0
            case let .m_getDownloadDataTasksForCourse__courseId(p0): return p0.intValue
            case let .m_deleteDownloadDataTasks__ids_ids(p0): return p0.intValue
            }
        }
        func assertionName() -> String {
            switch self {
            case .m_set__userId_userId: return ".set(userId:)"
            case .m_getUserID: return ".getUserID()"
            case .m_publisher: return ".publisher()"
            case .m_addToDownloadQueue__tasks_tasks: return ".addToDownloadQueue(tasks:)"
            case .m_saveOfflineProgress__progress_progress: return ".saveOfflineProgress(progress:)"
            case .m_loadProgress__for_blockID: return ".loadProgress(for:)"
            case .m_loadAllOfflineProgress: return ".loadAllOfflineProgress()"
            case .m_deleteProgress__for_blockID: return ".deleteProgress(for:)"
            case .m_deleteAllProgress: return ".deleteAllProgress()"
            case .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality: return ".addToDownloadQueue(blocks:downloadQuality:)"
            case .m_nextBlockForDownloading: return ".nextBlockForDownloading()"
            case .m_updateDownloadState__id_idstate_stateresumeData_resumeData: return ".updateDownloadState(id:state:resumeData:)"
            case .m_deleteDownloadDataTask__id_id: return ".deleteDownloadDataTask(id:)"
            case .m_saveDownloadDataTask__task: return ".saveDownloadDataTask(_:)"
            case .m_downloadDataTask__for_blockId: return ".downloadDataTask(for:)"
            case .m_getDownloadDataTasks: return ".getDownloadDataTasks()"
            case .m_getDownloadDataTasksForCourse__courseId: return ".getDownloadDataTasksForCourse(_:)"
            case .m_deleteDownloadDataTasks__ids_ids: return ".deleteDownloadDataTasks(ids:)"
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
        public static func loadProgress(for blockID: Parameter<String>, willReturn: OfflineProgress?...) -> MethodStub {
            return Given(method: .m_loadProgress__for_blockID(`blockID`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func loadAllOfflineProgress(willReturn: [OfflineProgress]...) -> MethodStub {
            return Given(method: .m_loadAllOfflineProgress, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func nextBlockForDownloading(willReturn: DownloadDataTask?...) -> MethodStub {
            return Given(method: .m_nextBlockForDownloading, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func downloadDataTask(for blockId: Parameter<String>, willReturn: DownloadDataTask?...) -> MethodStub {
            return Given(method: .m_downloadDataTask__for_blockId(`blockId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadDataTasks(willReturn: [DownloadDataTask]...) -> MethodStub {
            return Given(method: .m_getDownloadDataTasks, products: willReturn.map({ StubProduct.return($0 as Any) }))
        }
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>, willReturn: [DownloadDataTask]...) -> MethodStub {
            return Given(method: .m_getDownloadDataTasksForCourse__courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) }))
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
        public static func getDownloadDataTasks(willProduce: (Stubber<[DownloadDataTask]>) -> Void) -> MethodStub {
            let willReturn: [[DownloadDataTask]] = []
			let given: Given = { return Given(method: .m_getDownloadDataTasks, products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DownloadDataTask]).self)
			willProduce(stubber)
			return given
        }
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>, willProduce: (Stubber<[DownloadDataTask]>) -> Void) -> MethodStub {
            let willReturn: [[DownloadDataTask]] = []
			let given: Given = { return Given(method: .m_getDownloadDataTasksForCourse__courseId(`courseId`), products: willReturn.map({ StubProduct.return($0 as Any) })) }()
			let stubber = given.stub(for: ([DownloadDataTask]).self)
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
        public static func addToDownloadQueue(tasks: Parameter<[DownloadDataTask]>) -> Verify { return Verify(method: .m_addToDownloadQueue__tasks_tasks(`tasks`))}
        public static func saveOfflineProgress(progress: Parameter<OfflineProgress>) -> Verify { return Verify(method: .m_saveOfflineProgress__progress_progress(`progress`))}
        public static func loadProgress(for blockID: Parameter<String>) -> Verify { return Verify(method: .m_loadProgress__for_blockID(`blockID`))}
        public static func loadAllOfflineProgress() -> Verify { return Verify(method: .m_loadAllOfflineProgress)}
        public static func deleteProgress(for blockID: Parameter<String>) -> Verify { return Verify(method: .m_deleteProgress__for_blockID(`blockID`))}
        public static func deleteAllProgress() -> Verify { return Verify(method: .m_deleteAllProgress)}
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, downloadQuality: Parameter<DownloadQuality>) -> Verify { return Verify(method: .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(`blocks`, `downloadQuality`))}
        public static func nextBlockForDownloading() -> Verify { return Verify(method: .m_nextBlockForDownloading)}
        public static func updateDownloadState(id: Parameter<String>, state: Parameter<DownloadState>, resumeData: Parameter<Data?>) -> Verify { return Verify(method: .m_updateDownloadState__id_idstate_stateresumeData_resumeData(`id`, `state`, `resumeData`))}
        public static func deleteDownloadDataTask(id: Parameter<String>) -> Verify { return Verify(method: .m_deleteDownloadDataTask__id_id(`id`))}
        public static func saveDownloadDataTask(_ task: Parameter<DownloadDataTask>) -> Verify { return Verify(method: .m_saveDownloadDataTask__task(`task`))}
        public static func downloadDataTask(for blockId: Parameter<String>) -> Verify { return Verify(method: .m_downloadDataTask__for_blockId(`blockId`))}
        public static func getDownloadDataTasks() -> Verify { return Verify(method: .m_getDownloadDataTasks)}
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>) -> Verify { return Verify(method: .m_getDownloadDataTasksForCourse__courseId(`courseId`))}
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
        public static func addToDownloadQueue(tasks: Parameter<[DownloadDataTask]>, perform: @escaping ([DownloadDataTask]) -> Void) -> Perform {
            return Perform(method: .m_addToDownloadQueue__tasks_tasks(`tasks`), performs: perform)
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
        public static func addToDownloadQueue(blocks: Parameter<[CourseBlock]>, downloadQuality: Parameter<DownloadQuality>, perform: @escaping ([CourseBlock], DownloadQuality) -> Void) -> Perform {
            return Perform(method: .m_addToDownloadQueue__blocks_blocksdownloadQuality_downloadQuality(`blocks`, `downloadQuality`), performs: perform)
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
        public static func saveDownloadDataTask(_ task: Parameter<DownloadDataTask>, perform: @escaping (DownloadDataTask) -> Void) -> Perform {
            return Perform(method: .m_saveDownloadDataTask__task(`task`), performs: perform)
        }
        public static func downloadDataTask(for blockId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_downloadDataTask__for_blockId(`blockId`), performs: perform)
        }
        public static func getDownloadDataTasks(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_getDownloadDataTasks, performs: perform)
        }
        public static func getDownloadDataTasksForCourse(_ courseId: Parameter<String>, perform: @escaping (String) -> Void) -> Perform {
            return Perform(method: .m_getDownloadDataTasksForCourse__courseId(`courseId`), performs: perform)
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

    open func deleteAll() {
        addInvocation(.m_deleteAll)
		let perform = methodPerformValue(.m_deleteAll) as? () -> Void
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

    open func delete(blocks: [CourseBlock], courseId: String) {
        addInvocation(.m_delete__blocks_blockscourseId_courseId(Parameter<[CourseBlock]>.value(`blocks`), Parameter<String>.value(`courseId`)))
		let perform = methodPerformValue(.m_delete__blocks_blockscourseId_courseId(Parameter<[CourseBlock]>.value(`blocks`), Parameter<String>.value(`courseId`))) as? ([CourseBlock], String) -> Void
		perform?(`blocks`, `courseId`)
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
        case m_deleteAll
        case m_fileUrl__for_blockId(Parameter<String>)
        case m_updateUnzippedFileSize__for_sequentials(Parameter<[CourseSequential]>)
        case m_resumeDownloading
        case m_isLargeVideosSize__blocks_blocks(Parameter<[CourseBlock]>)
        case m_removeAppSupportDirectoryUnusedContent
        case m_delete__blocks_blockscourseId_courseId(Parameter<[CourseBlock]>, Parameter<String>)
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

            case (.m_deleteAll, .m_deleteAll): return .match

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

            case (.m_delete__blocks_blockscourseId_courseId(let lhsBlocks, let lhsCourseid), .m_delete__blocks_blockscourseId_courseId(let rhsBlocks, let rhsCourseid)):
				var results: [Matcher.ParameterComparisonResult] = []
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsBlocks, rhs: rhsBlocks, with: matcher), lhsBlocks, rhsBlocks, "blocks"))
				results.append(Matcher.ParameterComparisonResult(Parameter.compare(lhs: lhsCourseid, rhs: rhsCourseid, with: matcher), lhsCourseid, rhsCourseid, "courseId"))
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
            case .m_deleteAll: return 0
            case let .m_fileUrl__for_blockId(p0): return p0.intValue
            case let .m_updateUnzippedFileSize__for_sequentials(p0): return p0.intValue
            case .m_resumeDownloading: return 0
            case let .m_isLargeVideosSize__blocks_blocks(p0): return p0.intValue
            case .m_removeAppSupportDirectoryUnusedContent: return 0
            case let .m_delete__blocks_blockscourseId_courseId(p0, p1): return p0.intValue + p1.intValue
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
            case .m_deleteAll: return ".deleteAll()"
            case .m_fileUrl__for_blockId: return ".fileUrl(for:)"
            case .m_updateUnzippedFileSize__for_sequentials: return ".updateUnzippedFileSize(for:)"
            case .m_resumeDownloading: return ".resumeDownloading()"
            case .m_isLargeVideosSize__blocks_blocks: return ".isLargeVideosSize(blocks:)"
            case .m_removeAppSupportDirectoryUnusedContent: return ".removeAppSupportDirectoryUnusedContent()"
            case .m_delete__blocks_blockscourseId_courseId: return ".delete(blocks:courseId:)"
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
        public static func deleteAll() -> Verify { return Verify(method: .m_deleteAll)}
        public static func fileUrl(for blockId: Parameter<String>) -> Verify { return Verify(method: .m_fileUrl__for_blockId(`blockId`))}
        public static func updateUnzippedFileSize(for sequentials: Parameter<[CourseSequential]>) -> Verify { return Verify(method: .m_updateUnzippedFileSize__for_sequentials(`sequentials`))}
        public static func resumeDownloading() -> Verify { return Verify(method: .m_resumeDownloading)}
        public static func isLargeVideosSize(blocks: Parameter<[CourseBlock]>) -> Verify { return Verify(method: .m_isLargeVideosSize__blocks_blocks(`blocks`))}
        public static func removeAppSupportDirectoryUnusedContent() -> Verify { return Verify(method: .m_removeAppSupportDirectoryUnusedContent)}
        public static func delete(blocks: Parameter<[CourseBlock]>, courseId: Parameter<String>) -> Verify { return Verify(method: .m_delete__blocks_blockscourseId_courseId(`blocks`, `courseId`))}
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
        public static func deleteAll(perform: @escaping () -> Void) -> Perform {
            return Perform(method: .m_deleteAll, performs: perform)
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
        public static func delete(blocks: Parameter<[CourseBlock]>, courseId: Parameter<String>, perform: @escaping ([CourseBlock], String) -> Void) -> Perform {
            return Perform(method: .m_delete__blocks_blockscourseId_courseId(`blocks`, `courseId`), performs: perform)
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

