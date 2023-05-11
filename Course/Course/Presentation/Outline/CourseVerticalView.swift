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
    @ObservedObject
    private var viewModel: CourseVerticalViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(
        title: String,
        viewModel: CourseVerticalViewModel
    ) {
        self.title = title
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
                                let index = viewModel.verticals.firstIndex(where: {$0.id == vertical.id})
                                Button(action: {
                                    viewModel.router.showCourseBlocksView(
                                        title: vertical.displayName,
                                        blocks: vertical.childs
                                    )
                                }, label: {
                                    HStack {
                                        Group {
                                            if vertical.completion == 1 {
                                                Image(systemName: "checkmark.circle.fill")
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
                                                        viewModel.onDownloadViewTap(blockId: vertical.id, state: state)
                                                    }
                                                    .onForeground {
                                                        viewModel.onForeground()
                                                    }
                                            case .downloading:
                                                DownloadProgressView()
                                                    .onTapGesture {
                                                        viewModel.onDownloadViewTap(blockId: vertical.id, state: state)
                                                    }
                                                    .onBackground {
                                                        viewModel.onBackground()
                                                    }
                                            case .finished:
                                                DownloadFinishedView()
                                                    .onTapGesture {
                                                        viewModel.onDownloadViewTap(blockId: vertical.id, state: state)
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
        
        let verticals: [CourseVertical] = [
            CourseVertical(
                blockId: "block_1",
                id: "1",
                displayName: "Some vertical",
                type: .vertical,
                completion: 0,
                childs: []
            ),
            CourseVertical(
                blockId: "block_2",
                id: "2",
                displayName: "Comleted vertical",
                type: .vertical,
                completion: 1,
                childs: []
            ),
            CourseVertical(
                blockId: "block_3",
                id: "3",
                displayName: "Another vertical",
                type: .vertical,
                completion: 0,
                childs: []
            )
        ]
        
        let viewModel = CourseVerticalViewModel(verticals: verticals,
                                              manager: DownloadManagerMock(),
                                              router: CourseRouterMock(),
                                              connectivity: Connectivity())
        
        return Group {
            CourseVerticalView(title: "Course title", viewModel: viewModel)
            .preferredColorScheme(.light)
            .previewDisplayName("CourseVerticalView Light")
            
            CourseVerticalView(title: "Course title", viewModel: viewModel)
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseVerticalView Dark")
        }
        
    }
}
#endif
