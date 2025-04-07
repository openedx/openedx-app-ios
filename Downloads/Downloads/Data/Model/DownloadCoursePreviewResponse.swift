//
//  DownloadCoursePreviewResponse.swift
//  Downloads
//
//  Created by Ivan Stepanok on 25.02.2025.
//

import Foundation
import Core

public extension DataLayer {
    // MARK: - DownloadCoursePreviewResponse
    struct DownloadCoursePreviewResponse: Codable {
        public let id: String
        public let name: String?
        public let image: String?
        public let totalSize: Int64?
        
        enum CodingKeys: String, CodingKey {
            case id = "course_id"
            case name = "course_name"
            case image = "course_image"
            case totalSize = "total_size"
        }
    }
}

public extension DataLayer.DownloadCoursePreviewResponse {
    func domain(baseURL: String) -> DownloadCoursePreview {
        return DownloadCoursePreview(
            id: id,
            name: name ?? "",
            image: baseURL + (image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""),
            totalSize: totalSize ?? 0
        )
    }
}
