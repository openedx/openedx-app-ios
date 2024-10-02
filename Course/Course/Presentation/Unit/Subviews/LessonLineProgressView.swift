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

    @Environment(\.isHorizontal) private var isHorizontal

    init(viewModel: CourseUnitViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.Colors.background
            HStack(spacing: 8) {
                let vertical = viewModel.verticals[viewModel.verticalIndex]
                let data = Array(vertical.childs.enumerated())
                ForEach(data, id: \.offset) { index, item in
                    let selected = viewModel.verticals[viewModel.verticalIndex].childs[index]
                    let isSelected = selected == viewModel.selectedLesson()
                    let isDone = item.completion == 1.0 || vertical.completion == 1.0
                    if  isSelected && isDone {
                        Theme.Colors.progressSelectedAndDone
                            .frame(height: 7)
                    } else if isSelected {
                        Theme.Colors.onProgress
                            .frame(height: 7)
                    } else if isDone {
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
