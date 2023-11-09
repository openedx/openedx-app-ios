//
//  CourseStructureView.swift
//  Course
//
//  Created by Eugene Yatsenko on 09.11.2023.
//

import SwiftUI
import Core
import Kingfisher

struct CourseExpandableContentView: View {

    private let proxy: GeometryProxy
    private let course: CourseStructure
    private let viewModel: CourseContainerViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    @State private var isExpandedIds: [String] = []

    init(proxy: GeometryProxy, course: CourseStructure, viewModel: CourseContainerViewModel) {
        self.proxy = proxy
        self.course = course
        self.viewModel = viewModel
    }

    var body: some View {
        content
    }

    private var content: some View {
        ForEach(course.childs, id: \.id) { chapter in
            section(chapter: chapter)
        }
    }

    @ViewBuilder
    private func section(chapter: CourseChapter) -> some View {
        header(chapter: chapter)
        sectionContent(chapter: chapter)
    }

    private func header(chapter: CourseChapter) -> some View {
        Text(chapter.displayName)
            .font(Theme.Fonts.titleMedium)
            .multilineTextAlignment(.leading)
            .foregroundColor(Theme.Colors.textSecondary)
            .padding(.horizontal, 24)
            .padding(.top, 40)
    }

    private func sectionContent(chapter: CourseChapter) -> some View {
        ForEach(Array(chapter.childs.enumerated()), id: \.element.id) { index, courseSequential in
            VStack(alignment: .leading) {
                disclosureGroup(
                    chapter: chapter,
                    courseSequentialIndex: index,
                    courseSequential: courseSequential
                )
                if index != course.childs.count - 1 {
                    Divider()
                        .frame(height: 1)
                        .overlay(Theme.Colors.cardViewStroke)
                        .padding(.horizontal, 24)
                }
            }
        }
    }

    private func disclosureGroup(
        chapter: CourseChapter,
        courseSequentialIndex: Int,
        courseSequential: CourseSequential
    ) -> some View {
        CustomDisclosureGroup(
            animation: .easeInOut(duration: 0.2),
            isExpanded: .constant(isExpandedIds.contains(where: {$0 == chapter.id})),
            onClick: {
                if let index = isExpandedIds.firstIndex(where: {$0 == chapter.id}) {
                    isExpandedIds.remove(at: index)
                } else {
                    isExpandedIds.append(chapter.id)
                }
            },
            header: { isExpanded in
                courseSequentialLabel(
                    courseSequential: courseSequential,
                    chapter: chapter,
                    isExpanded: isExpanded
                )
                .padding(.horizontal, 28)
                .padding(.vertical, 20)
            }
        ) {
            ForEach(
                Array(courseSequential.childs.enumerated()),
                id: \.element.id
            ) { index, courseVertical in
                VStack(spacing: 0) {
                    courseVerticalCell(
                        chapter: chapter,
                        courseSequential: courseSequential,
                        courseVertical: courseVertical,
                        courseVerticalIndex: index
                    )
                }
            }
        }
    }

