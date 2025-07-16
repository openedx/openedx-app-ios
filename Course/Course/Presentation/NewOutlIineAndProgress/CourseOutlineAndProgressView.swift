import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import Theme
import SwiftUIIntrospect
import WhatsNew

public struct CourseOutlineAndProgressView: View {
    
    // MARK: - Variables
    @StateObject private var viewModelContainer: CourseContainerViewModel
    @StateObject private var viewModelProgress: CourseProgressViewModel
    private let title: String
    private let courseID: String
    private let isVideo: Bool
    private let dateTabIndex: Int
    private let connectivity: ConnectivityProtocol

    private var carouselSections: [AnyView] { [
        AnyView(CourseCompletionCarouselSlideView(
            viewModelProgress: viewModelProgress,
            viewModelContainer: viewModelContainer,
            isVideo: isVideo,
            idiom: UIDevice.current.userInterfaceIdiom
        ) { proxy in
            downloadQualityBars(proxy: proxy)
        }),
        AnyView(
            CourseGradeCarouselSlideView(
                viewModelProgress: viewModelProgress,
                viewModelContainer: viewModelContainer
            )
        )
    ]}
    
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
    
    @State private var infoPath: Int = 0
    
    @State private var expandedChapters: [String: Bool] = [:]
    
    // MARK: - Init
    public init(
        viewModelContainer: CourseContainerViewModel,
        viewModelProgress: CourseProgressViewModel,
        title: String,
        courseID: String,
        isVideo: Bool,
        selection: Binding<Int>,
        coordinate: Binding<CGFloat>,
        collapsed: Binding<Bool>,
        viewHeight: Binding<CGFloat>,
        dateTabIndex: Int,
        connectivity: ConnectivityProtocol
    ) {
        self.title = title
        self._viewModelContainer = StateObject(wrappedValue: { viewModelContainer }())
        self._viewModelProgress = StateObject(wrappedValue: { viewModelProgress}())
        self.courseID = courseID
        self.isVideo = isVideo
        self._selection = selection
        self._coordinate = coordinate
        self._collapsed = collapsed
        self._viewHeight = viewHeight
        self.dateTabIndex = dateTabIndex
        self.connectivity = connectivity
    }
    
