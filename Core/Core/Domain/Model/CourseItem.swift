//
//  Discovery.swift
//  Core
//
//  Created by  Stepanok Ivan on 16.09.2022.
//

import Foundation

public struct CourseItem: Hashable {
    public let name: String
    public let org: String
    public let shortDescription: String
    public let imageURL: String
    public let hasAccess: Bool
    public let courseStart: Date?
    public let courseEnd: Date?
    public let enrollmentStart: Date?
    public let enrollmentEnd: Date?
    public let courseID: String
    public let numPages: Int
    public let coursesCount: Int
    public let sku: String
    public let dynamicUpgradeDeadline: Date?
    public let mode: DataLayer.Mode
    public let isSelfPaced: Bool?
    public let courseRawImage: String?
    public let coursewareAccess: CoursewareAccess?
    public let progressEarned: Int
    public let progressPossible: Int
    
    public init(name: String,
                org: String,
                shortDescription: String,
                imageURL: String,
                hasAccess: Bool,
                courseStart: Date?,
                courseEnd: Date?,
                enrollmentStart: Date?,
                enrollmentEnd: Date?,
                courseID: String,
                numPages: Int,
                coursesCount: Int,
                sku: String = "",
                dynamicUpgradeDeadline: Date? = nil,
                mode: DataLayer.Mode = .audit,
                isSelfPaced: Bool?,
                courseRawImage: String?,
                coursewareAccess: CoursewareAccess?,
                progressEarned: Int,
                progressPossible: Int
    ) {
        self.name = name
        self.org = org
        self.shortDescription = shortDescription
        self.imageURL = imageURL
        self.hasAccess = hasAccess
        self.courseStart = courseStart
        self.courseEnd = courseEnd
        self.enrollmentStart = enrollmentStart
        self.enrollmentEnd = enrollmentEnd
        self.courseID = courseID
        self.numPages = numPages
        self.coursesCount = coursesCount
        self.sku = sku
        self.dynamicUpgradeDeadline = dynamicUpgradeDeadline
        self.mode = mode
        self.isSelfPaced = isSelfPaced
        self.courseRawImage = courseRawImage
        self.coursewareAccess = coursewareAccess
        self.progressEarned = progressEarned
        self.progressPossible = progressPossible
    }
}

extension CourseItem {
    public var isUpgradeable: Bool {
        guard let upgradeDeadline = dynamicUpgradeDeadline, mode == .audit else {
            return false
        }
        return !upgradeDeadline.isInPast()
        && !sku.isEmpty
        && courseStart?.isInPast() ?? false
    }
}
