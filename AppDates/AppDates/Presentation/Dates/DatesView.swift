//
//  DatesView.swift
//  AppDates
//
//  Created by Ivan Stepanok on 15.02.2025.
//

import SwiftUI
import Theme
import OEXFoundation
import Core

public struct DatesView: View {
    
    @StateObject private var viewModel: DatesViewModel
    
    public init(viewModel: DatesViewModel) {
        self._viewModel = StateObject(wrappedValue: { viewModel }())
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack {
                if viewModel.isShowProgress {
                    VStack(alignment: .center) {
                        ProgressBar(size: 40, lineWidth: 8)
                    }.frame(maxWidth: .infinity,
                            maxHeight: .infinity)
                } else {
                    ScrollView {
                        if !viewModel.isShowProgress && viewModel.coursesDates.isEmpty {
                            DatesEmptyStateView()
                        }
                        VStack(spacing: 24) {
                            ForEach(viewModel.coursesDates) { group in
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(group.type.text)
                                        .font(Theme.Fonts.titleMedium)
                                        .foregroundColor(Theme.Colors.textPrimary)
                                        .padding(.bottom, 8)
                                        .padding(.top, 8)
                                    
                                    ForEach(Array(group.dates.enumerated()), id: \.element.id) { index, date in
                                        Button(action: {
                                            Task {
                                               await viewModel.openVertical(date: date)
                                            }
                                        }, label: {
                                            DateCell(
                                                courseDate: date,
                                                groupType: group.type,
                                                isFirst: index == 0,
                                                isLast: index == group.dates.count - 1
                                            )
                                        })
                                    }
                                }
                            }
                            
                            // Loading more indicator
                            if viewModel.isLoadingNextPage {
                                ProgressBar(size: 40, lineWidth: 8)
                            }
                        }
                        .padding(.horizontal, 24)
                        Spacer(minLength: 100)
                        
                        GeometryReader { geometry in
                            Color.clear
                                .preference(key: ScrollViewOffsetPreferenceKey.self,
                                            value: geometry.frame(in: .named("scrollView")).maxY)
                                .onAppear {
                                    Task {
                                        await viewModel.loadNextPageIfNeeded()
                                    }
                                }
                        }
                        .frame(height: 20)
                    }
                    .frameLimit(width: proxy.size.width)
                    .coordinateSpace(name: "scrollView")
                    .refreshable {
                        Task {
                           await viewModel.loadDates(isRefresh: true)
                        }
                    }
                }
                // MARK: - Offline mode SnackBar
                OfflineSnackBarView(
                    connectivity: viewModel.connectivity,
                    reloadAction: {
                        
                    }
                )
                
                // MARK: - Error Alert
                if viewModel.showError {
                    VStack {
                        Spacer()
                        SnackBarView(message: viewModel.errorMessage)
                    }
                    .padding(
                        .bottom,
                        viewModel.connectivity.isInternetAvaliable
                        ? 0 : OfflineSnackBarView.height
                    )
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        doAfter(Theme.Timeout.snackbarMessageLongTimeout) {
                            viewModel.errorMessage = nil
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.loadDates()
                }
            }
        }
        .accessibilityAction {}
        .padding(.top, 8)
        .navigationBarHidden(false)
        .navigationBarBackButtonHidden(false)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
}

// To track scroll position
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct DatesEmptyStateView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            CoreAssets.dates.swiftUIImage
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundStyle(Theme.Colors.textSecondaryLight)
                .accessibilityIdentifier("empty_page_image")
            Text(AppDatesLocalization.Empty.title)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.titleMedium)
                .accessibilityIdentifier("empty_page_subtitle_text")
            Text(AppDatesLocalization.Empty.subtitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.labelMedium)
                .frame(width: 245)
                .accessibilityIdentifier("empty_page_subtitle_text")
        }
        .padding(.top, 200)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
    }
}

#if DEBUG
#Preview {
    DatesView(
        viewModel: DatesViewModel(
            interactor: DatesViewInteractor.mock,
            connectivity: Connectivity(),
            courseManager: CourseStructureManagerMock(),
            router: AppDatesRouterMock()
        )
    )
}
#endif
