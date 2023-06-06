//
//  LessonView.swift
//  CourseDetails
//
//  Created by  Stepanok Ivan on 05.10.2022.
//

import Foundation
import SwiftUI
import Core
import Discussion
import Swinject
import Introspect
import Combine

public struct CourseUnitView: View {
    
    @ObservedObject private var viewModel: CourseUnitViewModel
    @State private var showAlert: Bool = false
    @State var alertMessage: String? {
        didSet {
            withAnimation {
                showAlert = alertMessage != nil
            }
        }
    }
    @State var offsetView: CGFloat = 0
    @State var showDiscussion: Bool = false
    
    private let sectionName: String
    public let playerStateSubject = CurrentValueSubject<VideoPlayerState?, Never>(nil)
    
    public init(viewModel: CourseUnitViewModel,
                sectionName: String) {
        self.viewModel = viewModel
        self.sectionName = sectionName
        viewModel.loadIndex()
        viewModel.nextTitles()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page Body
            ZStack(alignment: .bottom) {
                GeometryReader { reader in
                    VStack(spacing: 0) {
                        if viewModel.connectivity.isInternetAvaliable {
                            NavigationBar(title: "",
                                          leftButtonAction: {
                                viewModel.router.back()
                                playerStateSubject.send(VideoPlayerState.kill)
                            }).padding(.top, 50)
                            
//                            ScrollViewReader { scroll in
//                                ScrollView(.vertical) {
                            LazyVStack(spacing: 0) {
                                ForEach(Array(viewModel.verticals[viewModel.verticalIndex]
                                    .childs.enumerated()), id: \.offset) { index, block in
                                        VStack(spacing: 0) {
                                            switch LessonType.from(block) {
                                                // MARK: YouTube
                                            case let .youtube(url, blockID):
                                                YouTubeView(index: index, url: url,
                                                            blockID: blockID,
                                                            viewModel: viewModel,
                                                            playerStateSubject: playerStateSubject,
                                                            isOnScreen: index == viewModel.index)
                                                Spacer(minLength: 100)
                                                
                                                // MARK: Encoded Video
                                            case let .video(encodedUrl, blockID):
                                                if index == viewModel.index {
                                                    EncodedVideoView(index: index,
                                                                     encodedUrl: encodedUrl,
                                                                     blockID: blockID,
                                                                     viewModel: viewModel,
                                                                     playerStateSubject: playerStateSubject,
                                                                     isOnScreen: true)
                                                    Spacer(minLength: 100)
                                                }
                                                
                                                // MARK: Web
                                            case .web(let url):
                                                WebView(url: url,
                                                        viewModel: viewModel)
                                                
                                                // MARK: Unknown
                                            case .unknown(let url):
                                                UnknownView(url: url,
                                                            viewModel: viewModel)
                                                Spacer()
                                                // MARK: Discussion
                                            case let .discussion(blockID, blockKey, title):
                                                VStack {
                                                    if showDiscussion {
                                                        DiscussionView(id: viewModel.id,
                                                                       blockID: blockID,
                                                                       blockKey: blockKey,
                                                                       title: title,
                                                                       viewModel: viewModel)
                                                        Spacer(minLength: 100)
                                                    } else {
                                                        DiscussionView(id: viewModel.id,
                                                                       blockID: blockID,
                                                                       blockKey: blockKey,
                                                                       title: title,
                                                                       viewModel: viewModel)
                                                        .drawingGroup()
                                                        Spacer(minLength: 100)
                                                    }
                                                }
                                            }
                                        }
                                        
                                        .frame(height: reader.size.height)
                                        .id(index)
                                    }
                            }.frameLimit()
                                .offset(y: offsetView)
                                .clipped()
                                .onChange(of: viewModel.index, perform: { index in
                                    DispatchQueue.main.async {
                                        withAnimation(Animation.easeInOut(duration: 0.2)) {
//                                                scroll.scrollTo(index, anchor: .top)
                                            offsetView = -(reader.size.height * CGFloat(index))
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                                                showDiscussion = viewModel.selectedLesson().type == .discussion
                                            }
                                        }
                                    }
                                    
                                })
//                                }.introspectScrollView(customize: { sv in
//                                    sv.isScrollEnabled = false
//                                    sv.layer.cornerRadius = 24
//                                    sv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//                                })
//                            }
                        } else {
                            
                            // MARK: No internet view
                            VStack(spacing: 28) {
                                Image(systemName: "wifi").resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                                Text(CourseLocalization.Error.noInternet)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                UnitButtonView(type: .reload, action: {
                                    playerStateSubject.send(VideoPlayerState.kill)
                                }).frame(width: 100)
                            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }.frame(maxWidth: .infinity)
                        .clipped()
                    
                    // MARK: Progress Dots
                    if viewModel.verticals[viewModel.verticalIndex].childs.count > 1 {
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
                        }.shadowCardStyle(bgColor: CoreAssets.accentColor.swiftUIColor,
                                          textColor: .white)
                        .transition(.move(edge: .bottom))
                        .onAppear {
                            doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                                alertMessage = nil
                                showAlert = false
                            }
                        }
                    }
                }
                
                // MARK: - Course Navigation
                VStack {
                    NavigationBar(title: "",
                                  leftButtonAction: {
                        viewModel.router.back()
                        playerStateSubject.send(VideoPlayerState.kill)
                    }).padding(.top, 50)
                    Spacer()
                    CourseNavigationView(
                        sectionName: sectionName,
                        viewModel: viewModel,
                        playerStateSubject: playerStateSubject
                    ).padding(.bottom, 30)
                        .frameLimit(sizePortrait: 420)
                }.frame(maxWidth: .infinity)
                    .onRightSwipeGesture {
                        playerStateSubject.send(VideoPlayerState.kill)
                        viewModel.router.back()
                    }
            }
        }.ignoresSafeArea()
            .background(
                CoreAssets.background.swiftUIColor
                    .ignoresSafeArea()
            )
    }
}

