//
//  CourseStorage.swift
//  Course
//
//  Created by Eugene Yatsenko on 28.12.2023.
//

import Foundation
import Core

public protocol CourseStorage: Sendable {
    var allowedDownloadLargeFile: Bool? { get set }
    var userSettings: UserSettings? { get set }
}

#if DEBUG
public final class CourseStorageMock: CourseStorage, @unchecked Sendable {
    
    public var userSettings: UserSettings?

    public var allowedDownloadLargeFile: Bool?

    public init() {}
}
#endif
