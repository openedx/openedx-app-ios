//
//  ResultExtension.swift
//  Core
//
//  Created by Eugene Yatsenko on 11.10.2023.
//

import Foundation

extension Result {
    @discardableResult
    public func success(_ handler: (Success) -> Void) -> Self {
        guard case let .success(value) = self else { return self }
        handler(value)
        return self
    }
    @discardableResult
    public func failure(_ handler: (Failure) -> Void) -> Self {
        guard case let .failure(error) = self else { return self }
        handler(error)
        return self
    }
}
