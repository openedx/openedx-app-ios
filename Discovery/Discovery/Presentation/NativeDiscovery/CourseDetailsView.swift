//
//  CourseDetailsView.swift
//  CourseDetailsView
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI
import Core
import OEXFoundation
import Kingfisher
import WebKit
import Theme

public struct CourseDetailsView: View {
    
    @ObservedObject private var viewModel: CourseDetailsViewModel
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.isHorizontal) var isHorizontal
    @State private var isOverviewRendering = true
    private var title: String
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    private var courseID: String
    
    private func updateOrientation() {
        viewModel.isHorisontal =
        UIDevice.current.orientation == .landscapeLeft
        || UIDevice.current.orientation == .landscapeRight
    }
    
    public init(viewModel: CourseDetailsViewModel, courseID: String, title: String) {
        self.viewModel = viewModel
        self.title = title
        self.courseID = courseID
        Task {
            await viewModel.getCourseDetail(courseID: courseID)
        }
        self.updateOrientation()
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .center) {
                // MARK: - Page Body
                GeometryReader { proxy in
                    if viewModel.isShowProgress {
                        HStack(alignment: .center) {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                                .accessibilityIdentifier("progress_bar")
                        }.frame(width: proxy.size.width)
                    } else {
                        ScrollView {
                            VStack(alignment: .leading) {
                                if let courseDetails = viewModel.courseDetails {
                                    
                                    // MARK: - iPad
                                    if viewModel.isHorisontal {
                                        HStack(alignment: .top) {
                                            VStack(alignment: .leading) {
                                                
                                                // MARK: - Title and description
                                                CourseTitleView(courseDetails: courseDetails)
                                                Spacer()
                                                
                                                // MARK: - Course state button
                                                CourseStateView(title: title,
                                                                courseDetails: courseDetails,
                                                                viewModel: viewModel)
                                            }
                                            VStack {
                                                // MARK: - Course Banner
                                                CourseBannerView(
                                                    courseDetails: courseDetails,
                                                    proxy: proxy,
                                                    isHorisontal: viewModel.isHorisontal,
                                                    onPlayButtonTap: { [weak viewModel] in
                                                        viewModel?.showCourseVideo()
                                                    }
                                                )
                                            }.aspectRatio(CGSize(width: 16, height: 8.5), contentMode: .fill)
                                                .frame(maxHeight: 250)
                                                .cornerRadius(12)
                                                .padding(.horizontal, 6)
                                                .padding(.top, 7)
                                            
                                        }
                                    } else {
                                        // MARK: - iPhone
                                        VStack(alignment: .leading) {
                                            // MARK: - Course Banner
                                            CourseBannerView(
                                                courseDetails: courseDetails,
                                                proxy: proxy,
                                                isHorisontal: viewModel.isHorisontal,
                                                onPlayButtonTap: { [weak viewModel] in
                                                    viewModel?.showCourseVideo()
                                                })
                                        }.aspectRatio(CGSize(width: 16, height: 8.5), contentMode: .fill)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 6)
                                            .padding(.top, 7)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // MARK: - Course state button
                                        CourseStateView(title: title,
                                                        courseDetails: courseDetails,
                                                        viewModel: viewModel)
                                        .padding(.top, 24)
                                        
                                        // MARK: - Title and description
                                        CourseTitleView(courseDetails: courseDetails)
                                    }
                                    
                                    // MARK: - HTML Embed
                                    ZStack(alignment: .topLeading) {
                                        HTMLFormattedText(
                                            viewModel.cssInjector.injectCSS(
                                                colorScheme: colorScheme,
                                                html: courseDetails.overviewHTML,
                                                type: .discovery,
                                                screenWidth: proxy.size.width - 48),
                                            processing: { rendering in
                                                isOverviewRendering = rendering
                                            }
                                        )
                                        .padding(.horizontal, 16)
                                        
                                        if isOverviewRendering {
                                            ProgressBar(size: 40, lineWidth: 8)
                                                .padding(.top, 20)
                                                .frame(maxWidth: .infinity)
                                                .accessibilityIdentifier("progress_bar")
                                        }
                                    }
                                }
                            }
                            .frameLimit(width: proxy.size.width)
                        }
                        .refreshable {
                            Task {
                                await viewModel.getCourseDetail(courseID: courseID, withProgress: false)
                            }
                        }
                        .onRightSwipeGesture {
                            viewModel.router.back()
                        }
                        Spacer(minLength: 84)
                    }
                }
                if !viewModel.userloggedIn {
                    LogistrationBottomView(
                        ssoEnabled: viewModel.config.uiComponents.samlSSOLoginEnabled
                    ) { buttonAction in
                        switch buttonAction {
                        case .signIn:
                            viewModel.router.showLoginScreen(
                                sourceScreen: .courseDetail(
                                    courseID,
                                    viewModel.courseDetails?.courseTitle ?? ""
                                )
                            )
                        case .register:
                            viewModel.router.showRegisterScreen(
                                sourceScreen: .courseDetail(
                                    courseID,
                                    viewModel.courseDetails?.courseTitle ?? ""
                                )
                            )
                        case .signInWithSSO:
                            viewModel.router.showLoginScreen(
                                sourceScreen: .courseDetail(
                                    courseID,
                                    viewModel.courseDetails?.courseTitle ?? ""
                                )
                            )
                        }
                    }
                }
            }.padding(.top, 8)
            .navigationBarHidden(false)
            .navigationBarBackButtonHidden(false)
            .navigationTitle(DiscoveryLocalization.Details.title)
            
            .onReceive(NotificationCenter
                .Publisher(center: .default,
                           name: UIDevice.orientationDidChangeNotification)) { _ in
                updateOrientation()
            }
            
            // MARK: - Offline mode SnackBar
            if viewModel.courseState() != .enrollOpen {
                OfflineSnackBarView(connectivity: viewModel.connectivity,
                                    reloadAction: {
                    await viewModel.getCourseDetail(courseID: courseID, withProgress: false)
                })
            }
            
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
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
}

