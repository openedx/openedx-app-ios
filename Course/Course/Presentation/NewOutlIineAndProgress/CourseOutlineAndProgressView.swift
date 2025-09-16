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

    private var carouselSections: [AnyView] {
        var sections: [AnyView] = []

        if viewModelProgress.courseProgress != nil {
            sections.append(
                AnyView(
                    CourseCompletionCarouselSlideView(
                        viewModelProgress: viewModelProgress,
                        viewModelContainer: viewModelContainer,
                        isVideo: isVideo,
                        idiom: UIDevice.current.userInterfaceIdiom
                    ) { proxy in
                        downloadQualityBars(proxy: proxy)
                    }
                )
            )

            sections.append(
                AnyView(
                    CourseVideoCarouselSlideView(
                        viewModelProgress: viewModelProgress,
                        viewModelContainer: viewModelContainer
                    )
                )
            )
        }

        sections.append(
            AnyView(
                CourseAssignmentsCarouselSlideView(
                    viewModelProgress: viewModelProgress,
                    viewModelContainer: viewModelContainer
                )
            )
        )

        sections.append(
            AnyView(
                CourseGradeCarouselSlideView(
                    viewModelProgress: viewModelProgress,
                    viewModelContainer: viewModelContainer
                )
            )
        )

        return sections
    }
    
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var showingDownloads: Bool = false
    @State private var showingVideoDownloadQuality: Bool = false
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
            if viewModelProgress.isLoading || viewModelContainer.isShowRefresh {
                HStack(alignment: .center) {
                    ProgressBar(size: 40, lineWidth: 8)
                        .padding(.top, 200)
                        .padding(.horizontal)
                }
            } else {
            GeometryReader { _ in
                VStack(alignment: .center) {
                    // MARK: - Page Body
                        ScrollView {
                            VStack(spacing: 0) {
                                DynamicOffsetView(
                                    coordinate: $coordinate,
                                    collapsed: $collapsed,
                                    viewHeight: $viewHeight
                                )

                                VStack(alignment: .leading) {

                                    Spacer()

                                    if let continueWith = viewModelContainer.continueWith,
                                       let courseStructure = viewModelContainer.courseStructure {
                                        let chapter = courseStructure.childs[continueWith.chapterIndex]
                                        let sequential = chapter.childs[continueWith.sequentialIndex]
                                        let continueUnit = sequential.childs[continueWith.verticalIndex]

                                        UnitButtonView(
                                            type: .continueLessonCustom(
                                                continueUnit.displayName
                                            ),
                                            action: {
                                                viewModelContainer.openLastVisitedBlock()
                                            })
                                        .padding(.horizontal, 24)
                                        .padding(.top, 16)

                                    }

                                    if let courseDeadlineInfo = viewModelContainer.courseDeadlineInfo,
                                    let verifiedUpgradeLink = courseDeadlineInfo.datesBannerInfo.verifiedUpgradeLink {
                                        upgradeNowBanner(url: verifiedUpgradeLink)
                                            .padding(.horizontal, 24)
                                            .padding(.bottom, 16)
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
                                        await viewModelContainer
                                            .getCourseBlocks(courseID: courseID, withProgress: false)
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
                            .padding(.bottom, 10)
                            .frame(alignment: .bottom)
                            .opacity(viewModelProgress.isLoading || viewModelContainer.isShowProgress ? 0 : 1)

                            .onRightSwipeGesture {
                                viewModelContainer.router.back()
                            }
                    }

                    OfflineSnackBarView(
                        connectivity: connectivity,
                        reloadAction: {
                            await withTaskGroup(of: Void.self) { group in
                                group.addTask {
                                    await viewModelContainer.getCourseBlocks(courseID: courseID, withProgress: false)
                                }
                                group.addTask {
                                    await viewModelContainer
                                        .getCourseDeadlineInfo(courseID: courseID, withProgress: false)
                                }

                                group.addTask {
                                    await viewModelProgress.getCourseProgress(courseID: courseID)
                                }
                            }
                        }
                    )

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
            VStack {
                carouselSections[idx]
                Spacer()
            }
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
                    .flipsForRightToLeftLayoutDirection(true)
                    .accessibilityLabel(
                        infoPath == 0 ?
                        CourseLocalization.Accessibility.Carousel.lastSlideButton :
                            CourseLocalization.Accessibility.Carousel.previousSlideButton
                    )
            }
            .disabled(infoPath == 0)

            Spacer()
            
            PageControl(
                numberOfPages: carouselSections.count,
                currentPage: viewModelContainer.tabBarIndex
            )
            .frame(height: 8)
            .allowsHitTesting(false)

            Spacer()
            
            Button {
                withAnimation { infoPath = min(infoPath + 1, carouselSections.count - 1) }
            } label: {
                CoreAssets.chevronRight.swiftUIImage
                    .foregroundColor(infoPath == carouselSections.count - 1 ? .gray : Theme.Colors.textPrimary)
                    .accessibilityLabel(
                        infoPath == carouselSections.count - 1 ?
                        CourseLocalization.Accessibility.Carousel.lastSlideButton :
                            CourseLocalization.Accessibility.Carousel.nextSlideButton
                    )
            }
            .flipsForRightToLeftLayoutDirection(true)
            .disabled(infoPath == carouselSections.count - 1)
            .frame(width: 24, height: 24)
        }
        .padding(.horizontal, 24)
    }
    
    // MARK: - Download
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

    // MARK: - Upgrade Now Banner
    private func upgradeNowBanner(url: String) -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                CoreAssets.lockIcon.swiftUIImage
                    .renderingMode(.template)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .padding(.trailing, 8)

                VStack(alignment: .leading) {
                    Text(CourseLocalization.CourseCarousel.upgradeNowBody)
                        .font(Theme.Fonts.bodySmall)
                        .foregroundStyle(Theme.Colors.textPrimary)

                    if let url = URL(string: url) {
                        Link(destination: url) {
                            Text(CourseLocalization.CourseCarousel.upgradeNowButton)
                                .underline()
                                .font(Theme.Fonts.bodySmall)
                                .foregroundStyle(Theme.Colors.textPrimary)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
        .padding(16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(style: .init(lineWidth: 1, lineCap: .round, lineJoin: .round, miterLimit: 1))
                .foregroundColor(Theme.Colors.cardViewStroke)
        )
    }
}

// MARK: - Preview
#if DEBUG

#Preview {
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
