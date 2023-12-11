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
        ZStack(alignment: .bottom) {
            Theme.Colors.background
            HStack(spacing: 3) {
                let data = Array(viewModel.verticals[viewModel.verticalIndex].childs.enumerated())
                ForEach(data, id: \.offset) { index, item in
                    let selected = viewModel.verticals[viewModel.verticalIndex].childs[index]
                    if selected == viewModel.selectedLesson() {
                        Theme.Colors.onProgress
                    } else if item.completion == 1.0 {
                        Theme.Colors.progressDone
                    } else {
                        Theme.Colors.progressSkip
                    }
                }
            }.frame(height: 5)
        }
        .frame(height: 10)
    }
}
