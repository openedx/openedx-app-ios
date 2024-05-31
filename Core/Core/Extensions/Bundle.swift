//
//  Bundle.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.05.2024.
//

import Foundation

public extension Bundle {
    var applicationName: String? {
        object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
            object(forInfoDictionaryKey: "CFBundleName") as? String
    }
}
