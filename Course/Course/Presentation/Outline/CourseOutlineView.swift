//
//  ProfileView.swift
//  Profile
//
//  Created by Stepanok Ivan on 29.09.2022.
//

import SwiftUI
import Core
import Kingfisher

public struct CourseOutlineView: View {
    
    @ObservedObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let isVideo: Bool
    
    @State private var openCertificateView: Bool = false
    
    public init(
        viewModel: CourseContainerViewModel,
        title: String,
        courseID: String,
        isVideo: Bool
    ) {
        self.title = title
        self.viewModel = viewModel
        self.courseID = courseID
        self.isVideo = isVideo
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    NavigationBar(title: title,
                    leftButtonAction: { viewModel.router.back() })
                    
                    // MARK: - Page Body
                    RefreshableScrollViewCompat(action: {
                        await viewModel.getCourseBlocks(courseID: courseID, withProgress: isIOS14)
                    }) {
                        VStack(alignment: .leading) {
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
                                
                                // MARK: - Course Certificate
                                if let certificate = viewModel.courseStructure?.certificate {
                                    if let url = certificate.url, url.count > 0 {
                                        CoreAssets.certificateForeground.swiftUIColor
                                        VStack(alignment: .center, spacing: 8) {
                                            CoreAssets.certificate.swiftUIImage
                                            Text(CourseLocalization.Outline.congratulations)
                                                .multilineTextAlignment(.center)
                                                .font(Theme.Fonts.headlineMedium)
                                            Text(CourseLocalization.Outline.passedTheCourse)
                                                .font(Theme.Fonts.bodyMedium)
                                                .multilineTextAlignment(.center)
                                            StyledButton(CourseLocalization.Outline.viewCertificate,
                                                         action: { openCertificateView = true },
                                                         isTransparent: true)
                                            .frame(width: 141)
                                            .padding(.top, 8)
                                            .fullScreenCover(isPresented: $openCertificateView,
                                                             content: {
                                                WebBrowser(url: url, pageTitle: CourseLocalization.Outline.certificate)
                                            })
                                        }.padding(.horizontal, 24)
                                            .padding(.top, 8)
                                            .foregroundColor(.white)
                                    }
                                }
                            }
                            .frame(maxHeight: 250)
                            .cornerRadius(12)
                            .padding(.horizontal, 6)
                            .padding(.top, 7)
                            .fixedSize(horizontal: false, vertical: true)
                            
                            if let courseStructure = isVideo ? viewModel.courseVideosStructure : viewModel.courseStructure {
                                // MARK: - Sections list
                                
                                if let chapters = courseStructure.childs {
                                    ForEach(chapters, id: \.id) { chapter in
                                        let index = chapters.firstIndex(where: {$0.id == chapter.id })
                                        Text(chapter.displayName)
                                            .font(Theme.Fonts.titleMedium)
                                            .multilineTextAlignment(.leading)
                                            .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                                            .padding(.horizontal, 24)
                                            .padding(.top, 40)
                                        ForEach(chapter.childs, id: \.id) { child in
                                            VStack(alignment: .leading) {
                                                Button(action: {
                                                    viewModel.router.showCourseVerticalView(title: child.displayName,
                                                                                            verticals: child.childs)
                                                }, label: {
                                                    Group {
                                                        child.type.image
                                                        Text(child.displayName)
                                                            .font(Theme.Fonts.titleMedium)
                                                            .multilineTextAlignment(.leading)
                                                    }.foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                                                    Spacer()
                                                    if let state = viewModel.downloadState[child.id] {
                                                        switch state {
                                                        case .available:
                                                            DownloadAvailableView()
                                                                .onTapGesture {
                                                                    viewModel.onDownloadViewTap(
                                                                        chapter: chapter,
                                                                        blockId: child.id,
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
                                                                        chapter: chapter,
                                                                        blockId: child.id,
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
                                                                        chapter: chapter,
                                                                        blockId: child.id,
                                                                        state: state
                                                                    )
                                                                }
                                                        }
                                                    }
                                                    Image(systemName: "chevron.right")
                                                        .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                                                }).padding(.horizontal, 36)
                                                    .padding(.vertical, 20)
                                                if index != chapters.count - 1 {
                                                    Divider()
                                                        .frame(height: 1)
                                                        .overlay(CoreAssets.cardViewStroke.swiftUIColor)
                                                        .padding(.horizontal, 24)
                                                }
                                            }
                                        }
                                    }
                                }
                            } else {
                                if let courseStart = viewModel.courseStart {
                                    Text(courseStart > Date() ? CourseLocalization.Outline.courseHasntStarted : "")
                                        .frame(maxWidth: .infinity)
                                        .padding(.top, 100)
                                }
                            }
                            Spacer(minLength: 84)
                        }
                    }.frameLimit()
                        .onRightSwipeGesture {
                            viewModel.router.back()
                        }
                }
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(connectivity: viewModel.connectivity,
                                    reloadAction: {
                    await viewModel.getCourseBlocks(courseID: courseID, withProgress: isIOS14)
                })
                
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
                if viewModel.isShowProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                            .padding(.top, 200)
                            .padding(.horizontal)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
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
struct CourseOutlineView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseContainerViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            config: ConfigMock(),
            connectivity: Connectivity(),
            manager: DownloadManagerMock(),
            isActive: nil,
            courseStart: Date(),
            courseEnd: nil,
            enrollmentStart: nil,
            enrollmentEnd: nil
        )
        Task {
            await viewModel.getCourseBlocks(courseID: "courseId")
        }
        
        return Group {
            CourseOutlineView(
                viewModel: viewModel,
                title: "Course title",
                courseID: "",
                isVideo: false
            )
            .preferredColorScheme(.light)
            .previewDisplayName("CourseOutlineView Light")
            
            CourseOutlineView(
                viewModel: viewModel,
                title: "Course title",
                courseID: "",
                isVideo: false
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("CourseOutlineView Dark")
        }
        
    }
}
#endif
