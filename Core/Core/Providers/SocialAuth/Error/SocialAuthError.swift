//
//  CustomError.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation

public enum SocialAuthError: Error {
    case error(text: String)
    case socialAuthCanceled
    case unknownError
}

extension SocialAuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error(let text):
            return text
        case .socialAuthCanceled:
            return CoreLocalization.socialSignCanceled
        case .unknownError:
            return CoreLocalization.Error.unknownError
        }
    }
}
