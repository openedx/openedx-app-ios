//
//  CourseStorage.swift
//  Course
//
//  Created by Eugene Yatsenko on 28.12.2023.
//

import Foundation
import Core

public protocol CourseStorage {
    var allowedDownloadLargeFile: Bool? { get set }
}

#if DEBUG
public class CourseStorageMock: CourseStorage {

    public var allowedDownloadLargeFile: Bool?

    public init() {}
}
#endif
