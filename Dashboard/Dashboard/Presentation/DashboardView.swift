//
//  DashboardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import SwiftUI
import Core
import Theme

public struct DashboardView: View {
    private let dashboardCourses: some View = VStack(alignment: .leading) {
        Text(DashboardLocalization.Header.courses)
            .font(Theme.Fonts.displaySmall)
            .foregroundColor(Theme.Colors.textPrimary)
        Text(DashboardLocalization.Header.welcomeBack)
            .font(Theme.Fonts.titleSmall)
            .foregroundColor(Theme.Colors.textPrimary)
    }.listRowBackground(Color.clear)
        .padding(.top, 24)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(DashboardLocalization.Header.courses + DashboardLocalization.Header.welcomeBack)
    
    @StateObject
    private var viewModel: DashboardViewModel
    private let router: DashboardRouter
    
    public init(viewModel: DashboardViewModel, router: DashboardRouter) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.router = router
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page body
            VStack(alignment: .center) {
                RefreshableScrollViewCompat(action: {
                    await viewModel.getMyCourses(page: 1, refresh: true)
                }) {
                    Group {
                        if viewModel.courses.isEmpty && !viewModel.fetchInProgress {
                            EmptyPageIcon()
                        } else {
                            LazyVStack(spacing: 0) {
                                HStack {
                                    dashboardCourses
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 20)
                                    Spacer()
                                }.padding(.leading, 10)
                                ForEach(Array(viewModel.courses.enumerated()),
                                        id: \.offset) { index, course in
                                    
                                    CourseCellView(
                                        model: course,
                                        type: .dashboard,
                                        index: index,
                                        cellsCount: viewModel.courses.count
                                    )
                                    .padding(.horizontal, 20)
                                    .listRowBackground(Color.clear)
                                    .onAppear {
                                        Task {
                                            await viewModel.getMyCoursesPagination(index: index)
                                        }
                                    }
                                    .onTapGesture {
                                        viewModel.trackDashboardCourseClicked(
                                            courseID: course.courseID,
                                            courseName: course.name
                                        )
                                        router.showCourseScreens(
                                            courseID: course.courseID,
                                            isActive: course.isActive,
                                            courseStart: course.courseStart,
                                            courseEnd: course.courseEnd,
                                            enrollmentStart: course.enrollmentStart,
                                            enrollmentEnd: course.enrollmentEnd,
                                            title: course.name
                                        )
                                    }
                                }
                                // MARK: - ProgressBar
                                if viewModel.nextPage <= viewModel.totalPages {
                                    VStack(alignment: .center) {
                                        ProgressBar(size: 40, lineWidth: 8)
                                            .padding(.top, 20)
                                    }.frame(maxWidth: .infinity,
                                            maxHeight: .infinity)
                                }
                                VStack {}.frame(height: 40)
                            }
                        }
                    }
                }
                .accessibilityAction {}
                .if(!viewModel.shouldStretch, transform: { view in
                    view
                        .frameLimit()
                })
            }.padding(.top, 8)
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.getMyCourses(page: 1, refresh: true)
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
        .onFirstAppear {
            Task {
                await viewModel.getMyCourses(page: 1)
            }
        }
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
}

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DashboardViewModel(
            interactor: DashboardInteractor.mock,
            connectivity: Connectivity(),
            analytics: DashboardAnalyticsMock(),
            shouldStretch: false
        )
        let router = DashboardRouterMock()
        
        DashboardView(viewModel: vm, router: router)
            .preferredColorScheme(.light)
            .previewDisplayName("DashboardView Light")
        
        DashboardView(viewModel: vm, router: router)
            .preferredColorScheme(.dark)
            .previewDisplayName("DashboardView Dark")
    }
}
#endif

struct EmptyPageIcon: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CoreAssets.dashboardEmptyPage.swiftUIImage
                .padding(.bottom, 16)
            Text(DashboardLocalization.Empty.title)
                .font(Theme.Fonts.titleMedium)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.bottom, 8)
            Text(DashboardLocalization.Empty.subtitle)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(Theme.Colors.textSecondary)
        }
        .padding(.top, 200)
    }
}
