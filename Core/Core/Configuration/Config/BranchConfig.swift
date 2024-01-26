//
//  BranchConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

private enum BranchKeys: String {
    case enabled = "ENABLED"
    case key = "KEY"
}

public final class BranchConfig: NSObject {
    public var enabled: Bool = false
    public var key: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        enabled = dictionary[BranchKeys.enabled.rawValue] as? Bool == true
        key = dictionary[BranchKeys.key.rawValue] as? String
    }
}

private let branchKey = "BRANCH"
extension Config {
    public var branch: BranchConfig {
        BranchConfig(dictionary: self[branchKey] as? [String: AnyObject] ?? [:])
    }
}
