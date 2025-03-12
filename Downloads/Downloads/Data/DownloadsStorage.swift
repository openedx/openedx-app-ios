//
//  DownloadsStorage.swift
//  Downloads
//
//  Created by Ivan Stepanok on 05.03.2025.
//

import Foundation
import Core

public protocol DownloadsStorage: Sendable {
    var allowedDownloadLargeFile: Bool? { get set }
    var userSettings: UserSettings? { get set }
}

#if DEBUG
public final class DownloadsStorageMock: DownloadsStorage, @unchecked Sendable {
    
    public var userSettings: UserSettings?

    public var allowedDownloadLargeFile: Bool?

    public init() {}
}
#endif
