//
//  UploadBodyEncoding.swift
//  Core
//
//  Created by  Stepanok Ivan on 29.11.2022.
//

import Foundation
import Alamofire

public struct UploadBodyEncoding: ParameterEncoding {
    
    private var body: Data
    
    public init(body: Data) {
        self.body = body
    }
    
    public func encode(
        _ urlRequest: Alamofire.URLRequestConvertible,
        with parameters: Alamofire.Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let url = urlRequest.url else {
            throw AFError.parameterEncodingFailed(reason: .missingURL)
        }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "")
            urlComponents.percentEncodedQuery = percentEncodedQuery
            urlRequest.url = urlComponents.url
        }
        
        if urlRequest.headers["Content-Type"] == nil {
            urlRequest.headers.update(.contentType("image/jpeg"))
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
    
}
