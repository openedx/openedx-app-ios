//
//  LessonProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 30.05.2023.
//

import SwiftUI
import Core
import Theme

struct LessonProgressView: View {
    @ObservedObject var viewModel: CourseUnitViewModel
    
    @Environment(\.isHorizontal) private var isHorizontal
    @EnvironmentObject var themeManager: ThemeManager
    
    init(viewModel: CourseUnitViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Spacer()
                let childs = viewModel.verticals[viewModel.verticalIndex].childs
                ForEach(Array(childs.enumerated()), id: \.offset) { index, _ in
                    let selected = viewModel.verticals[viewModel.verticalIndex].childs[index]
                    Circle()
                        .frame(
                            width: selected == viewModel.selectedLesson() ? 5 : 3,
                            height: selected == viewModel.selectedLesson() ? 5 : 3
                        )
                        .foregroundColor(
                            selected == viewModel.selectedLesson()
                            ? .accentColor
                            : themeManager.theme.colors.textSecondary
                        )
                }
                Spacer()
            }
            .padding(.trailing, isHorizontal ? 0 : 6)
        }
    }
}
