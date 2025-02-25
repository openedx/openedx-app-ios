//
//  CourseDemoModel.swift
//  Downloads
//
//  Created by Ivan Stepanok on 22.02.2025.
//

import SwiftUI

struct CourseDemoModel: Identifiable {
    let id = UUID()
    let course_id: String
    let course_name: String
    let course_banner: String
    let total_size: Int
}
