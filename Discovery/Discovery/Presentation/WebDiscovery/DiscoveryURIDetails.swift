//
//  DiscoveryURIDetails.swift
//  Discovery
//
//  Created by SaeedBashir on 12/18/23.
//

import Foundation
import Core

// Define your uri scheme
public enum URIString: String {
    case pathPlaceHolder = "{path_id}"
}

public enum URLParameterKeys: String, RawStringExtractable {
    case pathId = "path_id"
    case courseId = "course_id"
    case emailOptIn = "email_opt_in"
}

// Define your hosts
public enum WebviewActions: String {
    case courseEnrollment = "enroll"
    case courseDetail = "course_info"
    case enrolledCourseDetail = "enrolled_course_info"
    case enrolledProgramDetail = "enrolled_program_info"
    case programDetail = "program_info"
    case courseProgram = "course"
}
