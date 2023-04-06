//
//  CourseDetailsView.swift
//  CourseDetailsView
//
//  Created by  Stepanok Ivan on 22.09.2022.
//

import SwiftUI
import Core
import Kingfisher
import WebKit

public struct CourseDetailsView: View {
    
    @ObservedObject private var viewModel: CourseDetailsViewModel
    @Environment(\.colorScheme) var colorScheme
    @State private var animate = false
    @State private var showCourse = false
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
            
            // MARK: - Page name
            VStack(alignment: .center) {
                NavigationBar(title: CourseLocalization.Details.title,
                              leftButtonAction: { viewModel.router.back() })
                .onReceive(NotificationCenter
                    .Publisher(center: .default,
                               name: UIDevice.orientationDidChangeNotification)) { _ in
                    updateOrientation()
                }
                
                // MARK: - Page Body
                GeometryReader { proxy in
                    if viewModel.isShowProgress {
                        HStack(alignment: .center) {
                            ProgressBar(size: 40, lineWidth: 8)
                                .padding(.top, 200)
                                .padding(.horizontal)
                        }.frame(width: proxy.size.width)
                    } else {
                        RefreshableScrollViewCompat(action: {
                            await viewModel.getCourseDetail(courseID: courseID, withProgress: isIOS14)
                        }) {
                            VStack(alignment: .leading) {
                                if let courseDetails = viewModel.courseDetails {
                                    
                                    // MARK: - iPad
                                    if idiom == .pad && viewModel.isHorisontal {
                                        HStack {
                                            VStack(alignment: .leading) {
                                                
                                                // MARK: - Title and description
                                                CourseTitleView(courseDetails: courseDetails)
                                                Spacer()
                                                
                                                // MARK: - Course state button
                                                CourseStateView(title: title,
                                                                showCourse: $showCourse,
                                                                courseDetails: courseDetails,
                                                                viewModel: viewModel)
                                            }
                                            VStack {
                                                
                                                // MARK: - Course Banner
                                                CourseBannerView(animate: $animate,
                                                                 courseDetails: courseDetails,
                                                                 proxy: proxy,
                                                                 viewModel: viewModel)
                                            }.aspectRatio(CGSize(width: 16, height: 8.5), contentMode: .fill)
                                                .frame(maxHeight: 250)
                                                .cornerRadius(12)
                                                .padding(.horizontal, 6)
                                                .padding(.top, 7)
                                            
                                        }
                                    } else {
                                        // MARK: - iPhone
                                        VStack {
                                            // MARK: - Course Banner
                                            CourseBannerView(animate: $animate,
                                                             courseDetails: courseDetails,
                                                             proxy: proxy,
                                                             viewModel: viewModel)
                                        }.aspectRatio(CGSize(width: 16, height: 8.5), contentMode: .fill)
                                            .frame(maxHeight: 250)
                                            .cornerRadius(12)
                                            .padding(.horizontal, 6)
                                            .padding(.top, 7)
                                            .fixedSize(horizontal: false, vertical: true)
                                        
                                        // MARK: - Course state button
                                        CourseStateView(title: title,
                                                        showCourse: $showCourse,
                                                        courseDetails: courseDetails,
                                                        viewModel: viewModel)
                                        
                                        // MARK: - Title and description
                                        CourseTitleView(courseDetails: courseDetails)
                                    }
                                    
                                    // MARK: - HTML Embed
                                    VStack {
                                        HTMLFormattedText(
                                            viewModel.cssInjector.injectCSS(
                                                colorScheme: colorScheme,
                                                html: courseDetails.overviewHTML,
                                                type: .discovery, screenWidth: proxy.size.width)
                                        )
                                        .ignoresSafeArea()
                                    }
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 24)
                                }
                            }
                        }.frameLimit()
                            .onRightSwipeGesture {
                                viewModel.router.back()
                            }
                        Spacer(minLength: 84)
                    }
                }
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.getCourseDetail(courseID: courseID, withProgress: isIOS14)
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
        }
        .background(
            CoreAssets.background.swiftUIColor
                .ignoresSafeArea()
        )
    }
}

