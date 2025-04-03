//
//  DownloadCoursePreview.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation

public struct DownloadCoursePreview: Sendable, Identifiable {
    public let id: String
    public let name: String
    public let image: String?
    public var totalSize: Int64
    
    public init(
        id: String,
        name: String,
        image: String?,
        totalSize: Int64
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.totalSize = totalSize
    }
    
    public var formattedSize: String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useAll]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: totalSize)
    }
}
