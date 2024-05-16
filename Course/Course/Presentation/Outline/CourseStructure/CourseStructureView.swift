//
//  CourseStructureView.swift
//  Course
//
//  Created by Eugene Yatsenko on 15.12.2023.
//

import SwiftUI
import Core
import Theme

struct CourseStructureView: View {

    private let proxy: GeometryProxy
    private let course: CourseStructure
    private let viewModel: CourseContainerViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    init(proxy: GeometryProxy, course: CourseStructure, viewModel: CourseContainerViewModel) {
        self.proxy = proxy
        self.course = course
        self.viewModel = viewModel
    }

    var body: some View {
        let chapters = course.childs
        ForEach(chapters, id: \.id) { chapter in
            let chapterIndex = chapters.firstIndex(where: { $0.id == chapter.id })
            Text(chapter.displayName)
                .font(Theme.Fonts.titleMedium)
                .multilineTextAlignment(.leading)
                .foregroundColor(Theme.Colors.textSecondary)
                .padding(.horizontal, 24)
                .padding(.top, 40)
            ForEach(chapter.childs, id: \.id) { child in
                let sequentialIndex = chapter.childs.firstIndex(where: { $0.id == child.id })
                VStack(alignment: .leading) {
                    HStack {
                        Button {
                            if let chapterIndex, let sequentialIndex {
                                viewModel.trackSequentialClicked(child)
                                viewModel.router.showCourseVerticalView(
                                    courseID: viewModel.courseStructure?.id ?? "",
                                    courseName: viewModel.courseStructure?.displayName ?? "",
                                    title: child.displayName,
                                    chapters: chapters,
                                    chapterIndex: chapterIndex,
                                    sequentialIndex: sequentialIndex
                                )
                            }
                        } label: {
                            Group {
                                if child.completion == 1 {
                                    CoreAssets.finished.swiftUIImage
                                        .renderingMode(.template)
                                        .foregroundColor(Theme.Colors.accentXColor)
                                } else {
                                    child.type.image
                                }
                                Text(child.displayName)
                                    .font(Theme.Fonts.titleMedium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .frame(
                                        maxWidth: idiom == .pad
                                        ? proxy.size.width * 0.5
                                        : proxy.size.width * 0.6,
                                        alignment: .leading
                                    )
                            }
                            .foregroundColor(Theme.Colors.textPrimary)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(child.displayName)
                        Spacer()
                        if let state = viewModel.sequentialsDownloadState[child.id] {
                            switch state {
                            case .available:
                                DownloadAvailableView()
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.download)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.onDownloadViewTap(
                                                chapter: chapter,
                                                blockId: child.id,
                                                state: state
                                            )
                                        }
                                    }
                            case .downloading:
                                DownloadProgressView()
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                                    .onTapGesture {
                                        Task {
                                            await viewModel.onDownloadViewTap(
                                                chapter: chapter,
                                                blockId: child.id,
                                                state: state
                                            )
                                        }
                                    }
                            case .finished:
                                DownloadFinishedView()
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.deleteDownload)
                                    .onTapGesture {
                                        Task {
                                           await viewModel.onDownloadViewTap(
                                                chapter: chapter,
                                                blockId: child.id,
                                                state: state
                                            )
                                        }
                                    }
                            }
                        }
                        Image(systemName: "chevron.right")
                            .flipsForRightToLeftLayoutDirection(true)
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .padding(.horizontal, 36)
                    .padding(.vertical, 20)
                    if chapterIndex != chapters.count - 1 {
                        Divider()
                            .frame(height: 1)
                            .overlay(Theme.Colors.cardViewStroke)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
    }
}
