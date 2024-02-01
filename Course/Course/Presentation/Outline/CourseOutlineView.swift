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
                                    CourseExpandableContentView(
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
                }.padding(.top, 8)
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
        .onReceive(
            NotificationCenter.default.publisher(
                for: .blockChanged
            )
        ) { _ in
            Task {
                await viewModel.getCourseBlocks(courseID: courseID, withProgress: false)
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

struct CourseStructureView: View {
    
    private let proxy: GeometryProxy
    private let course: CourseStructure
    private let viewModel: CourseContainerViewModel
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    init(proxy: GeometryProxy, course: CourseStructure, viewModel: CourseContainerViewModel) {
        self.proxy = proxy
        self.course = course
        self.viewModel = viewModel
    }
    
    var body: some View {
        let chapters = course.childs
        ForEach(chapters, id: \.id) { chapter in
            let chapterIndex = chapters.firstIndex(where: { $0.id == chapter.id })
            Text(chapter.displayName)
                .font(Theme.Fonts.titleMedium)
                .multilineTextAlignment(.leading)
                .foregroundColor(Theme.Colors.textSecondary)
                .padding(.horizontal, 24)
                .padding(.top, 40)
            ForEach(chapter.childs, id: \.id) { child in
                let sequentialIndex = chapter.childs.firstIndex(where: { $0.id == child.id })
                VStack(alignment: .leading) {
                    HStack {
                        Button {
                            if let chapterIndex, let sequentialIndex {
                                viewModel.trackSequentialClicked(child)
                                viewModel.router.showCourseVerticalView(
                                    courseID: viewModel.courseStructure?.id ?? "",
                                    courseName: viewModel.courseStructure?.displayName ?? "",
                                    title: child.displayName,
                                    chapters: chapters,
                                    chapterIndex: chapterIndex,
                                    sequentialIndex: sequentialIndex
                                )
                            }
                        } label: {
                            Group {
                                if child.completion == 1 {
                                    CoreAssets.finished.swiftUIImage
                                        .renderingMode(.template)
                                        .foregroundColor(.accentColor)
                                } else {
                                    child.type.image
                                }
                                Text(child.displayName)
                                    .font(Theme.Fonts.titleMedium)
                                    .multilineTextAlignment(.leading)
                                    .lineLimit(1)
                                    .frame(
                                        maxWidth: idiom == .pad
                                        ? proxy.size.width * 0.5
                                        : proxy.size.width * 0.6,
                                        alignment: .leading
                                    )
                            }
                            .foregroundColor(Theme.Colors.textPrimary)
                        }
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel(child.displayName)
                        Spacer()
                        if let state = viewModel.sequentialsDownloadState[child.id] {
                            switch state {
                            case .available:
                                DownloadAvailableView()
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.download)
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
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.cancelDownload)
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
                                    .accessibilityElement(children: .ignore)
                                    .accessibilityLabel(CourseLocalization.Accessibility.deleteDownload)
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
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .padding(.horizontal, 36)
                    .padding(.vertical, 20)
                    if chapterIndex != chapters.count - 1 {
                        Divider()
                            .frame(height: 1)
                            .overlay(Theme.Colors.cardViewStroke)
                            .padding(.horizontal, 24)
                    }
                }
            }
        }
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
