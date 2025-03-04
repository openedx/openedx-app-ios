//
//  CourseStructureProtocol.swift
//  Downloads
//
//  Created by Ivan Stepanok on 03.03.2025.
//

import Foundation

//sourcery: AutoMockable
public protocol CourseStructureManagerProtocol: Sendable {
    func getCourseBlocks(courseID: String) async throws -> CourseStructure
    func getLoadedCourseBlocks(courseID: String) async throws -> CourseStructure
}

#if DEBUG
public actor CourseStructureManagerMock: CourseStructureManagerProtocol {
    public init() {}
    public func getCourseBlocks(courseID: String) async throws -> CourseStructure {
        CourseStructure(
            id: "123",
            graded: true,
            completion: 1,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "Course 1",
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "org",
            isSelfPaced: false,
            courseProgress: nil
        )
    }
    
    public func getLoadedCourseBlocks(courseID: String) async throws -> CourseStructure {
        CourseStructure(
            id: "123",
            graded: true,
            completion: 1,
            viewYouTubeUrl: "",
            encodedVideo: "",
            displayName: "Course 1",
            childs: [],
            media: CourseMedia(
                image: CourseImage(
                    raw: "",
                    small: "",
                    large: ""
                )
            ),
            certificate: nil,
            org: "org",
            isSelfPaced: false,
            courseProgress: nil
        )
    }
}
#endif
