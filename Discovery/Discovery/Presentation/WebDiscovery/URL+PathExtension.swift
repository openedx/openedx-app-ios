//
//  URL+PathExtension.swift
//  Discovery
//
//  Created by SaeedBashir on 12/18/23.
//

import Foundation

public extension URL {
    var appURLHost: String {
        return host ?? ""
    }
    
    var isValidAppURLScheme: Bool {
        return scheme ?? "" == URIString.appURLScheme.rawValue
    }
    
    var queryParameters: [String: Any]? {
        guard let queryString = query else {
            return nil
        }
        var queryParameters = [String: Any]()
        let parameters = queryString.components(separatedBy: "&")
        for parameter in parameters {
            let keyValuePair = parameter.components(separatedBy: "=")
            // Parameter will be ignored if invalid data for keyValuePair
            if keyValuePair.count == 2 {
                let key = keyValuePair[0]
                let value = keyValuePair[1]
                queryParameters[key] = value
            }
        }
        return queryParameters
    }
}
