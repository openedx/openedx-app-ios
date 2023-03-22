//
//  Discovery.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation

public struct Discovery: Hashable {
    public let name: String
    public let org: String
    public let shortDescription: String
    public let media: CourseMedia
    
    public init(name: String, org: String, shortDescription: String, media: CourseMedia) {
        self.name = name
        self.org = org
        self.shortDescription = shortDescription
        self.media = media
    }
}

public struct CourseMedia: Hashable {
    public let banner: BannerImage
    public let courseImage: CourseImage
    public let courseVideo: CourseVideo
    public let image: Image
    
    public init(banner: BannerImage, courseImage: CourseImage, courseVideo: CourseVideo, image: Image) {
        self.banner = banner
        self.courseImage = courseImage
        self.courseVideo = courseVideo
        self.image = image
    }
}

public struct Image: Hashable {
    public let raw: String
    public let small: String
    public let large: String
    
    public init(raw: String, small: String, large: String) {
        self.raw = raw
        self.small = small
        self.large = large
    }
}

public struct CourseImage: Hashable {
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}

public struct CourseVideo: Hashable {
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}

public struct BannerImage: Hashable {
    public let url: String
    
    public init(url: String) {
        self.url = url
    }
}