    @ViewBuilder
    private func courseSequentialLabel(
        courseSequential: CourseSequential,
        chapter: CourseChapter,
        isExpanded: Bool,
        disabledIcon: Bool = false
    ) -> some View {
        HStack {
            Group {
                if courseSequential.completion == 1 {
                    CoreAssets.finished.swiftUIImage
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                } else {
                    courseSequential.type.image
                }
                Text(courseSequential.displayName)
                    .font(Theme.Fonts.titleMedium)
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .frame(
                        maxWidth: idiom == .pad
                        ? proxy.size.width * 0.5
                        : proxy.size.width * 0.6,
                        alignment: .leading
                    )
            }.foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            if let state = viewModel.sequentialsDownloadState[courseSequential.id] {
                switch state {
                case .available:
                    DownloadAvailableView()
                        .onTapGesture {
                            viewModel.onDownloadViewTap(
                                chapter: chapter,
                                blockId: courseSequential.id,
                                state: state
                            )
                        }
                        .onForeground {
                            viewModel.onForeground()
                        }
                case .downloading:
                    DownloadProgressView()
                        .onTapGesture {
                            viewModel.onDownloadViewTap(
                                chapter: chapter,
                                blockId: courseSequential.id,
                                state: state
                            )
                        }
                        .onBackground {
                            viewModel.onBackground()
                        }
                case .finished:
                    DownloadFinishedView()
                        .onTapGesture {
                            viewModel.onDownloadViewTap(
                                chapter: chapter,
                                blockId: courseSequential.id,
                                state: state
                            )
                        }
                }
            }
            if !disabledIcon {
                if isExpanded {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.Colors.accentColor)
                        .rotationEffect(.degrees(90))
                } else {
                    Image(systemName: "chevron.right")
                        .foregroundColor(Theme.Colors.accentColor)
                }
            }
        }
    }

    private func courseVerticalCell(
        chapter: CourseChapter,
        courseSequential: CourseSequential,
        courseVertical: CourseVertical,
        courseVerticalIndex: Int
    ) -> some View {
        Button(action: {
            guard let chapterIndex = course.childs.firstIndex(where: { $0.id == chapter.id }) else {
                return
            }
            guard let sequentialIndex = chapter.childs.firstIndex(where: { $0.id == courseSequential.id }) else {
                return
            }
            guard let block = courseVertical.childs.first else {
                return
            }
            viewModel.trackVerticalClicked(
                courseId: viewModel.courseStructure?.id ?? "",
                courseName: viewModel.courseStructure?.displayName ?? "",
                vertical: courseVertical
            )
            viewModel.router.showCourseUnit(
                courseName: viewModel.courseStructure?.displayName ?? "",
                blockId: block.id,
                courseID: viewModel.courseStructure?.id ?? "",
                sectionName: block.displayName,
                verticalIndex: courseVerticalIndex,
                chapters: course.childs,
                chapterIndex: chapterIndex,
                sequentialIndex: sequentialIndex
            )
        }, label: {
            HStack {
                Group {
                    if courseVertical.completion == 1 {
                        CoreAssets.finished.swiftUIImage
                            .renderingMode(.template)
                            .foregroundColor(.accentColor)
                    } else {
                        verticalImage(childs: courseVertical.childs)
                    }
                    Text(courseVertical.displayName)
                        .font(Theme.Fonts.titleMedium)
                        .lineLimit(1)
                        .frame(maxWidth: idiom == .pad
                               ? proxy.size.width * 0.5
                               : proxy.size.width * 0.6,
                               alignment: .leading)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }.foregroundColor(Theme.Colors.textPrimary)
                Spacer()
                if let state = viewModel.verticalsDownloadState[courseVertical.id] {
                    switch state {
                    case .available:
                        DownloadAvailableView()
                            .onTapGesture {
                                viewModel.onDownloadViewTap(
                                    courseVertical: courseVertical,
                                    state: state
                                )
                            }
                            .onForeground {
                                viewModel.onForeground()
                            }
                    case .downloading:
                        DownloadProgressView()
                            .onTapGesture {
                                viewModel.onDownloadViewTap(
                                    courseVertical: courseVertical,
                                    state: state
                                )
                            }
                            .onBackground {
                                viewModel.onBackground()
                            }
                    case .finished:
                        DownloadFinishedView()
                            .onTapGesture {
                                viewModel.onDownloadViewTap(
                                    courseVertical: courseVertical,
                                    state: state
                                )
                            }
                    }
                }
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)

            }
        })
        .padding(.leading, 40)
        .padding(.trailing, 28)
        .padding(.vertical, 14)
    }

    private func verticalImage(childs: [CourseBlock]) -> Image {
        if childs.contains(where: { $0.type == .problem }) {
            return CoreAssets.pen.swiftUIImage.renderingMode(.template)
        } else if childs.contains(where: { $0.type == .video }) {
            return CoreAssets.video.swiftUIImage.renderingMode(.template)
        } else if childs.contains(where: { $0.type == .discussion }) {
            return CoreAssets.discussion.swiftUIImage.renderingMode(.template)
        } else if childs.contains(where: { $0.type == .html }) {
            return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        } else {
            return CoreAssets.extra.swiftUIImage.renderingMode(.template)
        }
    }

}
