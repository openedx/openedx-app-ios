//
//  SegmentConfig.swift
//  Core
//
//  Created by Anton Yarmolenka on 02/02/2024.
//

import Foundation
import OEXFoundation

private enum SegmentKeys: String, RawStringExtractable {
    case enabled = "ENABLED"
    case writeKey = "SEGMENT_IO_WRITE_KEY"
}

public final class SegmentConfig: NSObject {
    public var enabled: Bool = false
    public var writeKey: String = ""
    
    init(dictionary: [String: AnyObject]) {
        super.init()
        writeKey = dictionary[SegmentKeys.writeKey] as? String ?? ""
        enabled = dictionary[SegmentKeys.enabled] as? Bool == true && !writeKey.isEmpty
    }
}

private let segmentKey = "SEGMENT_IO"
extension Config {
    public var segment: SegmentConfig {
        SegmentConfig(dictionary: self[segmentKey] as? [String: AnyObject] ?? [:])
    }
}
