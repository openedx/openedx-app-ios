//
//  CourseStructureNestedListView.swift
//  Course
//
//  Created by Eugene Yatsenko on 09.11.2023.
//

import SwiftUI
import Core
import Kingfisher
import Theme

struct CourseStructureNestedListView: View {

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
        ForEach(course.childs, content: disclosureGroup)
    }

    private func disclosureGroup(chapter: CourseChapter) -> some View {
        CustomDisclosureGroup(
            animation: .easeInOut(duration: 0.2),
            isExpanded: .constant(isExpandedIds.contains(where: { $0 == chapter.id })),
            onClick: { onHeaderClick(chapter: chapter) },
            header: { isExpanded in header(chapter: chapter, isExpanded: isExpanded) },
            content: { section(chapter: chapter) }
        )
    }

    private func header(
        chapter: CourseChapter,
        isExpanded: Bool
    ) -> some View {
        HStack {
            Text(chapter.displayName)
                .font(Theme.Fonts.titleMedium)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
                .foregroundColor(Theme.Colors.textPrimary)
            Spacer()
            Image(systemName: "chevron.down")
                .foregroundColor(Theme.Colors.accentColor)
                .dropdownArrowRotationAnimation(value: isExpanded)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 15)
    }

    private func section(chapter: CourseChapter) -> some View {
        ForEach(chapter.childs) { sequential in
            VStack(spacing: 0) {
                sequentialLabel(
                    sequential: sequential,
                    chapter: chapter,
                    isExpanded: false
                )
            }
        }
    }

    @ViewBuilder
    private func sequentialLabel(
        sequential: CourseSequential,
        chapter: CourseChapter,
        isExpanded: Bool
    ) -> some View {
        HStack {
            Button {
                onLabelClick(sequential: sequential, chapter: chapter)
            } label: {
                Group {
                    if sequential.completion == 1 {
                        CoreAssets.finished.swiftUIImage
                            .renderingMode(.template)
                            .foregroundColor(.accentColor)
                    } else {
                        sequential.type.image
                    }
                    Text(sequential.displayName)
                        .font(Theme.Fonts.titleMedium)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                .foregroundColor(Theme.Colors.textPrimary)
            }
            Spacer()
            downloadButton(
                sequential: sequential,
                chapter: chapter
            )

        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(sequential.displayName)
        .padding(.leading, 40)
        .padding(.trailing, 28)
        .padding(.vertical, 14)
    }

    @ViewBuilder
    private func downloadButton(
        sequential: CourseSequential,
        chapter: CourseChapter
    ) -> some View {
        if let state = viewModel.sequentialsDownloadState[sequential.id] {
            switch state {
            case .available:
                if viewModel.isInternetAvaliable {
                    Button {
                        Task {
                            await viewModel.onDownloadViewTap(
                                chapter: chapter,
                                blockId: sequential.id,
                                state: state
                            )
                        }
                    } label: {
                        DownloadAvailableView()
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(CourseLocalization.Accessibility.download)
                    }
                    downloadCount(sequential: sequential)
                }
            case .downloading:
                if viewModel.isInternetAvaliable {
                    Button {
                        Task {
                            await viewModel.onDownloadViewTap(
                                chapter: chapter,
                                blockId: sequential.id,
                                state: state
                            )
                        }
                    } label: {
                        DownloadProgressView()
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                    }
                }
            case .finished:
                Button {
                    viewModel.router.presentAlert(
                        alertTitle: "Warning",
                        alertMessage: "\(CourseLocalization.Alert.deleteVideos) \"\(sequential.displayName)\"?",
                        positiveAction: CoreLocalization.Alert.delete,
                        onCloseTapped: {
                            viewModel.router.dismiss(animated: true)
                        },
                        okTapped: {
                            Task {
                                await viewModel.onDownloadViewTap(
                                    chapter: chapter,
                                    blockId: sequential.id,
                                    state: state
                                )
                            }
                            viewModel.router.dismiss(animated: true)
                        },
                        type: .default(
                            positiveAction: CoreLocalization.Alert.delete,
                            image: CoreAssets.bgDelete.swiftUIImage
                        )
                    )
                } label: {
                    DownloadFinishedView()
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(CourseLocalization.Accessibility.deleteDownload)
                }
                downloadCount(sequential: sequential)
            }
        }
    }

    @ViewBuilder
    private func downloadCount(sequential: CourseSequential) -> some View {
        let downloadable = viewModel.verticalsBlocksDownloadable(by: sequential)
        if !downloadable.isEmpty {
            Text(String(downloadable.count))
                .foregroundColor(Color(UIColor.label))
        }
    }

    private func onHeaderClick(chapter: CourseChapter) {
        if let index = isExpandedIds.firstIndex(where: {$0 == chapter.id}) {
            isExpandedIds.remove(at: index)
        } else {
            isExpandedIds.append(chapter.id)
        }
    }

    private func onLabelClick(
        sequential: CourseSequential,
        chapter: CourseChapter
    ) {
        guard let chapterIndex = course.childs.firstIndex(
            where: { $0.id == chapter.id }
        ) else {
            return
        }

        guard let sequentialIndex = chapter.childs.firstIndex(
            where: { $0.id == sequential.id }
        ) else {
            return
        }

        guard let courseVertical = sequential.childs.first else {
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
            verticalIndex: 0,
            chapters: course.childs,
            chapterIndex: chapterIndex,
            sequentialIndex: sequentialIndex
        )

    }

}