    // MARK: - Body
    public var body: some View {
        ZStack(alignment: .top) {
            GeometryReader { _ in
                VStack(alignment: .center) {
                    ScrollView {
                        VStack(spacing: 0) {
                            DynamicOffsetView(
                                coordinate: $coordinate,
                                collapsed: $collapsed,
                                viewHeight: $viewHeight
                            )
                            
                            RefreshProgressView(isShowRefresh: $viewModelContainer.isShowRefresh)
                            
                            VStack(alignment: .leading) {
                                
                                Spacer()
                                
                                if let continueWith = viewModelContainer.continueWith,
                                   let courseStructure = viewModelContainer.courseStructure {
                                    let chapter = courseStructure.childs[continueWith.chapterIndex]
                                    
                                    UnitButtonView(
                                        type: .continueLessonCustom(
                                            chapter.displayName
                                        ),
                                        action: {
                                            viewModelContainer.openLastVisitedBlock()
                                        })
                                    .padding(.horizontal, 24)
                                }
                                
                                ZStack {
                                    carouselContent
                                }
                                .frame(maxWidth: .infinity)
                                .hidden()
                                .overlay {
                                    carouselTabView
                                }
                                                                
                            }
                            .background(
                                Theme.Colors.background
                                    .ignoresSafeArea()
                            )
                            .opacity(viewModelProgress.isLoading || viewModelContainer.isShowProgress ? 0 : 1)
                        }
                        .onAppear {
                            if viewModelProgress.courseProgress == nil {
                                Task {
                                    await viewModelProgress.getCourseProgress(courseID: courseID)
                                }
                            }
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModelContainer.getCourseBlocks(courseID: courseID, withProgress: false)
                            await viewModelProgress.getCourseProgress(courseID: courseID)

                        }
                    }
                    
                    pageControlView
                        .padding(.bottom, 16)
                        .frame(alignment: .bottom)
                        .opacity(viewModelProgress.isLoading || viewModelContainer.isShowProgress ? 0 : 1)
                    
                }
                .onRightSwipeGesture {
                    viewModelContainer.router.back()
                }
                
                // MARK: - Error Alert
                if viewModelContainer.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModelContainer.errorMessage)
                    }
                    .padding(.bottom, viewModelContainer.isInternetAvaliable
                             ? 0 : OfflineSnackBarView.height)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModelContainer.errorMessage = nil
                        }
                    }
                }
                if viewModelProgress.isLoading || viewModelContainer.isShowProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.horizontal)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
        .sheet(isPresented: $showingDownloads) {
            DownloadsView(router: viewModelContainer.router, courseHelper: viewModelContainer.courseHelper)
        }
        .sheet(isPresented: $showingVideoDownloadQuality) {
            viewModelContainer.storage.userSettings.map {
                VideoDownloadQualityContainerView(
                    downloadQuality: $0.downloadQuality,
                    didSelect: viewModelContainer.update(downloadQuality:),
                    analytics: viewModelContainer.coreAnalytics,
                    router: viewModelContainer.router,
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
                await viewModelContainer.completeBlock(
                    chapterID: chapterID,
                    sequentialID: sequentialID,
                    verticalID: verticalID,
                    blockID: blockID
                )
            }
        }
    }
        
    // MARK: - Carousel Tab View
    private var carouselTabView: some View {
        TabView(selection: $infoPath) {
            carouselContent
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onChange(of: infoPath) { ind in
            withAnimation {
                viewModelContainer.tabBarIndex = ind
            }
        }
    }

    // MARK: - Carousel Content
    private var carouselContent: some View {
        ForEach(carouselSections.indices, id: \.self) { idx in
            carouselSections[idx]
                .tag(idx)
                .padding(.horizontal, 24)
                .padding(.top, 16)
        }
    }
    
    // MARK: - Page Control View
    private var pageControlView: some View {
        HStack(alignment: .center) {
            Button {
                withAnimation { infoPath = max(infoPath - 1, 0) }
            } label: {
                CoreAssets.chevronRight.swiftUIImage
                    .foregroundColor(infoPath == 0 ? .gray : Theme.Colors.textPrimary)
                    .scaleEffect(x: -1, y: 1)
            }
            .disabled(infoPath == 0)

            Spacer()
            
            PageControl(
                numberOfPages: carouselSections.count,
                currentPage: viewModelContainer.tabBarIndex
            )
            .frame(height: 8)
            .allowsHitTesting(false)
            .accessibilityIdentifier("whatsnew_pagecontrol")
            
            Spacer()
            
            Button {
                withAnimation { infoPath = min(infoPath + 1, carouselSections.count - 1) }
            } label: {
                CoreAssets.chevronRight.swiftUIImage
                    .foregroundColor(infoPath == carouselSections.count - 1 ? .gray : Theme.Colors.textPrimary)
            }
            .disabled(infoPath == carouselSections.count - 1)
            .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Download?
    @ViewBuilder
    private func downloadQualityBars(proxy: GeometryProxy) -> some View {
        if let courseVideosStructure = viewModelContainer.courseVideosStructure,
           viewModelContainer.hasVideoForDowbloads() {
            VStack(spacing: 0) {
                CourseVideoDownloadBarView(
                    courseStructure: courseVideosStructure,
                    courseViewModel: viewModelContainer,
                    onNotInternetAvaliable: {
                        viewModelContainer.errorMessage = CourseLocalization.Download.noWifiMessage
                    },
                    onTap: {
                        showingDownloads = true
                    },
                    analytics: viewModelContainer.analytics
                )
                viewModelContainer.userSettings.map {
                    VideoDownloadQualityBarView(
                        downloadQuality: $0.downloadQuality
                    ) {
                        if viewModelContainer.isAllDownloading() {
                            viewModelContainer.errorMessage = CourseLocalization.Download.changeQualityAlert
                            return
                        }
                        showingVideoDownloadQuality = true
                    }
                }
            }
        } else if viewModelContainer.courseVideosStructure == nil {
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
    
    // MARK: - Offline mode SnackBar
    private var offlineModeSnackBar: some View {
        return OfflineSnackBarView(
            connectivity: connectivity,
            reloadAction: {
                Task {
                    await viewModelProgress.getCourseProgress(courseID: courseID)
                }
            }
        )
    }
    
    // MARK: - Error Alert
    private var errorAlert: some View {
        VStack {
            Spacer()
            SnackBarView(message: viewModelProgress.errorMessage)
        }
        .padding(.bottom, connectivity.isInternetAvaliable
                 ? 0 : OfflineSnackBarView.height)
        .transition(.move(edge: .bottom))
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + Theme.Timeout.snackbarMessageLongTimeout
            ) {
                viewModelProgress.errorMessage = nil
            }
        }
    }
}

// MARK: - Preview
#if DEBUG
struct CourseOutlineAndProgressView_Previews: PreviewProvider {
    static var previews: some View {
        let vmProgress = CourseProgressViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity()
        )
        let vmOutline = CourseContainerViewModel(
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
        
        return PreviewContainer(
            viewModelContainer: vmOutline,
            viewModelProgress: vmProgress
        )
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

private struct PreviewContainer: View {
    @State private var selection: Int = 0
    @State private var coordinate: CGFloat = 0
    @State private var collapsed: Bool = false
    @State private var viewHeight: CGFloat = 0
    
    let viewModelContainer: CourseContainerViewModel
    let viewModelProgress: CourseProgressViewModel
    
    var body: some View {
        CourseOutlineAndProgressView(
            viewModelContainer: viewModelContainer,
            viewModelProgress: viewModelProgress,
            title: "Course title",
            courseID: "test",
            isVideo: false,
            selection: $selection,
            coordinate: $coordinate,
            collapsed: $collapsed,
            viewHeight: $viewHeight,
            dateTabIndex: 2,
            connectivity: Connectivity()
        )
        .loadFonts()
        .task {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await viewModelContainer.getCourseBlocks(courseID: "courseId")
                }
                group.addTask {
                    await viewModelContainer.getCourseDeadlineInfo(courseID: "courseId")
                }
            }
        }
    }
}
#endif
