//
//  ProfileView.swift
//  Profile
//
//  Created by Stepanok Ivan on 29.09.2022.
//

import SwiftUI
import Core
import Kingfisher
import Theme

public struct CourseOutlineView: View {
    
    @StateObject private var viewModel: CourseContainerViewModel
    private let title: String
    private let courseID: String
    private let isVideo: Bool
    
    @State private var openCertificateView: Bool = false
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }

    @State private var showingDownloads: Bool = false
    @State private var showingVideoDownloadQuality: Bool = false
    @State private var showingNoWifiMessage: Bool = false

    public init(
        viewModel: CourseContainerViewModel,
        title: String,
        courseID: String,
        isVideo: Bool
    ) {
        self.title = title
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.courseID = courseID
        self.isVideo = isVideo
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            // MARK: - Page name
            GeometryReader { proxy in
                VStack(alignment: .center) {
                    // MARK: - Page Body
                    RefreshableScrollViewCompat(action: {
                        await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
                    }) {
                        VStack(alignment: .leading) {
                            if viewModel.config.uiComponents.courseBannerEnabled {
                                courseBanner(proxy: proxy)
                            }

                            downloadQualityBars

                            if let continueWith = viewModel.continueWith,
                               let courseStructure = viewModel.courseStructure,
                               !isVideo {
                                let chapter = courseStructure.childs[continueWith.chapterIndex]
                                let sequential = chapter.childs[continueWith.sequentialIndex]
                                let continueUnit = sequential.childs[continueWith.verticalIndex]
                                
                                // MARK: - ContinueWith button
                                ContinueWithView(
                                    data: continueWith,
                                    courseContinueUnit: continueUnit
                                ) {
                                    var continueBlock: CourseBlock?
                                    continueUnit.childs.forEach { block in
                                        if block.id == continueWith.lastVisitedBlockId {
                                            continueBlock = block
                                        }
                                    }
                                    
                                    viewModel.trackResumeCourseTapped(
                                        blockId: continueBlock?.id ?? ""
                                    )
                                    
                                    if let course = viewModel.courseStructure {
                                        viewModel.router.showCourseUnit(
                                            courseName: course.displayName,
                                            blockId: continueBlock?.id ?? "",
                                            courseID: course.id,
                                            sectionName: continueUnit.displayName,
                                            verticalIndex: continueWith.verticalIndex,
                                            chapters: course.childs,
                                            chapterIndex: continueWith.chapterIndex,
                                            sequentialIndex: continueWith.sequentialIndex
                                        )
                                    }
//"Saeed"
                                }
                            }
                            
                            if let course = isVideo
                                ? viewModel.courseVideosStructure
                                : viewModel.courseStructure {
                                
                                // MARK: - Sections
                                if viewModel.config.uiComponents.courseNestedListEnabled {
                                    CourseStructureNestedListView(
                                        proxy: proxy,
                                        course: course,
                                        viewModel: viewModel
                                    )
                                } else {
                                    CourseStructureView(
                                        proxy: proxy,
                                        course: course,
                                        viewModel: viewModel
                                    )
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
                    }
                    .frameLimit()
                        .onRightSwipeGesture {
                            viewModel.router.back()
                        }
                }
                .padding(.top, viewModel.config.uiComponents.courseTopTabBarEnabled ? 0 : 8)
                .accessibilityAction {}

                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
                    }
                )
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(.bottom, viewModel.isInternetAvaliable
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
                            .padding(.horizontal)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                }
            }
        }
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
        .sheet(isPresented: $showingDownloads) {
            DownloadsView(manager: viewModel.manager)
        }
        .sheet(isPresented: $showingVideoDownloadQuality) {
            viewModel.storage.userSettings.map {
                VideoDownloadQualityContainerView(
                    downloadQuality: $0.downloadQuality,
                    didSelect: viewModel.update(downloadQuality:)
                )
            }
        }
        .alert(isPresented: $viewModel.showAllowLargeDownload) {
            Alert(
                title: Text(CourseLocalization.Download.download),
                message: Text(CourseLocalization.Download.downloadLargeFileMessage),
                primaryButton: .default(Text(CourseLocalization.Alert.accept)) {
                    viewModel.continueDownload()
                },
                secondaryButton: .cancel()
            )
        }
    }

    @ViewBuilder
    private var downloadQualityBars: some View {
        if isVideo,
           let courseVideosStructure = viewModel.courseVideosStructure,
           viewModel.hasVideoForDowbloads() {
            VStack(spacing: 0) {
                CourseVideoDownloadBarView(
                    courseStructure: courseVideosStructure,
                    courseViewModel: viewModel,
                    onNotInternetAvaliable: {
                        viewModel.errorMessage = CourseLocalization.Download.noWifiMessage
                    },
                    onTap: {
                        showingDownloads = true
                    }
                )
                viewModel.userSettings.map {
                    VideoDownloadQualityBarView(
                        downloadQuality: $0.downloadQuality
                    ) {
                        if viewModel.isAllDownloading() {
                            viewModel.errorMessage = CourseLocalization.Download.changeQualityAlert
                            return
                        }
                        showingVideoDownloadQuality = true
                    }
                }
            }
        }
    }

    private func courseBanner(proxy: GeometryProxy) -> some View {
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
                    Theme.Colors.certificateForeground
                    VStack(alignment: .center, spacing: 8) {
                        CoreAssets.certificate.swiftUIImage
                        Text(CourseLocalization.Outline.congratulations)
                            .multilineTextAlignment(.center)
                            .font(Theme.Fonts.headlineMedium)
                        Text(CourseLocalization.Outline.passedTheCourse)
                            .font(Theme.Fonts.bodyMedium)
                            .multilineTextAlignment(.center)
                        StyledButton(
                            CourseLocalization.Outline.viewCertificate,
                            action: { openCertificateView = true },
                            isTransparent: true
                        )
                        .frame(width: 141)
                        .padding(.top, 8)

                        .fullScreenCover(
                            isPresented: $openCertificateView,
                            content: {
                                WebBrowser(
                                    url: url,
                                    pageTitle: CourseLocalization.Outline.certificate
                                )
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
    }
}

#if DEBUG
struct CourseOutlineView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CourseContainerViewModel(
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
