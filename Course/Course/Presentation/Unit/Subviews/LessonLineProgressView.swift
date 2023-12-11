//
//  LessonLineProgressView.swift
//  Course
//
//  Created by Eugene Yatsenko on 11.12.2023.
//

import SwiftUI
import Theme

struct LessonLineProgressView: View {
    @ObservedObject var viewModel: CourseUnitViewModel

    @Environment (\.isHorizontal) private var isHorizontal

    init(viewModel: CourseUnitViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack {
            Theme.Colors.background
            HStack(spacing: 3) {
                let data = Array(viewModel.verticals[viewModel.verticalIndex].childs.enumerated())
                ForEach(data, id: \.offset) { index, _ in
                    let selected = viewModel.verticals[viewModel.verticalIndex].childs[index]
                    if selected == viewModel.selectedLesson() {
                        Color(.yellow)
                    } else {
                        Color(.lightGray)
                    }
                }
            }
        }
        .frame(height: 5)
    }
}
