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
            
            // MARK: - Page name
            VStack(alignment: .center, spacing: 0) {
                
                // MARK: - Page Body
                ZStack(alignment: .bottom) {
                    GeometryReader { reader in
                        VStack(spacing: 0) {
                            if viewModel.connectivity.isInternetAvaliable {
                                ScrollViewReader { scroll in
                                    ScrollView(.vertical) {
                                        LazyVStack(spacing: 0) {
                                            ForEach(Array(viewModel.verticals[viewModel.selectedVertical]
                                                .childs.enumerated()), id: \.offset) { index, block in
                                                    if index >= viewModel.index-1 && index <= viewModel.index+1 {
                                                        VStack(spacing: 0) {
                                                            NavigationBar(title: "",
                                                                          leftButtonAction: {
                                                                viewModel.router.back()
                                                                playerStateSubject.send(VideoPlayerState.kill)
                                                            }).padding(.top, 50)
                                                            switch LessonType.from(block) {
                                                            case let .youtube(url, blockID):
                                                                VStack(alignment: .leading, spacing: 8) {
                                                                    VStack(alignment: .leading) {
                                                                        Text(viewModel.verticals[viewModel.selectedVertical]
                                                                            .childs[index].displayName)
                                                                            .font(Theme.Fonts.titleLarge)
                                                                            .padding(.horizontal, 24)
                                                                        let vm = Container.shared.resolve(
                                                                            YouTubeVideoPlayerViewModel.self,
                                                                            arguments: url, blockID,
                                                                            viewModel.courseID,
                                                                            viewModel.languages(),
                                                                            playerStateSubject)!
                                                                        YouTubeVideoPlayer(viewModel: vm)
                                                                        Spacer()
                                                                    }.background(CoreAssets.background.swiftUIColor)
                                                                }
                                                                Spacer(minLength: 100)
                                                            case let .video(encodedUrl, blockID):
                                                                VStack(alignment: .leading, spacing: 8) {
                                                                    Text(viewModel.verticals[viewModel.selectedVertical]
                                                                        .childs[index].displayName)
                                                                        .font(Theme.Fonts.titleLarge)
                                                                        .padding(.horizontal, 24)
                                                                    
                                                                    let vm = Container.shared.resolve(
                                                                        EncodedVideoPlayerViewModel.self,
                                                                        arguments: viewModel.languages(),
                                                                        playerStateSubject)!
                                                                    
                                                                    EncodedVideoPlayer(
                                                                        url: viewModel.urlForVideoFileOrFallback(
                                                                            blockId: blockID, url: encodedUrl),
                                                                        blockID: blockID,
                                                                        courseID: viewModel.courseID,
                                                                        viewModel: vm
                                                                    )
                                                                    Spacer(minLength: 100)
                                                                }
                                                            case .web(let url):
                                                                RoundedRectangle(cornerRadius: 30)
                                                                    .frame(height: 60)
                                                                    .foregroundColor(.white)
                                                                    .padding(.bottom, -30)
                                                                VStack {
                                                                    WebUnitView(url: url,
                                                                                viewModel: Container.shared
                                                                        .resolve(WebUnitViewModel.self)!)
                                                                    
                                                                    Spacer(minLength: 100)
                                                                }.background(Color.white)
                                                                    .contrast(1.08)
                                                                    .padding(.horizontal, -12)
                                                                    .roundedBackground(strokeColor: .clear,
                                                                                       maxIpadWidth: .infinity)
                                                            case .unknown(let url):
                                                                VStack(spacing: 0) {
                                                                    CoreAssets.notAvaliable.swiftUIImage
                                                                    Text(CourseLocalization.NotAvaliable.title)
                                                                        .font(Theme.Fonts.titleLarge)
                                                                        .multilineTextAlignment(.center)
                                                                        .frame(maxWidth: .infinity)
                                                                        .padding(.top, 40)
                                                                    Text(CourseLocalization.NotAvaliable.description)
                                                                        .font(Theme.Fonts.bodyLarge)
                                                                        .multilineTextAlignment(.center)
                                                                        .frame(maxWidth: .infinity)
                                                                        .padding(.top, 12)
                                                                    StyledButton(CourseLocalization.NotAvaliable.button,
                                                                                 action: {
                                                                        if let url = URL(string: url) {
                                                                            UIApplication.shared.open(url)
                                                                        }
                                                                    }).frame(width: 215).padding(.top, 40)
                                                                }.padding(24)
                                                                Spacer()
                                                            case let .discussion(blockID, title):
                                                                let id = "course-v1:"
                                                                + (viewModel.lessonID.find(from: "block-v1:",
                                                                                           to: "+type").first ?? "")
                                                                PostsView(courseID: id,
                                                                          currentBlockID: blockID,
                                                                          topics: Topics(coursewareTopics: [],
                                                                                         nonCoursewareTopics: []),
                                                                          title: title,
                                                                          type: .courseTopics(topicID: blockID),
                                                                          viewModel: Container.shared
                                                                    .resolve(PostsViewModel.self)!,
                                                                          router: Container.shared
                                                                    .resolve(DiscussionRouter.self)!,
                                                                          showTopMenu: false)
                                                                .onAppear {
                                                                    Task {
                                                                        await viewModel
                                                                            .blockCompletionRequest(blockID: blockID)
                                                                    }
                                                                }
                                                                Spacer(minLength: 100)
                                                            }
                                                        }
                                                        .frame(height: reader.size.height + 10)
                                                        .id(index)
                                                    }
                                                }
                                        }
                                        .onChange(of: viewModel.index, perform: { index in
                                            withAnimation {
                                                scroll.scrollTo(index, anchor: .top)
                                            }
                                        })
                                    }.introspectScrollView(customize: { sv in
                                        sv.isScrollEnabled = false
                                    })
                                    .onAppear {
                                        withAnimation {
                                            scroll.scrollTo(viewModel.index, anchor: .top)
                                        }
                                    }
                                }
                            } else {
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
                        if viewModel.verticals[viewModel.selectedVertical].childs.count > 1 {
                            HStack {
                                Spacer()
                                VStack {
                                    Spacer()
                                    let childs = viewModel.verticals[viewModel.selectedVertical].childs
                                    ForEach(Array(childs.enumerated()), id: \.offset) { index, block in
                                        let selected = viewModel.verticals[viewModel.selectedVertical].childs[index]
                                        Circle().frame(width: selected == viewModel.selectedLesson()
                                                       ? 5
                                                       : 3,
                                                       height: selected == viewModel.selectedLesson()
                                                       ? 5
                                                       : 3)
                                        .foregroundColor(selected == viewModel.selectedLesson()
                                                         ? .accentColor
                                                         : CoreAssets.textSecondary.swiftUIColor)
                                    }
                                    Spacer()
                                }.padding(.trailing, 6)
                            }
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
                    CourseNavigationView(
                        sectionName: sectionName,
                        viewModel: viewModel,
                        playerStateSubject: playerStateSubject
                    ).padding(.bottom, 30)
                        .frameLimit(sizePortrait: 420)
                }
            }.frame(maxWidth: .infinity)
                .onRightSwipeGesture {
                    playerStateSubject.send(VideoPlayerState.kill)
                    viewModel.router.back()
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
struct LessonView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks = [
            CourseBlock(blockId: "1",
                        id: "1",
                        topicId: "1",
                        graded: false,
                        completion: 0,
                        type: .vertical,
                        displayName: "Lesson 1",
                        studentUrl: "1",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "2",
                        id: "2",
                        topicId: "2",
                        graded: false,
                        completion: 0,
                        type: .chapter,
                        displayName: "Lesson 2",
                        studentUrl: "2",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "3",
                        id: "3",
                        topicId: "3",
                        graded: false,
                        completion: 0,
                        type: .vertical,
                        displayName: "Lesson 3",
                        studentUrl: "3",
                        videoUrl: nil,
                        youTubeUrl: nil),
            CourseBlock(blockId: "4",
                        id: "4",
                        topicId: "4",
                        graded: false,
                        completion: 0,
                        type: .vertical,
                        displayName: "4",
                        studentUrl: "4",
                        videoUrl: nil,
                        youTubeUrl: nil),
        ]
        
        return CourseUnitView(viewModel: CourseUnitViewModel(
            lessonID: "",
            courseID: "",
            verticals: [],
            selectedVertical: 1,
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock()
        ), sectionName: "")
    }
}
#endif
