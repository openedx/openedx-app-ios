//
//  LessonView.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import Foundation
import SwiftUI
import Core
import OEXFoundation
import Discussion
import Combine
import Theme

public struct CourseUnitView: View {
    
    @ObservedObject public var viewModel: CourseUnitViewModel
    @State private var showAlert: Bool = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    @State var offsetView: CGPoint = .zero
    @State var showDiscussion: Bool = false
    @Environment(\.isPresented) private var isPresented
    @Environment(\.isHorizontal) private var isHorizontal
    public let playerStateSubject = CurrentValueSubject<VideoPlayerState?, Never>(nil)
    
    // Dropdown parameters
    @State var showDropdown: Bool = false
    private let portraitTopSpacing: CGFloat = 60
    private let landscapeTopSpacing: CGFloat = 75
    
    @State private var videoURLs: [String: URL?] = [:]
    @State private var webURLs: [String: URL?] = [:]
    
    let isDropdownActive: Bool
    
    var sequenceTitle: String {
        let chapter = viewModel.chapters[viewModel.chapterIndex]
        let sequence = chapter.childs[viewModel.sequentialIndex]
        return sequence.displayName
    }
    
    var unitTitle: String {
        let chapter = viewModel.chapters[viewModel.chapterIndex]
        let sequence = chapter.childs[viewModel.sequentialIndex]
        let unit = sequence.childs[viewModel.verticalIndex]
        return unit.displayName
    }
    
    var isDropdownAvailable: Bool {
        viewModel.verticals.count > 1
    }
    
    var isHorizontalNavigation: Bool {
        viewModel.courseUnitProgressEnabled
    }
    
