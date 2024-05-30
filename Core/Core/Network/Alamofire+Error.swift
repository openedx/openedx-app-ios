//
//  Alamofire+Error.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Alamofire

public extension Error {
    var isUpdateRequeiredError: Bool {
        self.asAFError?.responseCode == 426
    }
    
    var isInternetError: Bool {
        guard let afError = self.asAFError,
              let urlError = afError.underlyingError as? URLError else {
            return false
        }
        switch urlError.code {
        case .timedOut, .cannotConnectToHost, .networkConnectionLost,
                .notConnectedToInternet, .resourceUnavailable, .internationalRoamingOff,
                .dataNotAllowed:
            return true
        default:
            return false
        }
    }
    
    var errorCode: Int {
        guard let afError = self.asAFError else {
            return (self as NSError).code
        }
        
        if let validationError = afError.validationError {
            return validationError.statusCode
        }
        
        if let code = afError.responseCode {
            return code
        }
        
        return (self as NSError).code
    }
    
    var errorMessage: String {
        guard let afError = self.asAFError else {
            return (self as NSError).localizedDescription
        }
        
        if let validationError = afError.validationError,
           let data = validationError.data,
        let error = data["error"] as? String {
            return error
        }
        
        return afError.localizedDescription
    }
}
