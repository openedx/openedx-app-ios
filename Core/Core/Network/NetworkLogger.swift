//
//  NetworkLogger.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Alamofire
import Foundation

public class NetworkLogger: EventMonitor {
    
    public let queue = DispatchQueue(label: "com.raccoongang.networklogger")
    
    public init() {
    }
    
    public func requestDidResume(_ request: Request) {
        print("Request:", request.description)
        if let headers = request.request?.headers {
            print("Headers:")
            print(headers)
            print("------")
        }
        if let body = request.request?.httpBody, let value = String(data: body, encoding: .utf8) {
            print("Body:")
            print(value)
            print("------")
        }
    }
    
    public func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        guard let data = response.data else {
            return
        }
        guard let responseValue = String(data: data, encoding: .utf8) else {
            return
        }
        print("Response:", request.description)
        print(responseValue)
        
//        if let json = try? JSONSerialization
//            .jsonObject(with: data, options: .mutableContainers) {
//            print(json)
//        }
    }
    
}
