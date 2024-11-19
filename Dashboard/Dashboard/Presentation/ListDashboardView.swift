//
//  ListDashboardView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 19.09.2022.
//

import SwiftUI
import Core
import OEXFoundation
import Theme

public struct ListDashboardView: View {
    private let dashboardCourses: some View = VStack(alignment: .leading) {
        Text(DashboardLocalization.Header.courses)
            .font(Theme.Fonts.displaySmall)
            .foregroundColor(Theme.Colors.textPrimary)
            .accessibilityIdentifier("courses_header_text")
        Text(DashboardLocalization.Header.welcomeBack)
            .font(Theme.Fonts.titleSmall)
            .foregroundColor(Theme.Colors.textPrimary)
            .accessibilityIdentifier("courses_welcomeback_text")
    }.listRowBackground(Color.clear)
        .padding(.top, 24)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(DashboardLocalization.Header.courses + DashboardLocalization.Header.welcomeBack)
    
    @StateObject
    private var viewModel: ListDashboardViewModel
    private let router: DashboardRouter
    private var idiom: UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    
    public init(viewModel: ListDashboardViewModel, router: DashboardRouter) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.router = router
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                
                // MARK: - Page body
                VStack(alignment: .center) {
                    ScrollView {
                        Group {
                            LazyVStack(spacing: 0) {
                                HStack {
                                    dashboardCourses
                                        .padding(.horizontal, 20)
                                        .padding(.bottom, 20)
                                    Spacer()
                                }.padding(.leading, 10)
                                if viewModel.courses.isEmpty && !viewModel.fetchInProgress {
                                    EmptyPageIcon()
                                } else {
                                    let useRelativeDates = viewModel.storage.useRelativeDates
                                    ForEach(Array(viewModel.courses.enumerated()),
                                            id: \.offset) { index, course in
                                        CourseCellView(
                                            model: course,
                                            type: .dashboard,
                                            index: index,
                                            cellsCount: viewModel.courses.count,
                                            useRelativeDates: useRelativeDates
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
                                                hasAccess: course.hasAccess,
                                                courseStart: course.courseStart,
                                                courseEnd: course.courseEnd,
                                                enrollmentStart: course.enrollmentStart,
                                                enrollmentEnd: course.enrollmentEnd,
                                                title: course.name,
                                                courseRawImage: course.courseRawImage,
                                                showDates: false,
                                                lastVisitedBlockID: nil
                                            )
                                        }
                                        .accessibilityIdentifier("course_item")
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
                        .frameLimit(width: proxy.size.width)
                    }
                    .refreshable {
                        Task {
                            await viewModel.getMyCourses(page: 1, refresh: true)
                        }
                    }
                    .accessibilityAction {}
                }.padding(.top, 8)
                HStack {
                    Spacer()
                    Button(action: {
                        router.showSettings()
                    }, label: {
                        CoreAssets.settings.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                }
                .padding(.top, idiom == .pad ? 13 : 5)
                .padding(.trailing, idiom == .pad ? 20 : 16)
                
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
}

#if DEBUG
struct ListDashboardView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ListDashboardViewModel(
            interactor: DashboardInteractor.mock,
            connectivity: Connectivity(),
            analytics: DashboardAnalyticsMock(),
            storage: CoreStorageMock()
        )
        let router = DashboardRouterMock()
        
        ListDashboardView(viewModel: vm, router: router)
            .preferredColorScheme(.light)
            .previewDisplayName("ListDashboardView Light")
        
        ListDashboardView(viewModel: vm, router: router)
            .preferredColorScheme(.dark)
            .previewDisplayName("ListDashboardView Dark")
    }
}
#endif

struct EmptyPageIcon: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CoreAssets.dashboardEmptyPage.swiftUIImage
                .padding(.bottom, 16)
                .accessibilityIdentifier("empty_page_image")
            Text(DashboardLocalization.Empty.subtitle)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(Theme.Colors.textSecondary)
                .accessibilityIdentifier("empty_page_subtitle_text")
        }
        .padding(.top, 200)
    }
}
