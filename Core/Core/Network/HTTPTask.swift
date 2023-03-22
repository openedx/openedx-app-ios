//
//  HTTPTask.swift
//  Core
//
//  Created by Vladimir Chekyrta on 13.09.2022.
//

import Foundation
import Alamofire

public enum HTTPTask {
    case request
    case requestCookies
    case requestParameters(parameters: Parameters? = nil, encoding: ParameterEncoding)
    case requestCodable(parameters: Encodable? = nil, encoding: ParameterEncoding)
    case upload(Data)
}
