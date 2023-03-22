//
//  DiscoveryView.swift
//  Discovery
//
//  Created by Vladimir Chekyrta on 15.09.2022.
//

import SwiftUI
import Core

public struct DiscoveryView: View {
    
    @ObservedObject
    private var viewModel: DiscoveryViewModel
    private let router: DiscoveryRouter
    @State private var isRefreshing: Bool = false
    
    private let discoveryNew: some View = VStack(alignment: .leading) {
        Text(DiscoveryLocalization.Header.title1)
            .font(Theme.Fonts.displaySmall)
            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
        Text(DiscoveryLocalization.Header.title2)
            .font(Theme.Fonts.titleSmall)
            .foregroundColor(CoreAssets.textPrimary.swiftUIColor)
        }.listRowBackground(Color.clear)
    
    public init(viewModel: DiscoveryViewModel, router: DiscoveryRouter) {
        self.viewModel = viewModel
        self.router = router
        Task {
            await viewModel.discovery(page: 1)
        }
    }
    
    public var body: some View {
        ZStack(alignment: .top) {
            
            // MARK: - Page name
            VStack(alignment: .center) {
                ZStack {
                    
                    Text(DiscoveryLocalization.title)
                        .titleSettings(top: 10)
                    
                }
                
                // MARK: - Search fake field
                HStack(spacing: 11) {
                    Image(systemName: "magnifyingglass")
                        .padding(.leading, 16)
                        .padding(.top, 1)
                    Text(DiscoveryLocalization.search)
                        .foregroundColor(CoreAssets.textSecondary.swiftUIColor)
                    Spacer()
                }
                .onTapGesture {
                    router.showDiscoverySearch()
                }
                .frame(minHeight: 48)
                .frame(maxWidth: 532)
                .background(
                    Theme.Shapes.textInputShape
                        .fill(CoreAssets.textInputUnfocusedBackground.swiftUIColor)
                )
                .overlay(
                    Theme.Shapes.textInputShape
                        .stroke(lineWidth: 1)
                        .fill(CoreAssets.textInputUnfocusedStroke.swiftUIColor)
                ).onTapGesture {
                    router.showDiscoverySearch()
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 20)
                
                ZStack {
                    RefreshableScrollViewCompat(action: {
                        viewModel.courses = []
                        viewModel.totalPages = 1
                        viewModel.nextPage = 1
                        await viewModel.discovery(page: 1)
                    }) {
                        LazyVStack(spacing: 0) {
                            HStack {
                                discoveryNew
                                    .padding(.horizontal, 20)
                                    .padding(.bottom, 20)
                                Spacer()
                            }.padding(.leading, 10)
                            ForEach(Array(viewModel.courses.enumerated()), id: \.offset) { index, course in
                                CourseCellView(model: course,
                                               type: .discovery,
                                               index: index,
                                               cellsCount: viewModel.courses.count)
                                    .padding(.horizontal, 24)
                                    .onAppear {
                                        Task {
                                           await viewModel.getDiscoveryCourses(index: index)
                                        }
                                    }
                                    .onTapGesture {
                                        router.showCourseDetais(
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
                    }.frameLimit()
                }
            }
            
            // MARK: - Offline mode SnackBar
            OfflineSnackBarView(connectivity: viewModel.connectivity,
                                reloadAction: {
                await viewModel.discovery(page: 1, withProgress: isIOS14)
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
        .background(CoreAssets.background.swiftUIColor.ignoresSafeArea())
    }
}

#if DEBUG
struct DiscoveryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DiscoveryViewModel(interactor: DiscoveryInteractor.mock, connectivity: Connectivity())
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
