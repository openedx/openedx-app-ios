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

public struct DownloadsView: View {

    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment (\.isHorizontal) private var isHorizontal
    @StateObject private var viewModel: DownloadsViewModel

    var isSheet: Bool = true

    public init(
        isSheet: Bool = true,
        router: CourseRouter,
        courseId: String? = nil,
        downloads: [DownloadDataTask] = [],
        manager: DownloadManagerProtocol
    ) {
        self.isSheet = isSheet
        self._viewModel = .init(
            wrappedValue: .init(
                router: router,
                courseId: courseId,
                downloads: downloads,
                manager: manager
            )
        )
    }

    // MARK: - Body

    public var body: some View {
        ZStack(alignment: .top) {
            Theme.Colors.background
                .ignoresSafeArea()
            if !isSheet {
                HStack {
                    Text(CourseLocalization.Download.downloads)
                        .titleSettings(color: Theme.Colors.textPrimary)
                        .accessibilityIdentifier("downloads_text")
                }
                .padding(.top, isHorizontal ? 10 : 0)
                VStack {
                    BackNavigationButton(
                        color: Theme.Colors.accentColor,
                        action: {
                            viewModel.router.back()
                        }
                    )
                    .backViewStyle()
                    .padding(.leading, 8)
                    
                }
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
                .padding(.top, isHorizontal ? 23 : 13)
                
            }
            content
                .sheetNavigation(isSheet: isSheet) {
                    dismiss()
                }
                .padding(.top, isSheet ? 0 : 40)
        }
    }

    private var content: some View {
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
        .padding(.top, 1)
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
                            .id("cirle loading indicator " + task.id)
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
