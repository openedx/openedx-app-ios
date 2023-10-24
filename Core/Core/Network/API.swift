//
//  API.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import Alamofire
import WebKit

public final class API {
    
    private let session: Alamofire.Session
    private let config: Config
    
    public init(session: Session, config: Config) {
        self.session = session
        self.config = config
    }
    
    @discardableResult
    public func requestData(
        _ route: EndPointType
    ) async throws -> Data {
        switch route.task {
        case .request:
            return try await callData(route)
        case let .requestParameters(parameters, encoding):
            return try await callData(route, parameters: parameters, encoding: encoding)
        case let .requestCodable(parameters, encoding):
            let params = try? parameters?.asDictionary()
            return try await callData(route, parameters: params, encoding: encoding)
        case .requestCookies:
            return try await callCookies(route)
        case .upload:
            throw APIError.invalidRequest
        }
    }
    
    public func request(
        _ route: EndPointType
    ) async throws -> HTTPURLResponse {
        switch route.task {
        case .request:
            return try await callResponse(route)
        case let .requestParameters(parameters, encoding):
            return try await callResponse(route, parameters: parameters, encoding: encoding)
        case let .requestCodable(parameters, encoding):
            let params = try? parameters?.asDictionary()
            return try await callResponse(route, parameters: params, encoding: encoding)
        case .requestCookies:
            return try await callResponse(route)
        case let .upload(data):
            return try await uploadData(route, data: data)
        }
    }
    
    private func callData(
        _ route: EndPointType,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> Data {
        var url = config.baseURL
        if !route.path.isEmpty {
            url = url.appendingPathComponent(route.path)
        }
        
        let result = session.request(
            url,
            method: route.httpMethod,
            parameters: parameters,
            encoding: encoding,
            headers: route.headers
        ).validateResponse().serializingData()
        if let lastDate = await result.response.response?.headers["EDX-APP-VERSION-LAST-SUPPORTED-DATE"] {
            NotificationCenter.default.post(name: .appVersionLastSupportedDate, object: lastDate)
        }
        if let latestVersion = await result.response.response?.headers["EDX-APP-LATEST-VERSION"] {
            NotificationCenter.default.post(name: .appLatestVersion, object: latestVersion)
        }
        await print(">>>> 1", result.response.response?.headers["EDX-APP-VERSION-LAST-SUPPORTED-DATE"])
        await print(">>>> 1", result.response.response?.headers["EDX-APP-LATEST-VERSION"])
        return try await result.value
    }
    
    private func callCookies(
        _ route: EndPointType,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> Data {
        var url = config.baseURL
        if !route.path.isEmpty {
            url = url.appendingPathComponent(route.path)
        }
        let response = session.request(
            url,
            method: route.httpMethod,
            parameters: parameters,
            encoding: encoding,
            headers: route.headers
        )
        
        let value = try await response.validateResponse().serializingData().value
        
        parseAndSetCookies(response: response.response)
        return value
    }
    
    private func uploadData(
        _ route: EndPointType,
        data: Data
    ) async throws -> HTTPURLResponse {
        var url = config.baseURL
        if !route.path.isEmpty {
            url = url.appendingPathComponent(route.path)
        }
        
        let response = await session.request(
            url,
            method: route.httpMethod,
            encoding: UploadBodyEncoding(body: data),
            headers: route.headers
        ).validateResponse().serializingResponse(using: .string).response
        
        if let response = response.response {
            return response
        } else if let error = response.error {
            throw error
        } else {
            throw APIError.unknown
        }
    }
    
    private func parseAndSetCookies(response: HTTPURLResponse?) {
        guard let fields = response?.allHeaderFields as? [String: String] else { return }
        let url = config.baseURL
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: fields, for: url)
        HTTPCookieStorage.shared.cookies?.forEach { HTTPCookieStorage.shared.deleteCookie($0) }
        HTTPCookieStorage.shared.setCookies(cookies, for: url, mainDocumentURL: nil)
        DispatchQueue.main.async {
            let cookies = HTTPCookieStorage.shared.cookies ?? []
            for c in cookies {
                WKWebsiteDataStore.default().httpCookieStore.setCookie(c)
            }
        }
    }
    
    private func callResponse(
        _ route: EndPointType,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default
    ) async throws -> HTTPURLResponse {
        var url = config.baseURL
        if !route.path.isEmpty {
            url = url.appendingPathComponent(route.path)
        }
        let serializer = DataResponseSerializer(emptyResponseCodes: [200, 204, 205])
        
        let response = await session.request(
            url,
            method: route.httpMethod,
            parameters: parameters,
            encoding: encoding,
            headers: route.headers
        ).validateResponse().serializingResponse(using: serializer).response
        
        if let error = response.error {
            throw error
        } else if let response = response.response {
            return response
        } else {
            throw APIError.unknown
        }
    }
}

public enum APIError: Int, LocalizedError {
    case unknown        = -100
    case emptyData      = -200
    case invalidGrant   = -300
    case parsingError   = -400
    case invalidRequest = -500
    case uploadError    = -600
    
