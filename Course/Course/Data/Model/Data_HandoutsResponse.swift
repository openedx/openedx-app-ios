//
//  Data_HandoutsResponse.swift
//  Course
//
//  Created by  Stepanok Ivan on 27.02.2023.
//

import Foundation
import Core

public extension DataLayer {
    struct HandoutsResponse: Codable {
        let handoutsHtml: String?
        
        public enum CodingKeys: String, CodingKey {
            case handoutsHtml = "handouts_html"
        }
    }
}
