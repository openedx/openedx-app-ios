//
//  JSONBodyEncoding.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation
import Alamofire

public struct JSONBodyEncoding: ParameterEncoding {
    
    private var body: Data
    
    public init(body: Data) {
        self.body = body
    }
    
    public func encode(
        _ urlRequest: Alamofire.URLRequestConvertible,
        with parameters: Alamofire.Parameters?
    ) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        if urlRequest.headers["Content-Type"] == nil {
            urlRequest.headers.update(.contentType("application/json"))
        }
        
        urlRequest.httpBody = body
        
        return urlRequest
    }
}
