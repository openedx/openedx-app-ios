//
//  CourseContentView.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.06.2025.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme
import SwiftUIIntrospect

public struct CourseContentView: View {
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    
    @State private var selectedTab: ContentTab = .all
    private var videoContentData: VideoContentData {
        VideoContentData(
            courseVideosStructure: viewModel.courseVideosStructure,
            courseProgress: viewModel.courseVideosStructure?.courseProgress,
            sequentialsDownloadState: viewModel.sequentialsDownloadState,
            isShowProgress: viewModel.isShowProgress,
            showError: viewModel.showError,
            errorMessage: viewModel.errorMessage
        )
    }
    @Binding private var selection: Int
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var viewHeight: CGFloat
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(
        viewModel: CourseContainerViewModel,
        title: String,
        courseID: String,
        selection: Binding<Int>,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.courseID = courseID
        self._selection = selection
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    ScrollView {
                        VStack(spacing: 0) {
                            DynamicOffsetView(
                                coordinate: $coordinate,
                                collapsed: $collapsed,
                                viewHeight: $viewHeight
                            )
                            RefreshProgressView(isShowRefresh: $viewModel.isShowRefresh)
                            VStack(alignment: .leading) {
                                // MARK: - Segmented Control
                                ContentSegmentedControl(
                                    selectedTab: $selectedTab,
                                    courseId: courseID,
                                    courseName: title,
                                    analytics: viewModel.analytics
                                )
                                    .padding(.horizontal, 24)
                                    .padding(.top, 16)
                                
                                // MARK: - Content based on selected tab
                                contentForSelectedTab(proxy: proxy)
                            }
                            .frameLimit(width: proxy.size.width)
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
                        }
                    }
                    .onRightSwipeGesture {
                        viewModel.router.back()
                    }
                }
                .accessibilityAction {}
                
                // MARK: Review Course Grading Policy
                if selectedTab == .assignments {
                    VStack(spacing: 18) {
                        Divider()
                        Button(action: {
    //                        viewModel.selection = 0
                        }, label: {
                        HStack(spacing: 4) {
                            CoreAssets.gallery.swiftUIImage.renderingMode(.template)
                            Text(CourseLocalization.Assignment.reviewGradingPolicy)
                                .font(Theme.Fonts.labelLarge)
                        }
                        .foregroundStyle(Theme.Colors.accentColor)
                        })
                    }
                    .background(Theme.Colors.background)
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await withTaskGroup(of: Void.self) { group in
                            group.addTask {
                                await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
                            }
                            group.addTask {
                                await viewModel.getCourseDeadlineInfo(courseID: courseID, withProgress: false)
                            }
                        }
                    }
                )
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, viewModel.isInternetAvaliable
                             ? 0 : OfflineSnackBarView.height)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.updateCourseIfNeeded(courseID: courseID)
            }
        }
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
    
    @ViewBuilder
    private func contentForSelectedTab(proxy: GeometryProxy) -> some View {
        switch selectedTab {
        case .all:
            AllContentView(
                viewModel: viewModel,
                proxy: proxy,
                title: title,
                courseID: courseID,
                dateTabIndex: CourseTab.dates.rawValue
            )
        case .videos:
            VideosContentView(
                videoContentData: videoContentData,
                proxy: proxy,
                onVideoTap: { video, chapter in
                    viewModel.handleVideoTap(video: video, chapter: chapter)
                },
                onDownloadSectionTap: { chapter, state in
                    await viewModel.onDownloadViewTap(chapter: chapter, state: state)
                },
                onTabSelection: { tabId in
                    viewModel.selection = tabId
                },
                onErrorDismiss: {
                    viewModel.errorMessage = nil
                }
            )
            .onReceive(NotificationCenter.default.publisher(for: .onBlockCompletion)) { _ in
                Task {
                    await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: .onVideoProgressUpdated)) { notification in
                guard let userInfo = notification.userInfo,
                      let blockID = userInfo["blockID"] as? String,
                      let progress = userInfo["progress"] as? Double else {
                    return
                }
                Task {
                    await viewModel.updateVideoProgress(blockID: blockID, progress: progress)
                }
            }
        case .assignments:
            AssignmentsContentView(
                viewModel: viewModel,
                proxy: proxy,
                title: title,
                courseID: courseID,
                dateTabIndex: CourseTab.dates.rawValue
            )
        }
    }
}

#if DEBUG
#Preview {
    let viewModel = CourseContainerViewModel(
        interactor: CourseInteractor.mock,
        authInteractor: AuthInteractor.mock,
        router: CourseRouterMock(),
        analytics: CourseAnalyticsMock(),
        config: ConfigMock(),
        connectivity: Connectivity(),
        manager: DownloadManagerMock(),
        storage: CourseStorageMock(),
        isActive: true,
        courseStart: Date(),
        courseEnd: nil,
        enrollmentStart: Date(),
        enrollmentEnd: nil,
        lastVisitedBlockID: nil,
        coreAnalytics: CoreAnalyticsMock(),
        courseHelper: CourseDownloadHelper(courseStructure: nil, manager: DownloadManagerMock())
    )
    
    CourseContentView(
        viewModel: viewModel,
        title: "Course title",
        courseID: "",
        selection: .constant(0),
        coordinate: .constant(0),
        collapsed: .constant(false),
        viewHeight: .constant(0)
    )
}
#endif
