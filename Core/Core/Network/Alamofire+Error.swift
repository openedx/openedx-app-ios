//
//  Alamofire+Error.swift
//  Core
//
//  Created by Vladimir Chekyrta on 14.09.2022.
//

import Alamofire
import Foundation

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
}
