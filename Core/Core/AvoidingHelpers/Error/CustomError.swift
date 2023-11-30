//
//  CustomError.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation

public enum CustomError: Error {
    case error(text: String)
    case socialSignCanceled
    case unknownError
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error(let text):
            return text
        case .socialSignCanceled:
            return CoreLocalization.socialSignCanceled
        case .unknownError:
            return CoreLocalization.Error.unknownError
        }
    }
}
