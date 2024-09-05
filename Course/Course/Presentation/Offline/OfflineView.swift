//
//  OfflineView.swift
//  Course
//
//  Created by  Stepanok Ivan on 17.06.2024.
//

import SwiftUI
import Core
import Theme

struct OfflineView: View {
    
    enum DownloadAllState: Equatable {
        case start
        case cancel
        
        var color: Color {
            switch self {
            case .start:
                Theme.Colors.accentColor
            case .cancel:
                Theme.Colors.snackbarErrorColor
            }
        }
        
        var image: Image {
            switch self {
            case .start:
                CoreAssets.startDownloading.swiftUIImage
            case .cancel:
                CoreAssets.stopDownloading.swiftUIImage
            }
        }
        
        var title: String {
            switch self {
            case .start:
                CourseLocalization.Course.Offline.downloadAll
            case .cancel:
                CourseLocalization.Course.Offline.cancelCourseDownload
            }
        }
        
        var textColor: Color {
            switch self {
            case .start:
                Theme.Colors.white
            case .cancel:
                Theme.Colors.snackbarErrorColor
            }
        }
    }
    
    private let courseID: String
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    
    @StateObject
    private var viewModel: CourseContainerViewModel
    
    public init(
        courseID: String,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewModel: CourseContainerViewModel
    ) {
        self.courseID = courseID
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .center) {
                VStack(alignment: .center) {
                    // MARK: - Page Body

                        if viewModel.isShowProgress {
                            HStack(alignment: .center) {
                                ProgressBar(size: 40, lineWidth: 8)
                                    .padding(.top, 200)
                                    .padding(.horizontal)
                            }
                        } else {
                            ScrollView {
                                VStack(alignment: .leading) {
                                    DynamicOffsetView(
                                        coordinate: $coordinate,
                                        collapsed: $collapsed
                                    )
                                    TotalDownloadedProgressView(
                                        downloadedFilesSize: viewModel.downloadedFilesSize,
                                        totalFilesSize: viewModel.totalFilesSize,
                                        isDownloading: Binding<Bool>(
                                            get: { viewModel.downloadAllButtonState == .cancel },
                                            set: { newValue in
                                                viewModel.downloadAllButtonState = newValue ? .cancel : .start
                                            }
                                        )
                                    )
                                    .padding(.top, 36)
                                    
                                    if viewModel.downloadedFilesSize == 0 && viewModel.totalFilesSize != 0 {
                                        Text(CourseLocalization.Course.Offline.youCanDownload)
                                            .font(Theme.Fonts.labelLarge)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .padding(.top, 8)
                                            .padding(.bottom, 16)
                                    } else if viewModel.downloadedFilesSize == 0 && viewModel.totalFilesSize == 0 {
                                        Text(CourseLocalization.Course.Offline.youCantDownload)
                                            .font(Theme.Fonts.labelLarge)
                                            .foregroundColor(Theme.Colors.textPrimary)
                                            .padding(.top, 8)
                                            .padding(.bottom, 16)
                                    }
                                        downloadAll
                                    
                                    if !viewModel.largestDownloadBlocks.isEmpty {
                                        LargestDownloadsView(viewModel: viewModel)
                                    }
                                    removeAllDownloads
                                                                        
                                }.padding(.horizontal, 32)
                                Spacer(minLength: 84)
                            }
                        }
                }
                .frameLimit(width: proxy.size.width)
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {}
                )
                
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
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
        }
    }
    
    @ViewBuilder
    private var downloadAll: some View {
        if viewModel.connectivity.isInternetAvaliable
            && (viewModel.totalFilesSize - viewModel.downloadedFilesSize != 0)
            || (viewModel.totalFilesSize == 0 && viewModel.downloadedFilesSize == 0) {
            Button(action: {
                Task(priority: .low) {
                    switch viewModel.downloadAllButtonState {
                    case .start:
                        await viewModel.downloadAll()
                    case .cancel:
                        viewModel.downloadAllButtonState = .start
                        await viewModel.stopAllDownloads()
                    }
                }
            }) {
                HStack {
                    viewModel.downloadAllButtonState.image
                        .renderingMode(.template)
                    Text(viewModel.downloadAllButtonState.title)
                        .font(Theme.Fonts.bodyMedium)
                }
                .foregroundStyle(
                    viewModel.totalFilesSize == 0
                    ? Theme.Colors.disabledButtonText
                    : viewModel.downloadAllButtonState.textColor
                )
                .frame(maxWidth: .infinity)
                .frame(height: 42)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            viewModel.totalFilesSize == 0
                            ? .clear
                            : viewModel.downloadAllButtonState.color, lineWidth: 2
                        )
                )
                .background(
                    viewModel.totalFilesSize == 0
                    ? Theme.Colors.disabledButton
                    : viewModel.downloadAllButtonState == .start ? viewModel.downloadAllButtonState.color : .clear
                )
                .cornerRadius(8)
            }
        }
    }
    
    @ViewBuilder
    private var removeAllDownloads: some View {
        if viewModel.downloadAllButtonState == .start && !viewModel.largestDownloadBlocks.isEmpty {
            VStack(spacing: 16) {
                Button(action: {
                    Task {
                        await viewModel.removeAllBlocks()
                    }
                }) {
                    HStack {
                        CoreAssets.remove.swiftUIImage
                        Text(CourseLocalization.Course.LargestDownloads.removeDownloads)
                            .font(Theme.Fonts.bodyMedium)
                    }
                    .foregroundStyle(Theme.Colors.snackbarErrorColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Theme.Colors.snackbarErrorColor, lineWidth: 2)
                    )
                    .background(Theme.Colors.background)
                    .cornerRadius(8)
                }
            }
            .padding(.vertical, 4)
        }
    }
}