private struct CourseStateView: View {
    
    let title: String
    let courseDetails: CourseDetails
    let viewModel: CourseDetailsViewModel
    
    init(title: String,
         courseDetails: CourseDetails,
         viewModel: CourseDetailsViewModel) {
        self.title = title
        self.courseDetails = courseDetails
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.courseState() {
        case .enrollOpen:
            Group {
            if viewModel.connectivity.isInternetAvaliable {
                    StyledButton(DiscoveryLocalization.Details.enrollNow, action: {
                        if !viewModel.userloggedIn {
                            viewModel.router.showRegisterScreen(
                                sourceScreen: .courseDetail(
                                    courseDetails.courseID,
                                    courseDetails.courseTitle)
                            )
                        } else {
                            Task {
                                await viewModel.enrollToCourse(id: courseDetails.courseID)
                            }
                        }
                    })
                    .padding(16)
                } else {
                    HStack(alignment: .center, spacing: 10) {
                        CoreAssets.noWifiMini.swiftUIImage
                            .renderingMode(.template)
                            .foregroundStyle(Theme.Colors.warning)
                        Text(DiscoveryLocalization.Details.enrollmentNoInternet)
                            .multilineTextAlignment(.leading)
                            .font(Theme.Fonts.titleSmall)
                        Spacer()
                    }.cardStyle(paddingAll: 12, bgColor: Theme.Colors.textInputUnfocusedBackground, strokeColor: .clear)
                }
            }
            .accessibilityIdentifier("enroll_button")
        case .enrollClose:
            Text(DiscoveryLocalization.Details.enrollmentDateIsOver)
                .multilineTextAlignment(.center)
                .font(Theme.Fonts.titleSmall)
                .cardStyle()
                .padding(.vertical, 24)
                .accessibilityIdentifier("date_over_text")
        case .alreadyEnrolled:
            StyledButton(DiscoveryLocalization.Details.viewCourse, action: {
                if !viewModel.userloggedIn {
                    viewModel.router.showRegisterScreen(
                        sourceScreen: .courseDetail(
                            courseDetails.courseID,
                            courseDetails.courseTitle)
                    )
                } else {
                    viewModel.viewCourseClicked(
                        courseId: courseDetails.courseID,
                        courseName: courseDetails.courseTitle
                    )
                    viewModel.router.showCourseScreens(
                        courseID: courseDetails.courseID,
                        hasAccess: nil,
                        courseStart: courseDetails.courseStart,
                        courseEnd: courseDetails.courseEnd,
                        enrollmentStart: courseDetails.enrollmentStart,
                        enrollmentEnd: courseDetails.enrollmentEnd,
                        title: title,
                        courseRawImage: courseDetails.courseRawImage,
                        showDates: false,
                        lastVisitedBlockID: nil
                    )
                }
            })
            .padding(16)
            .accessibilityIdentifier("view_course_button")
        }
    }
}

