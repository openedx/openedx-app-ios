//
//  Dictionary+SafeAccessTests.swift
//  CoreTests
//
//  Created by Saeed Bashir on 4/24/24.
//

import Foundation
import XCTest
import Core

class DictionaryExtensionTestCase: XCTestCase {
    
    func testSetObjectOrNil() {
        var dict: [String: Int] = [:]
        
        let key1: String = "test1"
        let obj1: Int? = 1
        dict.setObjectOrNil(obj1, forKey: key1)
        XCTAssertEqual(dict[key1], obj1)
        
        let key2: String = "test2"
        let obj2: Int? = nil
        dict.setObjectOrNil(obj2, forKey: key2)
        XCTAssertFalse(dict.keys.contains(key2))
    }
    
    func testSetSafeObject() {
        var dict: [String: Int] = [:]
        
        let key: String = "test"
        let obj: Int? = 1
        dict.setSafeObject(obj, forKey: key)
        XCTAssertEqual(dict[key], 1)
    }
}
