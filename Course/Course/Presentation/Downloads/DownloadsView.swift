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
                }
            }
            .padding(.top, 1)
        }
    }

    // MARK: - Views

    @ViewBuilder
    func cell(downloadData: DownloadData) -> some View {
        VStack(spacing: 0) {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(downloadData.displayName)
                            .font(Theme.Fonts.titleMedium)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        Text(downloadData.fileSizeInMbText)
                            .font(Theme.Fonts.titleSmall)
                            .foregroundColor(Theme.Colors.textSecondary)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                        if downloadData.state != .finished {
                            ProgressView(value: downloadData.progress, total: 1.0)
                        }
                    }
                    Spacer()
                    Button {
                        Task {
                           await  viewModel.cancelDownloading(downloadData: downloadData)
                        }
                    } label: {
                        if downloadData.state == .finished {
                            DownloadFinishedView()
                                .foregroundColor(Theme.Colors.textPrimary)
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                        } else {
                            DownloadProgressView()
                                .accessibilityElement(children: .ignore)
                                .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
                        }
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