private struct PlayButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action, label: {
            CoreAssets.playVideo.swiftUIImage
                .resizable()
                .frame(width: 40, height: 40)
        })
        .accessibilityIdentifier("play_button")
    }
}

private struct CourseTitleView: View {
    let courseDetails: CourseDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(courseDetails.courseDescription ?? "")
                .font(Theme.Fonts.labelSmall)
                .padding(.horizontal, 26)
                .accessibilityIdentifier("description_text")
            
            Text(courseDetails.courseTitle)
                .font(Theme.Fonts.titleLarge)
                .padding(.horizontal, 26)
                .accessibilityIdentifier("title_text")
            
            Text(courseDetails.org)
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(Theme.Colors.accentColor)
                .padding(.horizontal, 26)
                .padding(.top, 10)
                .accessibilityIdentifier("org_text")
        }
    }
}

private struct CourseBannerView: View {
    @State private var animate = false
    private var isHorisontal: Bool
    private let courseDetails: CourseDetails
    private let idiom: UIUserInterfaceIdiom
    private let proxy: GeometryProxy
    private let onPlayButtonTap: () -> Void
    
    init(courseDetails: CourseDetails,
         proxy: GeometryProxy,
         isHorisontal: Bool,
         onPlayButtonTap: @escaping () -> Void) {
        self.courseDetails = courseDetails
        self.isHorisontal = isHorisontal
        self.idiom = UIDevice.current.userInterfaceIdiom
        self.proxy = proxy
        self.onPlayButtonTap = onPlayButtonTap
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            if !isHorisontal {
                KFImage(URL(string: courseDetails.courseBannerURL))
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(width: idiom == .pad ? nil : proxy.size.width - 12)
                    .opacity(animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.linear(duration: 0.5)) {
                            animate = true
                        }
                    }
                    .accessibilityIdentifier("course_image")
                if courseDetails.courseVideoURL != nil {
                    PlayButton(action: onPlayButtonTap)
                }
            } else {
                KFImage(URL(string: courseDetails.courseBannerURL))
                    .onFailureImage(CoreAssets.noCourseImage.image)
                    .resizable()
                    .aspectRatio(16/9, contentMode: .fill)
                    .frame(width: 312)
                    .opacity(animate ? 1 : 0)
                    .onAppear {
                        withAnimation(.linear(duration: 0.5)) {
                            animate = true
                        }
                    }
                    .accessibilityIdentifier("course_image")
                if courseDetails.courseVideoURL != nil {
                    PlayButton(action: onPlayButtonTap)
                }
            }
        }
    }
}

#if DEBUG
// swiftlint:disable all
struct CourseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CourseDetailsViewModel(
            interactor: DiscoveryInteractor.mock,
            router: DiscoveryRouterMock(),
            analytics: DiscoveryAnalyticsMock(),
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            connectivity: Connectivity(),
            storage: CoreStorageMock()
        )
        
        CourseDetailsView(
            viewModel: vm,
            courseID: "courseID",
            title: "Course title"
        )
        .preferredColorScheme(.light)
        .previewDisplayName("CourseDetailsView Light")
        
        CourseDetailsView(
            viewModel: vm,
            courseID: "courseID",
            title: "Course title"
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("CourseDetailsView Dark")
    }
}
// swiftlint:enable all
#endif
