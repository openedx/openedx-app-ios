//
//  Data_Media.swift
//  Core
//
//  Created by Vladimir Chekyrta on 12.10.2022.
//

import Foundation

public extension DataLayer {
    
    // MARK: - CourseMedia
    struct CourseMedia: Decodable, Sendable, Equatable {
        public static func == (lhs: DataLayer.CourseMedia, rhs: DataLayer.CourseMedia) -> Bool {
            lhs.image == rhs.image
        }

        public let image: DataLayer.Image
        
        public init(image: DataLayer.Image) {
            self.image = image
        }
    }
    
    // MARK: - Media
    struct Media: Codable {
        public let bannerImage: DataLayer.BannerImage?
        public let courseImage: DataLayer.CourseUrl?
        public let courseVideo: DataLayer.CourseUrl?
        public let image: DataLayer.Image?
        
        enum CodingKeys: String, CodingKey {
            case bannerImage = "banner_image"
            case courseImage = "course_image"
            case courseVideo = "course_video"
            case image = "image"
        }
    }
}

public extension DataLayer.CourseMedia {
    var domain: CourseMedia {
        CourseMedia(
            image: CourseImage(
                raw: image.raw,
                small: image.small,
                large: image.large
            )
        )
    }
}

public extension DataLayer {
    // MARK: - BannerImage
    struct BannerImage: Codable {
        public let url: String?
        public let uriAbsolute: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "uri"
            case uriAbsolute = "uri_absolute"
        }
    }
}

public extension DataLayer {
    // MARK: - Course
    struct CourseUrl: Codable {
        public let url: String?
        
        enum CodingKeys: String, CodingKey {
            case url = "uri"
        }
        
    }
}

public extension DataLayer {
    // MARK: - Image
    struct Image: Codable, Sendable, Equatable {
        public let raw: String
        public let small: String
        public let large: String
        
        enum CodingKeys: String, CodingKey {
            case raw
            case small
            case large
        }
        
        public init(raw: String, small: String, large: String) {
            self.raw = raw
            self.small = small
            self.large = large
        }
    }
}
