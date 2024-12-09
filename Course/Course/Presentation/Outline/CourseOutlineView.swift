//
//  ProfileView.swift
//  Profile
//
//  Created by Stepanok Ivan on 29.09.2022.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme
import SwiftUIIntrospect

public struct CourseOutlineView: View {
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let isVideo: Bool
    private let dateTabIndex: Int
    
    @State private var openCertificateView: Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var showingDownloads: Bool = false
    @State private var showingVideoDownloadQuality: Bool = false
    @State private var showingNoWifiMessage: Bool = false
    @State private var runOnce: Bool = false
    @Binding private var selection: Int
    @Binding private var coordinate: CGFloat
    @Binding private var collapsed: Bool
    @Binding private var viewHeight: CGFloat
    
    @State private var expandedChapters: [String: Bool] = [:]
    
    public init(
        viewModel: CourseContainerViewModel,
        title: String,
        courseID: String,
        isVideo: Bool,
        selection: Binding<Int>,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        dateTabIndex: Int
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.courseID = courseID
        self.isVideo = isVideo
        self._selection = selection
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
        self.dateTabIndex = dateTabIndex
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
                                
                                if isVideo,
                                   viewModel.isShowProgress == false {
                                    downloadQualityBars(proxy: proxy)
                                }
                                certificateView
                                
                                if viewModel.courseStructure == nil,
                                   viewModel.isShowProgress == false,
                                   !isVideo {
                                    FullScreenErrorView(
                                        type: .noContent(
                                            CourseLocalization.Error.coursewareUnavailable,
                                            image: CoreAssets.information.swiftUIImage
                                        )
                                    )
                                    .frame(maxWidth: .infinity)
                                    .frame(height: proxy.size.height - viewHeight)
                                } else {
                                    if let continueWith = viewModel.continueWith,
                                       let courseStructure = viewModel.courseStructure,
                                       !isVideo {
                                        let chapter = courseStructure.childs[continueWith.chapterIndex]
                                        let sequential = chapter.childs[continueWith.sequentialIndex]
                                        let continueUnit = sequential.childs[continueWith.verticalIndex]
                                        
                                        ContinueWithView(
                                            data: continueWith,
                                            courseContinueUnit: continueUnit
                                        ) {
                                            viewModel.openLastVisitedBlock()
                                        }
                                    }
                                    
                                    if let course = isVideo
                                        ? viewModel.courseVideosStructure
                                        : viewModel.courseStructure {
                                        
                                        if !isVideo,
                                           let progress = course.courseProgress,
                                           progress.totalAssignmentsCount != 0 {
                                            CourseProgressView(progress: progress)
                                                .padding(.horizontal, 24)
                                                .padding(.top, 16)
                                                .padding(.bottom, 8)
                                        }
                                        
                                        // MARK: - Sections
                                        CustomDisclosureGroup(
                                            isVideo: isVideo,
                                            course: course,
                                            proxy: proxy,
                                            viewModel: viewModel
                                        )
                                    } else {
                                        if let courseStart = viewModel.courseStart {
                                            Text(
                                                courseStart > Date()
                                                ? CourseLocalization.Outline.courseHasntStarted
                                                : ""
                                            )
                                            .frame(maxWidth: .infinity)
                                            .frame(maxHeight: .infinity)
                                            .padding(.top, 100)
                                        }
                                        Spacer(minLength: viewHeight < 200 ? 200 : viewHeight)
                                    }
                                }
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
                if viewModel.isShowProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.horizontal)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
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
        .sheet(isPresented: $showingDownloads) {
            DownloadsView(router: viewModel.router, manager: viewModel.manager)
        }
        .sheet(isPresented: $showingVideoDownloadQuality) {
            viewModel.storage.userSettings.map {
                VideoDownloadQualityContainerView(
                    downloadQuality: $0.downloadQuality,
                    didSelect: viewModel.update(downloadQuality:),
                    analytics: viewModel.coreAnalytics,
                    router: viewModel.router,
                    isModal: true
                )
            }
        }
        .onReceive(
            NotificationCenter.default.publisher(
                for: .onBlockCompletion
            )
        ) { notification in
            guard let userInfo = notification.userInfo,
                  let chapterID = userInfo["chapterID"] as? String,
                  let sequentialID = userInfo["sequentialID"] as? String,
                  let verticalID = userInfo["verticalID"] as? String,
                  let blockID = userInfo["blockID"] as? String else {
                return
            }
            Task {
                await viewModel.completeBlock(
                    chapterID: chapterID,
                    sequentialID: sequentialID,
                    verticalID: verticalID,
                    blockID: blockID
                )
            }
        }
    }
    
    @ViewBuilder
    private func downloadQualityBars(proxy: GeometryProxy) -> some View {
        if let courseVideosStructure = viewModel.courseVideosStructure,
           viewModel.hasVideoForDowbloads() {
            VStack(spacing: 0) {
                CourseVideoDownloadBarView(
                    courseStructure: courseVideosStructure,
                    courseViewModel: viewModel,
                    onNotInternetAvaliable: {
                        viewModel.errorMessage = CourseLocalization.Download.noWifiMessage
                    },
                    onTap: {
                        showingDownloads = true
                    },
                    analytics: viewModel.analytics
                )
                viewModel.userSettings.map {
                    VideoDownloadQualityBarView(
                        downloadQuality: $0.downloadQuality
                    ) {
                        if viewModel.isAllDownloading() {
                            viewModel.errorMessage = CourseLocalization.Download.changeQualityAlert
                            return
                        }
                        showingVideoDownloadQuality = true
                    }
                }
            }
        } else if viewModel.courseVideosStructure == nil {
            FullScreenErrorView(
                type: .noContent(
                    CourseLocalization.Error.videosUnavailable,
                    image: CoreAssets.noVideos.swiftUIImage
                )
            )
            .frame(maxWidth: .infinity)
            .frame(height: proxy.size.height - viewHeight)
            Spacer(minLength: -200)
        }
    }
    @ViewBuilder
    private var certificateView: some View {
        // MARK: - Course Certificate
        if let certificate = viewModel.courseStructure?.certificate,
           let url = certificate.url,
           url.count > 0 {
            MessageSectionView(
                title: CourseLocalization.Outline.passedTheCourse(title),
                actionTitle: CourseLocalization.Outline.viewCertificate,
                action: {
                    openCertificateView = true
                    viewModel.trackViewCertificateClicked(courseID: courseID)
                }
            )
            .padding(.horizontal, 24)
            .fullScreenCover(
                isPresented: $openCertificateView,
                content: {
                    WebBrowser(
                        url: url,
                        pageTitle: CourseLocalization.Outline.certificate,
                        connectivity: viewModel.connectivity
                    )
                }
            )
        }
    }
    
    private func courseBanner(proxy: GeometryProxy) -> some View {
        ZStack {
            // MARK: - Course Banner
            if let banner = viewModel.courseStructure?.media.image.raw
                .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                KFImage(URL(string: viewModel.config.baseURL.absoluteString + banner))
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: proxy.size.width - 12, maxHeight: .infinity)
            }
        }
        .frame(maxHeight: 250)
        .cornerRadius(12)
        .padding(.horizontal, 6)
        .padding(.top, 7)
        .fixedSize(horizontal: false, vertical: true)
    }
}

#if DEBUG
struct CourseOutlineView_Previews: PreviewProvider {
    static var previews: some View {
        @State var selection: Int = 0
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
            coreAnalytics: CoreAnalyticsMock()
        )
        Task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await viewModel.getCourseBlocks(courseID: "courseId")
                }
                group.addTask {
                    await viewModel.getCourseDeadlineInfo(courseID: "courseId")
                }
            }
        }
        
        return Group {
            CourseOutlineView(
                viewModel: viewModel,
                title: "Course title",
                courseID: "",
                isVideo: false,
                selection: $selection,
                coordinate: .constant(0),
                collapsed: .constant(false),
                viewHeight: .constant(0),
                dateTabIndex: 2
            )
            .preferredColorScheme(.light)
            .previewDisplayName("CourseOutlineView Light")
            
            CourseOutlineView(
                viewModel: viewModel,
                title: "Course title",
                courseID: "",
                isVideo: false,
                selection: $selection,
                coordinate: .constant(0),
                collapsed: .constant(false),
                viewHeight: .constant(0),
                dateTabIndex: 2
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseOutlineView Dark")
        }
        
    }
}
#endif