#if DEBUG
//swiftlint:disable all
struct CourseUnitView_Previews: PreviewProvider {
    static var previews: some View {
        
        let blocks = [
            CourseBlock(blockId: "1",
                        id: "1",
                        topicId: "1",
                        graded: false,
                        completion: 0,
                        type: .video,
                        displayName: "Lesson 1",
                        studentUrl: "",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "2",
                        id: "2",
                        topicId: "2",
                        graded: false,
                        completion: 0,
                        type: .video,
                        displayName: "Lesson 2",
                        studentUrl: "2",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "3",
                        id: "3",
                        topicId: "3",
                        graded: false,
                        completion: 0,
                        type: .unknown,
                        displayName: "Lesson 3",
                        studentUrl: "3",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "4",
                        id: "4",
                        topicId: "4",
                        graded: false,
                        completion: 0,
                        type: .unknown,
                        displayName: "4",
                        studentUrl: "4",
                        videoUrl: nil,
                        youTubeUrl: nil),
        ]
        
        let chapters = [
            CourseChapter(
            blockId: "0",
            id: "0",
            displayName: "0",
            type: .chapter,
            childs: [
                CourseSequential(blockId: "5",
                                 id: "5",
                                 displayName: "5",
                                 type: .sequential,
                                 completion: 0,
                                 childs: [
                                    CourseVertical(blockId: "6", id: "6",
                                                   displayName: "6",
                                                   type: .vertical,
                                                   completion: 0,
                                                   childs: blocks)
                                 ])
                
            ]),
            CourseChapter(
            blockId: "2",
            id: "2",
            displayName: "2",
            type: .chapter,
            childs: [
                CourseSequential(blockId: "3",
                                 id: "3",
                                 displayName: "3",
                                 type: .sequential,
                                 completion: 0,
                                 childs: [
                                    CourseVertical(blockId: "4", id: "4",
                                                   displayName: "4",
                                                   type: .vertical,
                                                   completion: 0,
                                                   childs: blocks)
                                 ])
                
            ])
            ]
                
        return CourseUnitView(viewModel: CourseUnitViewModel(
            lessonID: "",
            courseID: "",
            id: "1",
            chapters: chapters,
            chapterIndex: 0,
            sequentialIndex: 0,
            verticalIndex: 0,
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock()
        ), sectionName: "")
    }
}
#endif

struct QuickView<Content: View>: View  {
    
    @State var isOnScreen: Bool
    var content: () -> Content
    
    var body: some View {
        VStack {
            if !isOnScreen {
                QuickRender(isOnScreen: $isOnScreen) {
                    content()
                }
            } else {
                content()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isOnScreen = true
            }
        }
    }
}

struct QuickRender<Content: View>: View {
    @Binding var isOnScreen: Bool
    var content: () -> Content
    
    var body: some View {
        ZStack {
            content()
        }
        .drawingGroup()
    }
}
