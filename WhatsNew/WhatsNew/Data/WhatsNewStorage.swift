//
//  WhatsNewStorage.swift
//  WhatsNew
//
//  Created by  Stepanok Ivan on 25.10.2023.
//

import Foundation

public protocol WhatsNewStorage {
    var whatsNewVersion: String? {get set}
}

#if DEBUG
public class WhatsNewStorageMock: WhatsNewStorage {
  
    public var whatsNewVersion: String?
    
    public init() {}
}
#endif
