//
//  WhatsNewStorage.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 25.10.2023.
//

import Foundation

public protocol WhatsNewStorage: Sendable {
    var whatsNewVersion: String? {get set}
}

#if DEBUG
public final class WhatsNewStorageMock: WhatsNewStorage, @unchecked Sendable {
  
    public var whatsNewVersion: String?
    
    public init() {}
}
#endif