    public init(
        viewModel: CourseUnitViewModel,
        isDropdownActive: Bool = false
    ) {
        self.viewModel = viewModel
        self.isDropdownActive = isDropdownActive
        viewModel.loadIndex()
        viewModel.nextTitles()
    }
                
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            ZStack(alignment: .bottom) {
                GeometryReader { reader in
                    VStack(spacing: 0) {
                        topInset(reader: reader)
                        content(reader: reader)
                    }
                    .frame(maxWidth: .infinity)
                    .clipped()

                    // MARK: Progress Dots
                    if !viewModel.courseUnitProgressEnabled {
                        LessonProgressView(viewModel: viewModel)
                    }
                }
                // MARK: - Alert
                if showAlert {
                    ZStack(alignment: .bottomLeading) {
                        Spacer()
                        HStack(spacing: 6) {
                            CoreAssets.rotateDevice.swiftUIImage.renderingMode(.template)
                                .onAppear {
                                    alertMessage = CourseLocalization.Alert.rotateDevice
                                }
                            Text(alertMessage ?? "")
                        }.shadowCardStyle(bgColor: Theme.Colors.accentColor,
                                          textColor: Theme.Colors.white)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                alertMessage = nil
                                showAlert = false
                            }
                        }
                    }
                }
                courseNavigation
            }
            .onDisappear {
                if !isPresented {
                    playerStateSubject.send(VideoPlayerState.kill)
                }
            }
            if isDropdownActive && showDropdown {
                CourseUnitVerticalsDropdownView(
                    verticals: viewModel.verticals,
                    currentIndex: viewModel.verticalIndex,
                    offsetY: isHorizontal ? landscapeTopSpacing : portraitTopSpacing,
                    showDropdown: $showDropdown
                ) { vertical in
                    let data = VerticalData.dataFor(blockId: vertical.childs.first?.id, in: viewModel.chapters)
                    viewModel.route(to: data)
                    playerStateSubject.send(VideoPlayerState.kill)
                }
            }
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onRightSwipeGesture {
            playerStateSubject.send(VideoPlayerState.kill)
            viewModel.router.back()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                showDiscussion = viewModel.selectedLesson().type == .discussion
            }
        }
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
        .dropdownAnimation(isActive: isDropdownActive, value: showDropdown)
    }

    // MARK: - Content

    private func topInset(reader: GeometryProxy) -> some View {
        VStack { Theme.Colors.background }
            .frame(
                width: reader.size.width,
                height: isHorizontal ?
                (viewModel.courseUnitProgressEnabled ? 78 : 75) :
                (viewModel.courseUnitProgressEnabled ? 68 : 50)
            )
    }

    @ViewBuilder
    private func content(reader: GeometryProxy) -> some View {
        let alignment = UnitAlignment(horizontalAlignment: .top, verticalAlignment: .leading)
        let offset = viewOffset(for: viewModel.index, with: reader.size, insets: reader.safeAreaInsets)
        UnitStack(isVerticalNavigation: !isHorizontalNavigation, alignment: alignment, spacing: 0) {
            let data = Array(viewModel.verticals[viewModel.verticalIndex].childs.enumerated())
            ForEach(data, id: \.offset) { index, block in
                VStack(spacing: 0) {
                    if isDropdownActive {
                        videoTitle(block: block, width: reader.size.width)
                    }
                    contentView(for: block, index: index, reader: reader)
                }
                .frame(
                    width: isHorizontal ? reader.size.width - (isHorizontalNavigation ? 0 : 16) : reader.size.width,
                    height: reader.size.height
                )
                .padding(.trailing, isHorizontal && isHorizontalNavigation ? reader.safeAreaInsets.trailing : 0)
                .id(index)
            }
        }
        .offset(x: offset.x, y: offset.y)
        .animation(.easeInOut(duration: 0.2), value: viewModel.index)
        .clipped()
        .onChange(
            of: viewModel.index,
            perform: { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    showDiscussion = viewModel.selectedLesson().type == .discussion
                }
            }
        )
        .onReceive(
            NotificationCenter.default.publisher(
                for: NSNotification.blockCompletion
            )
        ) { _ in
            let blockID = viewModel.selectedLesson().id
            Task {
                await viewModel.blockCompletionRequest(blockID: blockID)
            }
        }
    }

    @ViewBuilder
    private func contentView(for block: CourseBlock, index: Int, reader: GeometryProxy) -> some View {
        switch LessonType.from(block, streamingQuality: viewModel.streamingQuality) {
        // MARK: YouTube
        case let .youtube(url, blockID):
            youtubeView(
                block: block,
                url: url,
                blockID: blockID,
                index: index,
                reader: reader
            )
        // MARK: Encoded Video
        case let .video(encodedUrl, blockID):
            videoView(
                block: block,
                encodedUrl: encodedUrl,
                blockID: blockID,
                index: index,
                reader: reader
            )
        // MARK: Web
        case let .web(url, injections, blockId, isDownloadable):
            webView(
                block: block,
                url: url,
                injections: injections,
                blockId: blockId,
                isDownloadable: isDownloadable,
                index: index,
                reader: reader
            )
        // MARK: Unknown
        case .unknown(let url):
            unknownView(
                block: block,
                url: url,
                index: index,
                reader: reader
            )
        // MARK: Discussion
        case let .discussion(blockID, blockKey, title):
            discussionView(
                block: block,
                blockID: blockID,
                blockKey: blockKey,
                title: title,
                index: index,
                reader: reader
            )
        }
    }

    @ViewBuilder
    private func youtubeView(
        block: CourseBlock,
        url: String,
        blockID: String,
        index: Int,
        reader: GeometryProxy
    ) -> some View {
        if index == viewModel.index {
            if viewModel.connectivity.isInternetAvaliable {
                YouTubeView(
                    name: block.displayName,
                    url: url,
                    courseID: viewModel.courseID,
                    blockID: blockID,
                    playerStateSubject: playerStateSubject,
                    languages: block.subtitles ?? [],
                    isOnScreen: index == viewModel.index
                )
                .frameLimit(width: reader.size.width)
                
                if !isHorizontal {
                    Spacer(minLength: 150)
                }
            } else {
                OfflineContentView(
                    isDownloadable: false
                )
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func videoView(
        block: CourseBlock,
        encodedUrl: String,
        blockID: String,
        index: Int,
        reader: GeometryProxy
    ) -> some View {
        Group {
            if index == viewModel.index {
                if viewModel.connectivity.isInternetAvaliable {
                    EncodedVideoView(
                        name: block.displayName,
                        url: URL(string: encodedUrl),
                        courseID: viewModel.courseID,
                        blockID: blockID,
                        playerStateSubject: playerStateSubject,
                        languages: block.subtitles ?? [],
                        isOnScreen: index == viewModel.index
                    )
                    .padding(.top, 5)
                    .frameLimit(width: reader.size.width)
                    
                    if !isHorizontal {
                        Spacer(minLength: 150)
                    }
                } else if let offlineURL = videoURLs[blockID] {
                    EncodedVideoView(
                        name: block.displayName,
                        url: offlineURL,
                        courseID: viewModel.courseID,
                        blockID: blockID,
                        playerStateSubject: playerStateSubject,
                        languages: block.subtitles ?? [],
                        isOnScreen: index == viewModel.index
                    )
                    .padding(.top, 5)
                    .frameLimit(width: reader.size.width)
                    
                    if !isHorizontal {
                        Spacer(minLength: 150)
                    }
                } else {
                    OfflineContentView(
                        isDownloadable: true
                    )
                }
            } else {
                EmptyView()
            }
        }
        .onAppear {
            Task {
                if let url = await viewModel.urlForVideoFileOrFallback(
                    blockId: blockID,
                    url: encodedUrl
                ) {
                    videoURLs[blockID] = url
                }
            }
        }
    }

    @ViewBuilder
    private func webView(
        block: CourseBlock,
        url: String,
        injections: [WebviewInjection],
        blockId: String,
        isDownloadable: Bool,
        index: Int,
        reader: GeometryProxy
    ) -> some View {
        Group {
            if index >= viewModel.index - 1 && index <= viewModel.index + 1 {
                if viewModel.connectivity.isInternetAvaliable {
                    WebView(
                        url: url,
                        localUrl: nil,
                        injections: injections,
                        blockID: block.id,
                        roundedBackgroundEnabled: !viewModel.courseUnitProgressEnabled
                    )
                } else if let offlineURL = webURLs[blockId] {
                    WebView(
                        url: url,
                        localUrl: offlineURL?.absoluteString,
                        injections: injections,
                        blockID: block.id,
                        roundedBackgroundEnabled: !viewModel.courseUnitProgressEnabled
                    )
                } else {
                    OfflineContentView(
                        isDownloadable: isDownloadable
                    )
                }
            } else {
                EmptyView()
            }
        }
        .onAppear {
            Task {
                if let offlineURL = await viewModel.urlForOfflineContent(blockId: blockId) {
                    webURLs[blockId] = offlineURL
                }
            }
        }
    }

    @ViewBuilder
    private func unknownView(
        block: CourseBlock,
        url: String,
        index: Int,
        reader: GeometryProxy
    ) -> some View {
        if index >= viewModel.index - 1 && index <= viewModel.index + 1 {
            if viewModel.connectivity.isInternetAvaliable {
                NotAvailableOnMobileView(url: url)
                    .frameLimit(width: reader.size.width)
            } else {
                OfflineContentView(
                    isDownloadable: false
                )
            }
        } else {
            EmptyView()
        }
    }

    @ViewBuilder
    private func discussionView(
        block: CourseBlock,
        blockID: String,
        blockKey: String,
        title: String,
        index: Int,
        reader: GeometryProxy
    ) -> some View {
        if index >= viewModel.index - 1 && index <= viewModel.index + 1 {
            if viewModel.connectivity.isInternetAvaliable {
                VStack {
                    if showDiscussion {
                        DiscussionView(
                            id: viewModel.courseID,
                            blockID: blockID,
                            blockKey: blockKey,
                            title: title,
                            viewModel: viewModel
                        )
                        Spacer(minLength: 100)
                    } else {
                        VStack {
                            Color.clear
                        }
                    }
                }
                // No need for iPad paddings here because they were added
                // to PostsView that is placed inside DiscussionView
            } else {
                FullScreenErrorView(type: .noInternet)
            }
        } else {
            EmptyView()
        }
    }

    private func viewOffset(for index: Int, with size: CGSize, insets: EdgeInsets) -> CGPoint {
        let rightInset = (isHorizontal ? insets.trailing * CGFloat(index) : 0)
        let x: CGFloat = isHorizontalNavigation ? -(size.width * CGFloat(index) + rightInset) : 0
        let y: CGFloat = isHorizontalNavigation ? 0 : -(size.height * CGFloat(index))
        return CGPoint(x: x, y: y)
    }
    
    private func videoTitle(block: CourseBlock, width: CGFloat) -> some View {
        HStack {
            if block.type == .video {
                let title = block.displayName
                Text(title)
                    .lineLimit(1)
                    .font(Theme.Fonts.titleLarge)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 20)
                Spacer()
            }
        }
        .frameLimit(width: width)
    }

    // MARK: - Course Navigation

    private var courseNavigation: some View {
        VStack(spacing: 0) {
            ZStack {
                if !isDropdownActive {
                    GeometryReader { reader in
                        VStack {
                            HStack {
                                let currentBlock = viewModel.verticals[viewModel.verticalIndex]
                                    .childs[viewModel.index]
                                if currentBlock.type == .video {
                                    let title = currentBlock.displayName
                                    Text(title)
                                        .lineLimit(1)
                                        .font(Theme.Fonts.titleLarge)
                                        .foregroundStyle(Theme.Colors.textPrimary)
                                        .padding(.leading, isHorizontal ? 30 : 42)
                                        .padding(.top, isHorizontal ? 14 : 2)
                                    Spacer()
                                }
                            }
                            .frame(maxWidth: isHorizontal ? reader.size.width * 0.5 : nil)
                            Spacer()
                        }
                    }
                }
                navigationBar
                courseNavigationView
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var navigationBar: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                NavigationBar(
                    title: isDropdownActive ? sequenceTitle : "",
                    leftButtonAction: {
                        viewModel.router.back()
                        playerStateSubject.send(VideoPlayerState.kill)
                    }
                )
                .padding(.top, isHorizontal ? 10 : 0)
                .padding(.leading, isHorizontal ? -16 : 0)

                if isDropdownActive {
                    CourseUnitDropDownTitle(
                        title: unitTitle,
                        isAvailable: isDropdownAvailable,
                        showDropdown: $showDropdown
                    )
                    .padding(.bottom, 0)
                    .padding(.horizontal, 48)
                }
            }
            .background(Theme.Colors.background)
            .padding(.trailing, isHorizontal ? 215 : 0)

            if viewModel.courseUnitProgressEnabled {
                LessonLineProgressView(viewModel: viewModel)
                    .padding(.top, 4)
            }
            Spacer()
        }
    }

    private var courseNavigationView: some View {
        HStack(alignment: .center) {
            if isHorizontal {
                Spacer()
            }
            VStack {
                if !isHorizontal {
                    Spacer()
                }
                CourseNavigationView(
                    viewModel: viewModel,
                    playerStateSubject: playerStateSubject
                )
                if isHorizontal {
                    Spacer()
                }
            }
            .padding(.bottom, isHorizontal ? 0 : 50)
            .padding(.top, isHorizontal ? 12 : 0)
        }
    }
}

#if DEBUG
struct CourseUnitView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks = [
            CourseBlock(
                blockId: "1",
                id: "1",
                courseId: "123",
                topicId: "1",
                graded: false,
                due: Date(),
                completion: 0,
                type: .video,
                displayName: "Lesson 1",
                studentUrl: "",
                webUrl: "",
                encodedVideo: nil,
                multiDevice: true,
                offlineDownload: nil
            ),
            CourseBlock(
                blockId: "2",
                id: "2",
                courseId: "123",
                topicId: "2",
                graded: false,
                due: Date(),
                completion: 0,
                type: .video,
                displayName: "Lesson 2",
                studentUrl: "2",
                webUrl: "2",
                encodedVideo: nil,
                multiDevice: false,
                offlineDownload: nil
            ),
            CourseBlock(
                blockId: "3",
                id: "3",
                courseId: "123",
                topicId: "3",
                graded: false,
                due: Date(),
                completion: 0,
                type: .unknown,
                displayName: "Lesson 3",
                studentUrl: "3",
                webUrl: "3",
                encodedVideo: nil,
                multiDevice: true,
                offlineDownload: nil
            ),
            CourseBlock(
                blockId: "4",
                id: "4",
                courseId: "123",
                topicId: "4",
                graded: false,
                due: Date(),
                completion: 0,
                type: .unknown,
                displayName: "4",
                studentUrl: "4",
                webUrl: "4",
                encodedVideo: nil,
                multiDevice: false,
                offlineDownload: nil
            )
        ]
        
        let chapters = [
            CourseChapter(
                blockId: "0",
                id: "0",
                displayName: "0",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "5",
                        id: "5",
                        displayName: "5",
                        type: .sequential,
                        completion: 0,
                        childs: [
                            CourseVertical(
                                blockId: "6",
                                id: "6",
                                courseId: "123",
                                displayName: "6",
                                type: .vertical,
                                completion: 0,
                                childs: blocks,
                                webUrl: ""
                            )
                        ],
                        sequentialProgress: SequentialProgress(
                            assignmentType: "Advanced Assessment Tools",
                            numPointsEarned: 1,
                            numPointsPossible: 3
                        ),
                        due: Date()
                    )
                ]
            ),
            CourseChapter(
                blockId: "2",
                id: "2",
                displayName: "2",
                type: .chapter,
                childs: [
                    CourseSequential(
                        blockId: "3",
                        id: "3",
                        displayName: "3",
                        type: .sequential,
                        completion: 0,
                        childs: [
                            CourseVertical(
                                blockId: "4",
                                id: "4",
                                courseId: "1",
                                displayName: "4",
                                type: .vertical,
                                completion: 0,
                                childs: blocks,
                                webUrl: ""
                            )
                        ],
                        sequentialProgress: SequentialProgress(
                            assignmentType: "Basic Assessment Tools",
                            numPointsEarned: 1,
                            numPointsPossible: 3
                        ),
                        due: Date()
                    )
                ])
        ]
        
        return CourseUnitView(viewModel: CourseUnitViewModel(
            lessonID: "",
            courseID: "",
            courseName: "courseName",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: CourseInteractor.mock,
            config: ConfigMock(),
            router: CourseRouterMock(),
            analytics: CourseAnalyticsMock(),
            connectivity: Connectivity(),
            storage: CourseStorageMock(),
            manager: DownloadManagerMock()
        ))
    }
}
#endif
