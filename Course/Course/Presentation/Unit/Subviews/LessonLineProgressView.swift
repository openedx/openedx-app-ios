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
    @EnvironmentObject var themeManager: ThemeManager
    
    init(viewModel: CourseUnitViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            themeManager.theme.colors.background
            HStack(spacing: 8) {
                let vertical = viewModel.verticals[viewModel.verticalIndex]
                let data = Array(vertical.childs.enumerated())
                ForEach(data, id: \.offset) { index, item in
                    let selected = viewModel.verticals[viewModel.verticalIndex].childs[index]
                    let isSelected = selected == viewModel.selectedLesson()
                    let isDone = item.completion == 1.0 || vertical.completion == 1.0
                    if  isSelected && isDone {
                        themeManager.theme.colors.progressSelectedAndDone
                            .frame(height: 7)
                    } else if isSelected {
                        themeManager.theme.colors.onProgress
                            .frame(height: 7)
                    } else if isDone {
                        themeManager.theme.colors.progressDone
                    } else {
                        themeManager.theme.colors.progressSkip
                    }
                }
            }.frame(height: 5)
        }
        .frame(height: 10)
    }
}
