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
            ZStack(alignment: .top) {
                Theme.Colors.background
                    .ignoresSafeArea()
                
                // MARK: - Custom header
                downloadsHeaderView(proxy: proxy)
                    .zIndex(1)
                
                if viewModel.fetchInProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.top, 200)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                } else {
                    // MARK: - Content
                    VStack(alignment: .leading) {
                        Spacer(minLength: 50)
                        ScrollView {
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
                                        downloadState: viewModel.downloadStates[course.id],
                                        onDownloadTap: {
                                            Task {
                                                await viewModel.downloadCourse(courseID: course.id)
                                            }
                                        },
                                        onCardTap: {
                                            viewModel.router
                                                .showCourseScreens(
                                                    courseID: course.id,
                                                    hasAccess: true,
                                                    courseStart: Date(),
                                                    courseEnd: nil,
                                                    enrollmentStart: nil,
                                                    enrollmentEnd: nil,
                                                    title: course.name,
                                                    courseRawImage: nil,
                                                    showDates: false,
                                                    lastVisitedBlockID: nil
                                                )
                                        },
                                        onRemoveTap: {
                                            Task {
                                                await viewModel.removeDownload(courseID: course.id)
                                            }
                                        },
                                        onCancelTap: {
                                            Task {
                                                await viewModel.cancelDownload(courseID: course.id)
                                            }
                                        }
                                    ).id(course.id)
                                        .frame(height: 330)
                                }
                            }
                            Spacer(minLength: 100)
                        }
                        .frameLimit(width: proxy.size.width)
                        .accessibilityAction {}
                        .refreshable {
                            Task {
                                await viewModel.getDownloadCourses(isRefresh: true)
                            }
                        }
                    }
                    .padding(.top, 8)
                    .navigationBarHidden(true)
                    .navigationBarBackButtonHidden(true)
                }
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
                .padding(
                    .bottom,
                    viewModel.connectivity.isInternetAvaliable
                    ? 0
                    : OfflineSnackBarView.height
                )
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
    
    // MARK: - Custom header view
    private func downloadsHeaderView(proxy: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            Theme.Colors.background
                .frame(height: 50)
            ZStack(alignment: .topTrailing) {
                VStack {
                    HStack(alignment: .center) {
                        Text(DownloadsLocalization.Downloads.title)
                            .font(Theme.Fonts.displaySmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityIdentifier("downloads_header_text")
                        Spacer()
                    }
                }
                .frameLimit(width: proxy.size.width)
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.router.showSettings()
                    }, label: {
                        CoreAssets.settings.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                }
                .padding(.top, 8)
                .offset(x: idiom == .pad ? 1 : 5, y: idiom == .pad ? 4 : -5)
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(DownloadsLocalization.Downloads.title)
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
