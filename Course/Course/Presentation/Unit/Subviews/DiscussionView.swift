//
//  DiscussionView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Discussion
import Swinject

struct DiscussionView: View {
    let blockID: String
    let title: String
    let viewModel: CourseUnitViewModel

    var body: some View {
        let id = "course-v1:" + (viewModel.lessonID.find(from: "block-v1:", to: "+type").first ?? "")
        PostsView(
            courseID: id,
            currentBlockID: blockID,
            topics: Topics(coursewareTopics: [], nonCoursewareTopics: []),
            title: title,
            type: .courseTopics(topicID: blockID),
            viewModel: Container.shared.resolve(PostsViewModel.self)!,
            router: Container.shared.resolve(DiscussionRouter.self)!,
            showTopMenu: false
        )
        .onAppear {
            Task {
                await viewModel.blockCompletionRequest(blockID: blockID)
            }
        }
    }
}
