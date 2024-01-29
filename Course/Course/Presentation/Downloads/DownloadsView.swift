//
//  DownloadsView.swift
//  Course
//
//  Created by Eugene Yatsenko on 20.12.2023.
//

import SwiftUI
import Core
import Theme
import Combine

struct DownloadsView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: DownloadsViewModel

    init(
        courseId: String? = nil,
        manager: DownloadManagerProtocol
    ) {
        self._viewModel = .init(
            wrappedValue: .init(courseId: courseId, manager: manager)
        )
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(
                        viewModel.downloads,
                        content: cell
                    )
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle(CourseLocalization.Download.downloads)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .accessibilityIdentifier("close_button")
                }
            }
            .padding(.top, 1)
        }
    }

    // MARK: - Views

    @ViewBuilder
    func cell(task: DownloadDataTask) -> some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        let title = viewModel.title(task: task)
                        Text(title)
                            .font(Theme.Fonts.titleMedium)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(title)
                            .accessibilityIdentifier("file_name_text")
                        let fileSizeInMbText = task.fileSizeInMbText
                        Text(fileSizeInMbText)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(fileSizeInMbText)
                            .accessibilityIdentifier("file_size_text")
                        if task.state != .finished {
                            ProgressView(value: task.progress, total: 1.0)
                                .tint(Theme.Colors.accentColor)
                                .accessibilityIdentifier("progress_line_view")
                        }
                    }
                    Spacer()
                    Button {
                        Task {
                           await viewModel.cancelDownloading(task: task)
                        }
                    } label: {
                        DownloadProgressView()
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                            .accessibilityIdentifier("cancel_download_button")
                    }
                    .padding(.horizontal, 15)
                }
                .padding(.leading, 20)
                .padding(.vertical, 5)
                Divider()
            }
        }
    }
}
