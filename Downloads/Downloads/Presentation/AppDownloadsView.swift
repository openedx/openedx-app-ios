//
//  AppDownloadsView.swift
//  Downloads
//
//  Created by Ivan Stepanok on 22.02.2025.
//

import SwiftUI
import Theme
import OEXFoundation
import Core

public struct AppDownloadsView: View {
    
    @Environment(\.isHorizontal) private var isHorizontal
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @StateObject private var viewModel: AppDownloadsViewModel
    
    private func columns() -> [GridItem] {
        isHorizontal || idiom == .pad
        ? [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
        : [
            GridItem(.flexible(), spacing: 0)
        ]
    }
    
    public init(viewModel: AppDownloadsViewModel) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }

    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                Theme.Colors.background
                    .ignoresSafeArea()
                ScrollView {
                    StyledButton(
                        DownloadsLocalization.Downloads.manageDownloadSettings,
                        action: {},
                        color: .clear,
                        textColor: Theme.Colors.accentColor,
                        borderColor: Theme.Colors.accentColor
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 1)
                    .padding(.bottom, 16)
                    
                    if viewModel.courses.isEmpty {
                        noCoursesToDownload
                            .padding(.top, 100)
                    }
                    
                    LazyVGrid(columns: columns(), spacing: 16) {
                        ForEach(viewModel.courses) { course in
                            DownloadCourseCell(
                                course: course,
                                downloadedSize: Binding(
                                    get: { viewModel.downloadedSizes[course.id] ?? 0 },
                                    set: { viewModel.downloadedSizes[course.id] = $0 }
                                ),
                                onDownloadTap: {
                                    viewModel.downloadCourse(courseID: course.id)
                                },
                                onRemoveTap: {
                                    viewModel.removeDownload(courseID: course.id)
                                },
                                onCancelTap: {
                                    viewModel.cancelDownload(courseID: course.id)
                                }
                            )
                        }
                    }
                    Spacer(minLength: 100)
                }
                .frameLimit(width: proxy.size.width)
                .accessibilityAction {}
                .padding(.top, 8)
                .navigationBarHidden(false)
                .navigationBarBackButtonHidden(false)
                .navigationTitle(DownloadsLocalization.Downloads.title)
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(
                connectivity: viewModel.connectivity,
                reloadAction: {
                    await viewModel.getDownloadCourses()
                })
            
            // MARK: - Error Alert
            if viewModel.showError {
                VStack {
                    Spacer()
                    SnackBarView(message: viewModel.errorMessage)
                }
                .padding(.bottom, viewModel.connectivity.isInternetAvaliable
                         ? 0 : OfflineSnackBarView.height)
                .transition(.move(edge: .bottom))
                .onAppear {
                    doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.getDownloadCourses()
            }
        }
    }
    
    private var noCoursesToDownload: some View {
        VStack(spacing: 8) {
            Spacer()
            CoreAssets.learnEmpty.swiftUIImage
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundStyle(Theme.Colors.textSecondaryLight)
            Text(DownloadsLocalization.Downloads.NoCoursesToDownload.title)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.titleMedium)
            Text(DownloadsLocalization.Downloads.NoCoursesToDownload.description)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.labelMedium)
                .frame(width: 245)
        }
    }
}

#if DEBUG
#Preview {
    AppDownloadsView(viewModel: AppDownloadsViewModel.mock)
}
#endif
