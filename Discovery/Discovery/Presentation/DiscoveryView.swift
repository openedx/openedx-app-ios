//
//  DiscoveryView.swift
//  Discovery
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import SwiftUI
import Core

public struct DiscoveryView: View {
    
    @StateObject
    private var viewModel: DiscoveryViewModel
    private var router: DiscoveryRouter
    @State private var isRefreshing: Bool = false
    
    private var fromStartupScreen: Bool = false
    
    @Environment (\.isHorizontal) private var isHorizontal
    @Environment(\.presentationMode) private var presentationMode
    
    private let discoveryNew: some View = VStack(alignment: .leading) {
        Text(DiscoveryLocalization.Header.title1)
            .font(Theme.Fonts.displaySmall)
            .foregroundColor(Theme.Colors.textPrimary)
        Text(DiscoveryLocalization.Header.title2)
            .font(Theme.Fonts.titleSmall)
            .foregroundColor(Theme.Colors.textPrimary)
    }.listRowBackground(Color.clear)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(DiscoveryLocalization.Header.title1 + DiscoveryLocalization.Header.title2)
    
    public init(viewModel: DiscoveryViewModel, router: DiscoveryRouter, searchQuery: String? = nil, fromStartupScreen: Bool = false) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
        self.router = router
        self.fromStartupScreen = fromStartupScreen
        viewModel.searchQuery = searchQuery
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                
                // MARK: - Search fake field
                HStack(spacing: 11) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 16)
                        .padding(.top, 1)
                    Text(DiscoveryLocalization.search)
                        .foregroundColor(Theme.Colors.textSecondary)
                    Spacer()
                }
                .onTapGesture {
                    router.showDiscoverySearch(searchQuery: viewModel.searchQuery)
                    viewModel.discoverySearchBarClicked()
                }
                .frame(minHeight: 48)
                .frame(maxWidth: .infinity)
                .background(
                    Theme.Shapes.textInputShape
                        .fill(Theme.Colors.textInputUnfocusedBackground)
                )
                .overlay(
                    Theme.Shapes.textInputShape
                        .stroke(lineWidth: 1)
                        .fill(Theme.Colors.textInputUnfocusedStroke)
                ).onTapGesture {
                    router.showDiscoverySearch(searchQuery: viewModel.searchQuery)
                    viewModel.discoverySearchBarClicked()
                }
                .padding(.top, 11.5)
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(DiscoveryLocalization.search)
                
                ZStack {
                    RefreshableScrollViewCompat(action: {
                        viewModel.totalPages = 1
                        viewModel.nextPage = 1
                        Task {
                            await viewModel.discovery(page: 1, withProgress: false)
                        }
                    }) {
                        LazyVStack(spacing: 0) {
                            HStack {
                                discoveryNew
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                Spacer()
                            }.padding(.leading, 10)
                            ForEach(Array(viewModel.courses.enumerated()), id: \.offset) { index, course in
                                CourseCellView(
                                    model: course,
                                    type: .discovery,
                                    index: index,
                                    cellsCount: viewModel.courses.count
                                ).padding(.horizontal, 24)
                                    .onAppear {
                                        Task {
                                            await viewModel.getDiscoveryCourses(index: index)
                                        }
                                    }
                                    .onTapGesture {
                                        viewModel.discoveryCourseClicked(
                                            courseID: course.courseID,
                                            courseName: course.name
                                        )
                                        viewModel.router.showCourseDetais(
                                            courseID: course.courseID,
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
                    .frameLimit()
                }.accessibilityAction {}
            }.padding(.top, 8)
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(
                connectivity: viewModel.connectivity,
                reloadAction: {
                    await viewModel.discovery(page: 1, withProgress: false)
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
        .navigationBarHidden(fromStartupScreen ? false : true)
        .onFirstAppear {
            if !(viewModel.searchQuery?.isEmpty ?? true) {
                router.showDiscoverySearch(searchQuery: viewModel.searchQuery)
            }
            Task {
                await viewModel.discovery(page: 1)
            }
            viewModel.setupNotifications()
        }
        .onDisappear {
            viewModel.searchQuery = ""
        }
        .background(Theme.Colors.background.ignoresSafeArea())
    }
}

#if DEBUG
struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiscoveryViewModel(router: DiscoveryRouterMock(),
                                    config: ConfigMock(),
                                    interactor: DiscoveryInteractor.mock,
                                    connectivity: Connectivity(),
                                    analytics: DiscoveryAnalyticsMock())
        let router = DiscoveryRouterMock()
        
        DiscoveryView(viewModel: vm, router: router)
            .preferredColorScheme(.light)
            .previewDisplayName("DiscoveryView Light")
        
        DiscoveryView(viewModel: vm, router: router)
            .preferredColorScheme(.dark)
            .previewDisplayName("DiscoveryView Dark")
    }
}
#endif
