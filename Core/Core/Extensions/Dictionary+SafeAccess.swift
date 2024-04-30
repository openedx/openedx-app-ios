//
//  Dictionary+SafeAccess.swift
//  Core
//
//  Created by Saeed Bashir on 4/24/24.
//

import Foundation

public extension Dictionary {
    /// Same as NSMutableDictionary.setObjectOrNil:forKey:, but for
    /// Swift dictionaries
    mutating func setObjectOrNil(_ object: Value?, forKey: Key) {
        if let obj = object {
            self[forKey] = obj
        }
    }
    
    /// Same as NSMutableDictionary.setSafeObject:forKey:, but for
    /// Swift dictionaries
    mutating func setSafeObject(_ object: Value?, forKey: Key) {
        setObjectOrNil(object, forKey: forKey)
        if object == nil {
            #if DEBUG
                assert(false, "Expecting object for key: \(forKey)");
            #else
                Logger.logError("FOUNDATION", "Expecting object for key: \(forKey)");
            #endif
        }
    }
}