    public var errorDescription: String? {
        switch self {
        default:
            return nil
        }
    }
    
    public var localizedDescription: String {
        return errorDescription ?? ""
    }
}

public struct CustomValidationError: LocalizedError {
    public let statusCode: Int
    public let data: [String: Any]?
    
    public init(statusCode: Int, data: [String: Any]?) {
        self.statusCode = statusCode
        self.data = data
    }
}

extension DataRequest {
    func validateResponse() -> Self {
        return validateStatusCode().validateContentType()
    }
    
    func validateStatusCode() -> Self {
        return validate { _, response, data in
            switch response.statusCode {
            case 200...299:
                return .success(())
            case 400...403:
                if let data {
                    if let dataString = String(data: data, encoding: .utf8) {
                        if dataString.first == "{" && dataString.last == "}" {
                            let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                            return .failure(CustomValidationError(statusCode: response.statusCode, data: json))
                        } else {
                            let reason: AFError.ResponseValidationFailureReason
                            = .unacceptableStatusCode(code: response.statusCode)
                            return .failure(AFError.responseValidationFailed(reason: reason))
                        }
                    }
                }
                let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: response.statusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            default:
                let reason: AFError.ResponseValidationFailureReason = .unacceptableStatusCode(code: response.statusCode)
                return .failure(AFError.responseValidationFailed(reason: reason))
            }
        }
    }
    
    func validateContentType() -> Self {
        let contentTypes: () -> [String] = { [unowned self] in
            if let accept = request?.value(forHTTPHeaderField: "Accept") {
                return accept.components(separatedBy: ",")
            }
            return ["*/*"]
        }
        return validate(contentType: contentTypes())
    }
}

public struct CustomGetEncoding: ParameterEncoding {
    public init() {}
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%5B%5D=", with: "="))
        return request
    }
}

extension Encodable {
    func asDictionary() throws -> [String: Any] {
        let data = try JSONEncoder().encode(self)
        guard let dictionary = try JSONSerialization.jsonObject(
            with: data,
            options: .fragmentsAllowed
        ) as? [String: Any] else {
            throw NSError()
        }
        return dictionary
    }
}

public extension Data {
    func mapResponse<NewSuccess>(_ decodableType: NewSuccess.Type) throws -> NewSuccess where NewSuccess: Decodable {
        do {
            let baseResponse = try JSONDecoder().decode(NewSuccess.self, from: self)
            
            return baseResponse
        } catch {
            print(error)
            throw APIError.parsingError
        }
    }
}

public extension Error {
    var validationError: CustomValidationError? {
        if let afError = self.asAFError, case AFError.responseValidationFailed(let reason) = afError {
            if case AFError.ResponseValidationFailureReason.customValidationFailed(let error) = reason {
                return error as? CustomValidationError
            }
        }
        return nil
    }
}

// Mark - For testing and SwiftUI preview
#if DEBUG
public extension API {
    static let mock: API = .init(session: Alamofire.Session.default, config: ConfigMock())
}
#endif
