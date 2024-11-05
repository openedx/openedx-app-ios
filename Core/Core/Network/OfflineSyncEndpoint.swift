//
//  OfflineSyncEndpoint.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation
import Alamofire
import OEXFoundation

enum OfflineSyncEndpoint: EndPointType {
    case submitOfflineProgress(courseID: String, blockID: String, data: String)
   
    var path: String {
        switch self {
        case let .submitOfflineProgress(courseID, blockID, _):
            return "/courses/\(courseID)/xblock/\(blockID)/handler/xmodule_handler/problem_check"
        }
    }

    var httpMethod: HTTPMethod {
        switch self {
        case .submitOfflineProgress:
            return .post
        }
    }

    var headers: HTTPHeaders? {
        nil
    }

    var task: HTTPTask {
        switch self {
        case let .submitOfflineProgress(_, _, data):
            return .requestParameters(parameters: decode(query: data), encoding: URLEncoding.httpBody)
        }
    }
    
    func decode(query: String) -> Parameters {
        var parameters: Parameters = [:]
        
        let pairs = query.split(separator: "&")
        for pair in pairs {
            let keyValue = pair.split(separator: "=")
            if keyValue.count == 2 {
                let key = String(keyValue[0]).removingPercentEncoding!
                let value = String(keyValue[1]).removingPercentEncoding!
                
                if key.hasSuffix("[]") {
                    let trimmedKey = String(key.dropLast(2))
                    if parameters[trimmedKey] == nil {
                        parameters[trimmedKey] = [value]
                    } else if var existingArray = parameters[trimmedKey] as? [String] {
                        existingArray.append(value)
                        parameters[trimmedKey] = existingArray
                    }
                } else {
                    parameters[key] = value
                }
            }
        }
        return parameters
    }
}
