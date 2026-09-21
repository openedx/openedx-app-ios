//
//  InstanceProvider+CurrentKey.swift
//  Core
//
//  Created by Rawan Matar on 17/09/2026.
//

import Foundation

extension InstanceProvider {
    /// The current instance's key, or "default" when none is selected.
    public var currentInstanceKey: String {
        currentInstance?.key ?? "default"
    }
}
