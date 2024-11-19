//
//  OfflineProgress.swift
//  Core
//
//  Created by  Stepanok Ivan on 20.06.2024.
//

import Foundation

public struct OfflineProgress: Sendable {
    public let blockID: String
    public let data: String
    public let courseID: String
    public let progressJson: String
    
    public init(progressJson: String) {
        self.progressJson = progressJson
        if let jsonData = progressJson.data(using: .utf8) {
            if let jsonObject = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                if let url = jsonObject["url"] as? String,
                   let data = jsonObject["data"] as? String {
                    self.blockID = extractBlockID(from: url)
                    self.data = data
                    self.courseID = extractCourseID(from: url)
                    return
                }
            }
        }
        // Default values if parsing fails
        self.blockID = ""
        self.data = ""
        self.courseID = ""
        
        func extractBlockID(from url: String) -> String {
            if let range = url.range(of: "xblock/")?.upperBound,
               let endRange = url.range(of: "/handler", range: range..<url.endIndex)?.lowerBound {
                return String(url[range..<endRange])
            }
            return ""
        }
        
        func extractCourseID(from url: String) -> String {
            if let range = url.range(of: "courses/")?.upperBound,
               let endRange = url.range(of: "/xblock", range: range..<url.endIndex)?.lowerBound {
                return String(url[range..<endRange])
            }
            return ""
        }
    }
}
