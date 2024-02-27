//
//  BranchConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 24/01/2024.
//

import Foundation

private enum BranchKeys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case key = "KEY"
}

public final class BranchConfig: NSObject {
    public var enabled: Bool = false
    public var key: String?
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        key = dictionary[BranchKeys.key] as? String
        enabled = dictionary[BranchKeys.enabled] as? Bool ?? false && key?.isEmpty == false
        
    }
}

private let branchKey = "BRANCH"
extension Config {
    public var branch: BranchConfig {
        BranchConfig(dictionary: self[branchKey] as? [String: AnyObject] ?? [:])
    }
}
