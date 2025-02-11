//
//  AllCoursesView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 24.04.2024.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

@MainActor
public struct AllCoursesView: View {
    
    @ObservedObject
    private var viewModel: AllCoursesViewModel
    private let router: DashboardRouter
    @Environment(\.isHorizontal) private var isHorizontal
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(viewModel: AllCoursesViewModel, router: DashboardRouter) {
        self.viewModel = viewModel
        self.router = router
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                VStack {
                    BackNavigationButton(
                        color: Theme.Colors.textPrimary,
                        action: {
                            router.back()
                        }
                    )
                    .backViewStyle()
                    .padding(.top, isHorizontal ? 32 : 16)
                    .padding(.leading, 7)
                    
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .topLeading)
                .zIndex(1)
                
                if let myEnrollments = viewModel.myEnrollments,
                   myEnrollments.courses.isEmpty,
                   !viewModel.fetchInProgress,
                   !viewModel.refresh {
                    NoCoursesView(selectedMenu: viewModel.selectedMenu)
                }
                // MARK: - Page body
                VStack(alignment: .center) {
                    learnTitleAndSearch()
                        .frameLimit(width: proxy.size.width)
                    ScrollView {
                        VStack(spacing: 0) {
                            CategoryFilterView(selectedOption: $viewModel.selectedMenu)
                                .disabled(viewModel.fetchInProgress)
                                .frameLimit(width: proxy.size.width)
                            if let myEnrollments = viewModel.myEnrollments {
                                let useRelativeDates = viewModel.storage.useRelativeDates
                                LazyVGrid(columns: columns(), spacing: 0) {
                                    ForEach(
                                        Array(myEnrollments.courses.enumerated()),
                                        id: \.offset
                                    ) { index, course in
                                        Button(action: {
                                            viewModel.trackDashboardCourseClicked(
                                                courseID: course.courseID,
                                                courseName: course.name
                                            )
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
                                                progressEarned: course.progressEarned,
                                                progressPossible: course.progressPossible,
                                                courseStartDate: course.courseStart,
                                                courseEndDate: course.courseEnd,
                                                hasAccess: course.hasAccess,
                                                showProgress: true,
                                                useRelativeDates: useRelativeDates
                                            ).padding(8)
                                        })
                                        .accessibilityIdentifier("course_item")
                                        .onAppear {
                                            Task {
                                                await viewModel.getMyCoursesPagination(index: index)
                                            }
                                        }
                                    }
                                }
                                .padding(10)
                                .frameLimit(width: proxy.size.width)
                            }
                            // MARK: - ProgressBar
                            if viewModel.nextPage <= viewModel.totalPages, !viewModel.refresh {
                                VStack(alignment: .center) {
                                    ProgressBar(size: 40, lineWidth: 8)
                                        .padding(.top, 20)
                                }.frame(maxWidth: .infinity,
                                        maxHeight: .infinity)
                            }
                            VStack {}.frame(height: 40)
                        }
                    }
                    .refreshable {
                        Task {
                            await viewModel.getCourses(page: 1, refresh: true)
                        }
                    }
                    .accessibilityAction {}
                }
                .padding(.top, 8)
                
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        await viewModel.getCourses(page: 1, refresh: true)
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
            }
            .onFirstAppear {
                Task {
                    await viewModel.getCourses(page: 1)
                }
            }
            .onChange(of: viewModel.selectedMenu) { _ in
                Task {
                    viewModel.myEnrollments?.courses = []
                    await viewModel.getCourses(page: 1, refresh: false)
                }
            }
            .background(
                Theme.Colors.background
                    .ignoresSafeArea()
            )
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
            .navigationTitle(DashboardLocalization.Learn.allCourses)
        }
    }
    
    private func columns() -> [GridItem] {
        isHorizontal || idiom == .pad
        ? [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
        : [
            GridItem(.flexible(), spacing: 0),
            GridItem(.flexible(), spacing: 0)
        ]
    }
    
    private func learnTitleAndSearch() -> some View {
        HStack(alignment: .center) {
            Text(DashboardLocalization.Learn.allCourses)
                .font(Theme.Fonts.displaySmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .accessibilityIdentifier("all_courses_header_text")
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
        .padding(.bottom, 10)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(DashboardLocalization.Learn.allCourses)
    }
}

#if DEBUG
struct AllCoursesView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = AllCoursesViewModel(
            interactor: DashboardInteractor.mock,
            connectivity: Connectivity(),
            analytics: DashboardAnalyticsMock(),
            storage: CoreStorageMock()
        )
        
        AllCoursesView(viewModel: vm, router: DashboardRouterMock())
            .preferredColorScheme(.light)
            .previewDisplayName("AllCoursesView Light")
        
        AllCoursesView(viewModel: vm, router: DashboardRouterMock())
            .preferredColorScheme(.dark)
            .previewDisplayName("AllCoursesView Dark")
    }
}
#endif
