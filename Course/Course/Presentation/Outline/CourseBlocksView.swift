//
//  CourseBlocksView.swift
//  Course
//
//  Created by  Stepanok Ivan on 04.02.2023.
//

import SwiftUI

import Core
import Kingfisher

public struct CourseBlocksView: View {
    
    private var title: String
    @ObservedObject
    private var viewModel: CourseBlocksViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    public init(title: String,
                viewModel: CourseBlocksViewModel) {
        self.title = title
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    NavigationBar(title: title,
                                  leftButtonAction: { viewModel.router.back() })

                    // MARK: - Page Body
                    ScrollView {
                        VStack(alignment: .leading) {
                            // MARK: - Lessons list
                            ForEach(viewModel.blocks, id: \.id) { block in
                                let index = viewModel.blocks.firstIndex(where: { $0.id == block.id })
                                Button(action: {
                                    viewModel.router.showCourseUnit(blockId: block.id,
                                                                    courseID: block.blockId,
                                                                    sectionName: title,
                                                                    blocks: viewModel.blocks)
                                }, label: {
                                    HStack {
                                        Group {
                                            if block.completion == 1 {
                                                CoreAssets.finished.swiftUIImage
                                            } else {
                                                block.type.image
                                            }
                                            Text(block.displayName)
                                                .multilineTextAlignment(.leading)
                                                .font(Theme.Fonts.titleMedium)
                                                .lineLimit(1)
                                                .frame(maxWidth: idiom == .pad
                                                       ? proxy.size.width * 0.5
                                                       : proxy.size.width * 0.6,
                                                       alignment: .leading)
                                        }.foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                        Spacer()
                                        if let state = viewModel.downloadState[block.id] {
                                            switch state {
                                            case .available:
                                                DownloadAvailableView()
                                                    .onTapGesture {
                                                        viewModel.onDownloadViewTap(blockId: block.id, state: state)
                                                    }
                                                    .onForeground {
                                                        viewModel.onForeground()
                                                    }
                                            case .downloading:
                                                DownloadProgressView()
                                                    .onTapGesture {
                                                        viewModel.onDownloadViewTap(blockId: block.id, state: state)
                                                    }
                                                    .onBackground {
                                                        viewModel.onBackground()
                                                    }
                                            case .finished:
                                                DownloadFinishedView()
                                                    .onTapGesture {
                                                        viewModel.onDownloadViewTap(blockId: block.id, state: state)
                                                    }
                                            }
                                        }
                                        Image(systemName: "chevron.right")
                                            .padding(.vertical, 8)
                                    }
                                }).padding(.horizontal, 36)
                                    .padding(.vertical, 14)
                                if index != viewModel.blocks.count - 1 {
                                    Divider()
                                        .frame(height: 1)
                                        .overlay(CoreAssets.cardViewStroke.swiftUIColor)
                                        .padding(.horizontal, 24)
                                }
                            }
                        }
                        Spacer(minLength: 84)
                    }.frameLimit()
                        .onRightSwipeGesture {
                            viewModel.router.back()
                        }
                }
            }
            
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
        .background(
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct CourseBlocksView_Previews: PreviewProvider {
    static var previews: some View {
        let blocks: [CourseBlock] = [
            CourseBlock(
                blockId: "block_1",
                id: "1",
                topicId: nil,
                graded: true,
                completion: 0,
                type: .html,
                displayName: "HTML Block",
                studentUrl: "",
                videoUrl: nil,
                youTubeUrl: nil
            ),
            CourseBlock(
                blockId: "block_2",
                id: "2",
                topicId: nil,
                graded: true,
                completion: 0,
                type: .problem,
                displayName: "Problem Block",
                studentUrl: "",
                videoUrl: nil,
                youTubeUrl: nil
            ),
            CourseBlock(
                blockId: "block_3",
                id: "3",
                topicId: nil,
                graded: true,
                completion: 1,
                type: .problem,
                displayName: "Completed Problem Block",
                studentUrl: "",
                videoUrl: nil,
                youTubeUrl: nil
            ),
            CourseBlock(
                blockId: "block_4",
                id: "4",
                topicId: nil,
                graded: true,
                completion: 0,
                type: .video,
                displayName: "Video Block",
                studentUrl: "",
                videoUrl: "some_data",
                youTubeUrl: nil
            )
        ]
        
        let viewModel = CourseBlocksViewModel(blocks: blocks,
                                              manager: DownloadManagerMock(),
                                              router: CourseRouterMock(),
                                              connectivity: Connectivity())
        
        return Group {
            CourseBlocksView(
                title: "Course title",
                viewModel: viewModel
            )
            .preferredColorScheme(.light)
            .previewDisplayName("CourseBlocksView Light")
            
            CourseBlocksView(
                title: "Course title",
                viewModel: viewModel
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseBlocksView Dark")
        }
        
    }
}
#endif
