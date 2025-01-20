//
//  PrimaryCourseDashboardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 16.04.2024.
//

import SwiftUI
import Core
import OEXFoundation
import Theme
import Swinject

public struct PrimaryCourseDashboardView<ProgramView: View>: View {
    
    @StateObject private var viewModel: PrimaryCourseDashboardViewModel
    private let router: DashboardRouter
    @ViewBuilder let programView: ProgramView
    private var openDiscoveryPage: () -> Void
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    @State private var selectedMenu: MenuOption = .courses
    
    public init(
        viewModel: PrimaryCourseDashboardViewModel,
        router: DashboardRouter,
        programView: ProgramView,
        openDiscoveryPage: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.router = router
        self.programView = programView
        self.openDiscoveryPage = openDiscoveryPage
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                if viewModel.enrollments?.primaryCourse == nil
                    && !viewModel.fetchInProgress
                    && selectedMenu == .courses {
                    NoCoursesView(openDiscovery: {
                        openDiscoveryPage()
                    }).zIndex(1)
                }
                learnTitleAndSearch(proxy: proxy)
                    .zIndex(1)
                // MARK: - Page body
                VStack(alignment: .leading) {
                    Spacer(minLength: 50)
                    switch selectedMenu {
                    case .courses:
                    ScrollView {
                        ZStack(alignment: .topLeading) {
                            if viewModel.fetchInProgress {
                                VStack(alignment: .center) {
                                    ProgressBar(size: 40, lineWidth: 8)
                                        .padding(.top, 200)
                                }.frame(maxWidth: .infinity,
                                        maxHeight: .infinity)
                            } else {
                                LazyVStack(spacing: 0) {
                                        if let enrollments = viewModel.enrollments {
                                            if let primary = enrollments.primaryCourse {
                                                PrimaryCardView(
                                                    courseName: primary.name,
                                                    org: primary.org,
                                                    courseImage: primary.courseBanner,
                                                    courseStartDate: primary.courseStart,
                                                    courseEndDate: primary.courseEnd,
                                                    futureAssignments: primary.futureAssignments,
                                                    pastAssignments: primary.pastAssignments,
                                                    progressEarned: primary.progressEarned,
                                                    progressPossible: primary.progressPossible,
                                                    canResume: primary.lastVisitedBlockID != nil,
                                                    resumeTitle: primary.resumeTitle,
                                                    useRelativeDates: viewModel.storage.useRelativeDates,
                                                    assignmentAction: { lastVisitedBlockID in
                                                        router.showCourseScreens(
                                                            courseID: primary.courseID,
                                                            hasAccess: primary.hasAccess,
                                                            courseStart: primary.courseStart,
                                                            courseEnd: primary.courseEnd,
                                                            enrollmentStart: nil,
                                                            enrollmentEnd: nil,
                                                            title: primary.name,
                                                            courseRawImage: primary.courseBanner,
                                                            showDates: lastVisitedBlockID == nil,
                                                            lastVisitedBlockID: lastVisitedBlockID
                                                        )
                                                    },
                                                    openCourseAction: {
                                                        router.showCourseScreens(
                                                            courseID: primary.courseID,
                                                            hasAccess: primary.hasAccess,
                                                            courseStart: primary.courseStart,
                                                            courseEnd: primary.courseEnd,
                                                            enrollmentStart: nil,
                                                            enrollmentEnd: nil,
                                                            title: primary.name,
                                                            courseRawImage: primary.courseBanner,
                                                            showDates: false,
                                                            lastVisitedBlockID: nil
                                                        )
                                                    },
                                                    resumeAction: {
                                                        router.showCourseScreens(
                                                            courseID: primary.courseID,
                                                            hasAccess: primary.hasAccess,
                                                            courseStart: primary.courseStart,
                                                            courseEnd: primary.courseEnd,
                                                            enrollmentStart: nil,
                                                            enrollmentEnd: nil,
                                                            title: primary.name,
                                                            courseRawImage: primary.courseBanner,
                                                            showDates: false,
                                                            lastVisitedBlockID: primary.lastVisitedBlockID
                                                        )
                                                    }
                                                )
                                            }
                                            if !enrollments.courses.isEmpty {
                                                viewAll(enrollments)
                                            }
                                            if idiom == .pad {
                                                LazyVGrid(
                                                    columns: [
                                                        GridItem(.flexible(), spacing: 16),
                                                        GridItem(.flexible(), spacing: 16),
                                                        GridItem(.flexible(), spacing: 16),
                                                        GridItem(.flexible(), spacing: 16)
                                                    ],
                                                    alignment: .leading,
                                                    spacing: 15
                                                ) {
                                                    courses(enrollments)
                                                }
                                                .padding(20)
                                            } else {
                                                ScrollView(.horizontal, showsIndicators: false) {
                                                    HStack(spacing: 16) {
                                                        courses(enrollments)
                                                    }
                                                    .padding(20)
                                                }
                                            }
                                            Spacer(minLength: 100)
                                        }
                                }
                            }
                        }
                        .frameLimit(width: proxy.size.width)
                    }
                    .refreshable {
                        Task {
                            await viewModel.getEnrollments(showProgress: false)
                        }
                    }
                    .accessibilityAction {}
                    case .programs:
                        programView
                    }
                }.padding(.top, 8)
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await viewModel.getEnrollments(showProgress: false)
                    }
                ).zIndex(2)
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(
                        .bottom,
                        viewModel.connectivity.isInternetAvaliable ? 0 : OfflineSnackBarView.height
                    )
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                    .zIndex(2)
                }
            }
            .onFirstAppear {
                Task {
                    await viewModel.getEnrollments()
                }
            }
            .onAppear {
                viewModel.updateNeeded = true
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle(DashboardLocalization.title)
        }
    }
    
    @ViewBuilder
    private func courses(_ enrollments: PrimaryEnrollment) -> some View {
        let useRelativeDates = viewModel.storage.useRelativeDates
        ForEach(
            Array(enrollments.courses.enumerated()),
            id: \.offset
        ) { _, course in
            Button(action: {
                router.showCourseScreens(
                    courseID: course.courseID,
                    hasAccess: course.hasAccess,
                    courseStart: course.courseStart,
                    courseEnd: course.courseEnd,
                    enrollmentStart: course.enrollmentStart,
                    enrollmentEnd: course.enrollmentEnd,
                    title: course.name,
                    courseRawImage: course.imageURL,
                    showDates: false,
                    lastVisitedBlockID: nil
                )
            }, label: {
                CourseCardView(
                    courseName: course.name,
                    courseImage: course.imageURL,
                    progressEarned: 0,
                    progressPossible: 0,
                    courseStartDate: nil,
                    courseEndDate: nil,
                    hasAccess: course.hasAccess,
                    showProgress: false,
                    useRelativeDates: useRelativeDates
                ).frame(width: idiom == .pad ? nil : 120)
            }
            )
            .accessibilityIdentifier("course_item")
        }
        if enrollments.courses.count < enrollments.count {
            viewAllButton(enrollments)
        }
    }
    
    private func viewAllButton(_ enrollments: PrimaryEnrollment) -> some View {
        Button(action: {
            router.showAllCourses(courses: enrollments.courses)
        }, label: {
            ZStack(alignment: .topTrailing) {
                HStack {
                    Spacer()
                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()
                        CoreAssets.viewAll.swiftUIImage
                        Text(DashboardLocalization.Learn.viewAll)
                            .font(Theme.Fonts.labelMedium)
                            .foregroundStyle(Theme.Colors.textPrimary)
                        Spacer()
                    }
                    Spacer()
                }
                .frame(width: idiom == .pad ? nil : 120)
            }
            .background(Theme.Colors.cardViewBackground)
            .cornerRadius(8)
            .shadow(color: Theme.Colors.courseCardShadow, radius: 6, x: 2, y: 2)
        })
    }
    
    private func viewAll(_ enrollments: PrimaryEnrollment) -> some View {
        Button(action: {
            router.showAllCourses(courses: enrollments.courses)
        }, label: {
            HStack {
                Text(DashboardLocalization.Learn.viewAllCourses(enrollments.count + 1))
                    .font(Theme.Fonts.titleSmall)
                    .accessibilityIdentifier("courses_welcomeback_text")
                Image(systemName: "chevron.right")
            }
            .padding(.horizontal, 16)
            .foregroundColor(Theme.Colors.textPrimary)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        })
    }
    
    private func learnTitleAndSearch(proxy: GeometryProxy) -> some View {
        let showDropdown = viewModel.config.program.enabled && viewModel.config.program.isWebViewConfigured
       return ZStack(alignment: .top) {
            Theme.Colors.background
                .frame(height: showDropdown ? 70 : 50)
            ZStack(alignment: .topTrailing) {
                VStack {
                    HStack(alignment: .center) {
                        Text(DashboardLocalization.Learn.title)
                            .font(Theme.Fonts.displaySmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityIdentifier("courses_header_text")
                        Spacer()
                    }
                    if showDropdown {
                        HStack(alignment: .center) {
                            DropDownMenu(selectedOption: $selectedMenu, analytics: viewModel.analytics)
                            Spacer()
                        }
                    }
                }
                    .frameLimit(width: proxy.size.width)
                HStack {
                    Spacer()
                    Button(action: {
                        router.showSettings()
                    }, label: {
                        CoreAssets.settings.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                }
                .padding(.top, 8)
                .offset(x: idiom == .pad ? 1 : 5, y: idiom == .pad ? 4 : -5)
            }
            
            .listRowBackground(Color.clear)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(DashboardLocalization.Header.courses + DashboardLocalization.Header.welcomeBack)
        }
    }
}

#if DEBUG
struct PrimaryCourseDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = PrimaryCourseDashboardViewModel(
            interactor: DashboardInteractor.mock,
            connectivity: Connectivity(),
            analytics: DashboardAnalyticsMock(),
            config: ConfigMock(),
            storage: CoreStorageMock()
        )
        
        PrimaryCourseDashboardView(
            viewModel: vm,
            router: DashboardRouterMock(),
            programView: EmptyView(),
            openDiscoveryPage: {
            }
        )
        .preferredColorScheme(.light)
        .previewDisplayName("DashboardView Light")
        
        PrimaryCourseDashboardView(
            viewModel: vm,
            router: DashboardRouterMock(),
            programView: EmptyView(),
            openDiscoveryPage: {
            }
        )
        .preferredColorScheme(.dark)
        .previewDisplayName("DashboardView Dark")
    }
}
#endif
