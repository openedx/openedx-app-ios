//
//  DebugLog.swift
//  Core
//
//  Created by Eugene Yatsenko on 10.10.2023.
//

import Foundation

public func debugLog(
    _ item: Any...,
    filename: String = #file,
    line: Int = #line,
    funcname: String = #function
) {
#if DEBUG
    print(
        """
        🕗 \(Date())
        📄 \(filename.components(separatedBy: "/").last ?? "") \(line) \(funcname)
        ℹ️ \(item)
        """
    )
#endif
}
