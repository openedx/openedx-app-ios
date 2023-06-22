//
//  CourseVerticalView.swift
//  Course
//
//  Created by  Stepanok Ivan on 12.12.2022.
//

import SwiftUI

import Core
import Kingfisher

public struct CourseVerticalView: View {
    
    private var title: String
    private let id: String
    @ObservedObject
    private var viewModel: CourseVerticalViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(
        title: String,
        id: String,
        viewModel: CourseVerticalViewModel
    ) {
        self.title = title
        self.id = id
        self.viewModel = viewModel
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                NavigationBar(title: title,
                              leftButtonAction: { viewModel.router.back() })
                
                // MARK: - Page Body
                GeometryReader { proxy in
                    ScrollView {
                        VStack(alignment: .leading) {
                            // MARK: - Lessons list
                            ForEach(viewModel.verticals, id: \.id) { vertical in
                                if let index = viewModel.verticals.firstIndex(where: {$0.id == vertical.id}) {
                                    Button(action: {
                                        if let block = viewModel.verticals[index].childs.first {
                                            viewModel.router.showCourseUnit(id: id,
                                                                            blockId: block.id,
                                                                            courseID: block.blockId,
                                                                            sectionName: block.displayName,
                                                                            verticalIndex: index,
                                                                            chapters: viewModel.chapters,
                                                                            chapterIndex: viewModel.chapterIndex,
                                                                            sequentialIndex: viewModel.sequentialIndex)
                                        }
                                    }, label: {
                                        HStack {
                                            Group {
                                                if vertical.completion == 1 {
                                                    CoreAssets.finished.swiftUIImage
                                                        .renderingMode(.template)
                                                        .foregroundColor(.accentColor)
                                                } else {
                                                    vertical.type.image
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
                                            }.foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                            Spacer()
                                            if let state = viewModel.downloadState[vertical.id] {
                                                switch state {
                                                case .available:
                                                    DownloadAvailableView()
                                                        .onTapGesture {
                                                            viewModel.onDownloadViewTap(
                                                                blockId: vertical.id,
                                                                state: state
                                                            )
                                                        }
                                                        .onForeground {
                                                            viewModel.onForeground()
                                                        }
                                                case .downloading:
                                                    DownloadProgressView()
                                                        .onTapGesture {
                                                            viewModel.onDownloadViewTap(
                                                                blockId: vertical.id,
                                                                state: state
                                                            )
                                                        }
                                                        .onBackground {
                                                            viewModel.onBackground()
                                                        }
                                                case .finished:
                                                    DownloadFinishedView()
                                                        .onTapGesture {
                                                            viewModel.onDownloadViewTap(
                                                                blockId: vertical.id,
                                                                state: state
                                                            )
                                                        }
                                                }
                                            }
                                            Image(systemName: "chevron.right")
                                                .padding(.vertical, 8)
                                        }
                                    }).padding(.horizontal, 36)
                                        .padding(.vertical, 14)
                                    if index != viewModel.verticals.count - 1 {
                                        Divider()
                                            .frame(height: 1)
                                            .overlay(CoreAssets.cardViewStroke.swiftUIColor)
                                            .padding(.horizontal, 24)
                                    }
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
            connectivity: Connectivity()
        )
        
        return Group {
            CourseVerticalView(title: "Course title", id: "1", viewModel: viewModel)
                .preferredColorScheme(.light)
                .previewDisplayName("CourseVerticalView Light")
            
            CourseVerticalView(title: "Course title", id: "1", viewModel: viewModel)
                .preferredColorScheme(.dark)
                .previewDisplayName("CourseVerticalView Dark")
        }
        
    }
}
#endif