private struct CourseStateView: View {
    
    let title: String
    @Binding var showCourse: Bool
    let courseDetails: CourseDetails
    let viewModel: CourseDetailsViewModel
    
    init(title: String,
         showCourse: Binding<Bool>,
         courseDetails: CourseDetails,
         viewModel: CourseDetailsViewModel) {
        self.title = title
        self._showCourse = showCourse
        self.courseDetails = courseDetails
        self.viewModel = viewModel
    }
    
    var body: some View {
        switch viewModel.courseState() {
        case .enrollOpen:
            StyledButton(CourseLocalization.Details.enrollNow, action: {
                Task {
                    await viewModel.enrollToCourse(id: courseDetails.courseID)
                }
            })
            .padding(16)
            .frame(maxWidth: .infinity)
        case .enrollClose:
            Text(CourseLocalization.Details.enrollmentDateIsOver)
                .multilineTextAlignment(.center)
                .font(Theme.Fonts.titleSmall)
                .cardStyle()
                .padding(.vertical, 24)
        case .alreadyEnrolled:
            StyledButton(CourseLocalization.Details.viewCourse, action: {
                showCourse = true
                
                viewModel.router.showCourseScreens(
                    courseID: courseDetails.courseID,
                    isActive: nil,
                    courseStart: courseDetails.courseStart,
                    courseEnd: courseDetails.courseEnd,
                    enrollmentStart: courseDetails.enrollmentStart,
                    enrollmentEnd: courseDetails.enrollmentEnd,
                    title: title
                )
                
            })
            .padding(16)
        }
    }
}

private struct PlayButton: View {
    let youTubeUrl: String
    let viewModel: CourseDetailsViewModel
    
    var body: some View {
        Button(action: {
            if let url = viewModel.openYouTube(url: youTubeUrl) {
                UIApplication.shared.open(url)
            }
        }, label: {
            Image(systemName: "play.circle")
                .resizable()
                .foregroundColor(.white)
                .frame(width: 120, height: 120)
                .shadow(radius: 5)
        })
    }
}

private struct CourseTitleView: View {
    let courseDetails: CourseDetails
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(courseDetails.courseDescription)
                .font(Theme.Fonts.labelSmall)
                .padding(.horizontal, 26)
            
            Text(courseDetails.courseTitle)
                .font(Theme.Fonts.titleLarge)
                .padding(.horizontal, 26)
            
            Text(courseDetails.org)
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(CoreAssets.accentColor.swiftUIColor)
                .padding(.horizontal, 26)
                .padding(.top, 10)
        }
    }
}

private struct CourseBannerView: View {
    @Binding var animate: Bool
    let courseDetails: CourseDetails
    private let idiom: UIUserInterfaceIdiom
    private let proxy: GeometryProxy
    private let viewModel: CourseDetailsViewModel
    
    init(animate: Binding<Bool>,
         courseDetails: CourseDetails,
         proxy: GeometryProxy,
         viewModel: CourseDetailsViewModel) {
        self._animate = animate
        self.courseDetails = courseDetails
        self.idiom = UIDevice.current.userInterfaceIdiom
        self.proxy = proxy
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            KFImage(URL(string: courseDetails.courseBannerURL))
                .onFailureImage(CoreAssets.noCourseImage.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: idiom == .pad ? 312 : proxy.size.width - 12)
                .opacity(animate ? 1 : 0)
                .onAppear {
                    withAnimation(.linear(duration: 0.5)) {
                        animate = true
                    }
                }
            if let youTubeUrl = courseDetails.courseVideoURL {
                PlayButton(youTubeUrl: youTubeUrl,
                           viewModel: viewModel)
            }
        }
    }
}

#if DEBUG
// swiftlint:disable all
struct CourseDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = CourseDetailsViewModel(
            interactor: CourseInteractor.mock,
            router: CourseRouterMock(),
            config: ConfigMock(),
            cssInjector: CSSInjectorMock(),
            connectivity: Connectivity()
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
#endif
