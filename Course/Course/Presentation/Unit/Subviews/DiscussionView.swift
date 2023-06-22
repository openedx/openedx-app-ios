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
    let id: String
    let blockID: String
    let blockKey: String
    let title: String
    let viewModel: CourseUnitViewModel

    var body: some View {
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
                await viewModel.blockCompletionRequest(blockID: blockKey)
            }
        }
    }
}
