//
//  CourseVerticalView.swift
//  Course
//
//  Created by  Stepanok Ivan on 12.12.2022.
//

import SwiftUI

import Core
import Kingfisher
import Theme

public struct CourseVerticalView: View {
    
    private var title: String
    private var courseName: String
    private var courseID: String
    @ObservedObject
    private var viewModel: CourseVerticalViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(
        title: String,
        courseName: String,
        courseID: String,
        viewModel: CourseVerticalViewModel
    ) {
        self.title = title
        self.courseName = courseName
        self.courseID = courseID
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            GeometryReader { proxy in
                ScrollView {
                    VStack(alignment: .leading) {
                        // MARK: - Lessons list
                        ForEach(viewModel.verticals, id: \.id) { vertical in
                            if let index = viewModel.verticals.firstIndex(where: {$0.id == vertical.id}) {
                                HStack {
                                Button(action: {
                                    let vertical = viewModel.verticals[index]
                                    if let block = vertical.childs.first {
                                        viewModel.trackVerticalClicked(
                                            courseId: courseID,
                                            courseName: courseName,
                                            vertical: vertical
                                        )
                                        viewModel.router.showCourseUnit(
                                            courseName: courseName,
                                            blockId: block.id,
                                            courseID: courseID,
                                            verticalIndex: index,
                                            chapters: viewModel.chapters,
                                            chapterIndex: viewModel.chapterIndex,
                                            sequentialIndex: viewModel.sequentialIndex
                                        )
                                    }
                                }, label: {
                                        Group {
                                            if vertical.completion == 1 {
                                                CoreAssets.finished.swiftUIImage
                                                    .renderingMode(.template)
                                                    .foregroundColor(.accentColor)
                                            } else {
                                                CourseVerticalImageView(blocks: vertical.childs)
                                            }
                                            Text(vertical.displayName)
                                                .font(Theme.Fonts.titleMedium)
                                                .lineLimit(1)
                                                .frame(maxWidth: idiom == .pad
                                                       ? proxy.size.width * 0.5
                                                       : proxy.size.width * 0.6,
                                                       alignment: .leading)
                                                .multilineTextAlignment(.leading)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }.foregroundColor(Theme.Colors.textPrimary)
                                    }).accessibilityElement(children: .ignore)
                                        .accessibilityLabel(vertical.displayName)
                                        Spacer()
                                        if let state = viewModel.downloadState[vertical.id] {
                                            switch state {
                                            case .available:
                                                DownloadAvailableView()
                                                    .accessibilityElement(children: .ignore)
                                                    .accessibilityLabel(CourseLocalization.Accessibility.download)
                                                    .onTapGesture {
                                                        Task {
                                                            await viewModel.onDownloadViewTap(
                                                                blockId: vertical.id,
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
                                                                blockId: vertical.id,
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
                                                                blockId: vertical.id,
                                                                state: state
                                                            )
                                                        }
                                                    }
                                            }
                                        }
                                        Image(systemName: "chevron.right")
                                        .flipsForRightToLeftLayoutDirection(true)
                                            .padding(.vertical, 8)
                                    }
                                .padding(.horizontal, 36)
                                    .padding(.vertical, 14)
                                if index != viewModel.verticals.count - 1 {
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(Theme.Colors.cardViewStroke)
                                        .padding(.horizontal, 24)
                                }
                            }
                        }
                    }
                    .frameLimit(width: proxy.size.width)
                    Spacer(minLength: 84)
                }
                .accessibilityAction {}
                .onRightSwipeGesture {
                    viewModel.router.back()
                }
            }
            .padding(.top, 8)
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: { })
            
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
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .navigationTitle(title)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct CourseVerticalView_Previews: PreviewProvider {
    static var previews: some View {
        let chapters = [
            CourseChapter(
                blockId: "1",
                id: "1",
                displayName: "Chapter 1",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "3",
                        id: "3",
                        displayName: "Sequential",
                        type: .sequential,
                        completion: 1,
                        childs: [
                            CourseVertical(
                                blockId: "4",
                                id: "4",
                                courseId: "1",
                                displayName: "Vertical",
                                type: .vertical,
                                completion: 0,
                                childs: [])
                        ])
                ])
        ]
        
        let viewModel = CourseVerticalViewModel(
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            manager: DownloadManagerMock(),
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity()
        )
        
        return Group {
            CourseVerticalView(
                title: "Course title",
                courseName: "CourseName",
                courseID: "1",
                viewModel: viewModel
            )
            .preferredColorScheme(.light)
            .previewDisplayName("CourseVerticalView Light")
            
            CourseVerticalView(
                title: "Course title",
                courseName: "CourseName",
                courseID: "1",
                viewModel: viewModel
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseVerticalView Dark")
        }
        
    }
}
#endif
