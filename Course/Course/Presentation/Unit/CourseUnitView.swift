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
    
    public init(viewModel: CourseUnitViewModel,
                sectionName: String) {
        self.viewModel = viewModel
        self.sectionName = sectionName
        viewModel.loadIndex()
        viewModel.createLessonType()
        viewModel.nextTitles()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
                VStack(alignment: .center) {
                    NavigationBar(title: "",
                                         leftButtonAction: {
                        viewModel.router.back()
                        self.viewModel.killPlayer.toggle()
                    })

                    // MARK: - Page Body
                    VStack {
                        ZStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                if viewModel.connectivity.isInternetAvaliable
                                    || viewModel.lessonType != .video(videoUrl: "", blockID: "") {
                                switch viewModel.lessonType {
                                case let .youtube(url, blockID):
                                    VStack(alignment: .leading) {
                                        Text(viewModel.selectedLesson().displayName)
                                            .font(Theme.Fonts.titleLarge)
                                            .padding(.horizontal, 24)
                                        YouTubeVideoPlayer(url: url,
                                                           blockID: blockID,
                                                           courseID: viewModel.courseID,
                                                           languages: viewModel.languages())
                                        Spacer()

                                    }.background(CoreAssets.background.swiftUIColor)
                                case let .video(encodedUrl, blockID):
                                    Text(viewModel.selectedLesson().displayName)
                                        .font(Theme.Fonts.titleLarge)
                                        .padding(.horizontal, 24)
                                    EncodedVideoPlayer(
                                        url: viewModel.urlForVideoFileOrFallback(blockId: blockID, url: encodedUrl),
                                        blockID: blockID,
                                        courseID: viewModel.courseID,
                                        languages: viewModel.languages(),
                                        killPlayer: $viewModel.killPlayer
                                    )
                                    Spacer()
                                case .web(let url):
                                    VStack {
                                        WebUnitView(url: url, viewModel: Container.shared.resolve(WebUnitViewModel.self)!)
                                    }.background(Color.white)
                                    .contrast(1.08)
                                        .padding(.horizontal, -12)
                                        .roundedBackground(strokeColor: .clear, maxIpadWidth: .infinity)
                                    
                                case .unknown(let url):
                                    Spacer()
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
                                        StyledButton(CourseLocalization.NotAvaliable.button, action: {
                                            if let url = URL(string: url) {
                                               UIApplication.shared.open(url)
                                            }
                                        }).frame(width: 215).padding(.top, 40)
                                    }.padding(24)
                                    Spacer()
                                case let .discussion(blockID):
                                    let id = "course-v1:"
                                    + (viewModel.lessonID.find(from: "block-v1:", to: "+type").first ?? "")
                                    PostsView(courseID: id,
                                              topics: Topics(coursewareTopics: [],
                                                             nonCoursewareTopics: []),
                                              title: "", type: .courseTopics(topicID: blockID),
                                              viewModel: Container.shared.resolve(PostsViewModel.self)!,
                                              router: Container.shared.resolve(DiscussionRouter.self)!,
                                              showTopMenu: false)
                                    .onAppear {
                                        Task {
                                            await viewModel.blockCompletionRequest(blockID: blockID)
                                        }
                                    }
                                default:
                                    VStack {}
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
                                            self.viewModel.createLessonType()
                                            self.viewModel.killPlayer.toggle()
                                        }).frame(width: 100)
                                    }.frame(maxWidth: .infinity, maxHeight: .infinity)
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
                                            viewModel: viewModel
                                        ).padding(.vertical, 12)
                                            .frameLimit(sizePortrait: 420)
                                    .background(
                                        CoreAssets.background.swiftUIColor
                                            .ignoresSafeArea()
                                            .shadow(color: CoreAssets.shadowColor.swiftUIColor, radius: 4, y: -2)
                                    )
                            }.frame(maxWidth: .infinity)
                        }
                    }.frame(maxWidth: .infinity)
                        .onRightSwipeGesture {
                            viewModel.router.back()
                            self.viewModel.killPlayer.toggle()
                        }

                }
        }
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
            lessonID: "", courseID: "", blocks: blocks,
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock()
        ), sectionName: "")
    }
}
#endif





