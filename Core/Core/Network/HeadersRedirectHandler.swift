//
//  HeadersRedirectHandler.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Foundation
import Alamofire

public class HeadersRedirectHandler: RedirectHandler {
    
    public init() {
    }
    
    public func task(
        _ task: URLSessionTask,
        willBeRedirectedTo request: URLRequest,
        for response: HTTPURLResponse,
        completion: @escaping (URLRequest?) -> Void
    ) {
        var redirectedRequest = request
        
        if let originalRequest = task.originalRequest,
           let headers = originalRequest.allHTTPHeaderFields {
            for (key, value) in headers {
                redirectedRequest.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        completion(redirectedRequest)
    }
}
