//
//  TopicsResponse.swift
//  Discussion
//
//  Created by  Stepanok Ivan on 12.10.2022.
//

import Foundation
import Core

// MARK: - Topics
extension DataLayer {
    public struct TopicsResponse: Codable {
        public let coursewareTopics: [CoursewareTopic]
        public let nonCoursewareTopics: [CoursewareTopic]

        enum CodingKeys: String, CodingKey {
            case coursewareTopics = "courseware_topics"
            case nonCoursewareTopics = "non_courseware_topics"
        }
    }

    // MARK: - CoursewareTopic
    public struct CoursewareTopic: Codable {
        public let id: String?
        public let name: String?
        public let threadListURL: String?
        public let children: [CoursewareTopic]

        enum CodingKeys: String, CodingKey {
            case id
            case name
            case threadListURL = "thread_list_url"
            case children
        }
    }
}

extension DataLayer.CoursewareTopic {
    var domain: CoursewareTopics {
        CoursewareTopics(
            id: id ?? "",
            name: name ?? "",
            threadListURL: name ?? "",
            children: children.map {
                CoursewareTopics(
                    id: $0.id ?? "",
                    name: $0.name ?? "",
                    threadListURL: $0.name ?? "",
                    children: []
                )
            })
    }
}

extension DataLayer.TopicsResponse {
    var domain: Topics {
        let coursewareTopics = coursewareTopics.map {
            CoursewareTopics(
                id: $0.id ?? "",
                name: $0.name ?? "",
                threadListURL: $0.name ?? "",
                children: $0.children.map {
                    CoursewareTopics(
                        id: $0.id ?? "",
                        name: $0.name ?? "",
                        threadListURL: $0.name ?? "",
                        children: [])
                })
        }
        
        let nonCoursewareTopics = nonCoursewareTopics.map {
            CoursewareTopics(
                id: $0.id ?? "",
                name: $0.name ?? "",
                threadListURL: $0.name ?? "",
                children: $0.children.map {
                    CoursewareTopics(
                        id: $0.id ?? "",
                        name: $0.name ?? "",
                        threadListURL: $0.name ?? "",
                        children: []
                    )
                })
        }
        
        return Topics(coursewareTopics: coursewareTopics, nonCoursewareTopics: nonCoursewareTopics)
    }
}
