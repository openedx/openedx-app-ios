//
//  DashboardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import SwiftUI
import Core

public struct DashboardView: View {
    private let dashboardCourses: some View = VStack(alignment: .leading) {
        Text(DashboardLocalization.Header.courses)
            .font(Theme.Fonts.displaySmall)
            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
        Text(DashboardLocalization.Header.welcomeBack)
            .font(Theme.Fonts.titleSmall)
            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
    }.listRowBackground(Color.clear)
        .padding(.top, 24)
    
    @ObservedObject
    private var viewModel: DashboardViewModel
    private let router: DashboardRouter
    
    public init(viewModel: DashboardViewModel, router: DashboardRouter) {
        self.viewModel = viewModel
        self.router = router
        Task {
            await viewModel.getMyCourses(page: 1)
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                ZStack {
                    Text(DashboardLocalization.title)
                        .titleSettings()

                }
                
                ZStack {
                    RefreshableScrollViewCompat(action: {
                        await viewModel.getMyCourses(page: 1,
                                                     withProgress: isIOS14,
                                                     refresh: true)
                    }) {
                        if !viewModel.fetchInProgress || viewModel.courses.isEmpty {
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
                    }.frameLimit()
                }
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.getMyCourses( page: 1,
                                              withProgress: isIOS14,
                                              refresh: true)
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

#if DEBUG
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DashboardViewModel(
            interactor: DashboardInteractor.mock,
            connectivity: Connectivity()
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
                .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
                .padding(.bottom, 8)
            Text(DashboardLocalization.Empty.subtitle)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
        }
        .padding(.top, 200)
    }
}
