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
            VStack(spacing: 0) {
                titleAndSettings(proxy: proxy)
                    .zIndex(1)
                ZStack(alignment: .top) {
                    if viewModel.isShowProgress && !viewModel.noDates {
                        VStack(alignment: .center) {
                            ProgressBar(size: 40, lineWidth: 8)
                        }.frame(maxWidth: .infinity,
                                maxHeight: .infinity)
                    } else {
                        ScrollView {
                            if !viewModel.isShowProgress && viewModel.noDates {
                                DatesEmptyStateView()
                            }
                            if viewModel.showShiftDueDatesView {
                                ShiftDueDatesView(
                                    isShowProgressForDueDates: $viewModel.isShowProgressForDueDates,
                                    onShiftButtonTap: {
                                        Task {
                                            await viewModel.shiftDueDates()
                                        }
                                    }
                                )
                                .padding(.horizontal, 24)
                                .padding(.bottom, 16)
                            }
                            LazyVStack(spacing: 16) {
                                ForEach(viewModel.coursesDates, id: \.id) { group in
                                        LazyVStack(alignment: .leading, spacing: 0) {
                                            Text(group.type.text)
                                                .font(Theme.Fonts.titleMedium)
                                                .foregroundColor(Theme.Colors.textPrimary)
                                                .padding(.bottom, 8)
                                                .padding(.top, 4)
                                            
                                            ForEach(
                                                Array(group.dates.enumerated()),
                                                id: \.element.id
                                            ) { index, date in
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
                                                .id(UUID())
                                                .onAppear {
                                                    Task {
                                                        await viewModel.loadNextPageIfNeeded(for: date)
                                                }
                                            }
                                        }
                                    }
                                    .id(group.id)
                                }
                                
                                // Loading more indicator
                                if viewModel.isLoadingNextPage || viewModel.delayedLoadSecondPage {
                                    ProgressBar(size: 40, lineWidth: 8)
                                        .padding(.top, 20)
                                }
                            }
                            .padding(.horizontal, 24)
                            Spacer(minLength: 100)
                        }
                        .frameLimit(width: proxy.size.width)
                        .refreshableWithoutCancellation {
                            await viewModel.loadDates(isRefresh: true)
                        }
                    }
                    // MARK: - Offline mode SnackBar
                    OfflineSnackBarView(
                        connectivity: viewModel.connectivity,
                        reloadAction: {
                            Task {
                                await viewModel.loadDates(isRefresh: true)
                            }
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
            }
            .onFirstAppear {
                Task {
                    await viewModel.loadDates()
                }
            }
        }
        .accessibilityAction {}
        .padding(.top, 8)
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .background(
            Theme.Colors.background
                .ignoresSafeArea()
        )
    }
    
    private func titleAndSettings(proxy: GeometryProxy) -> some View {
        ZStack(alignment: .top) {
            Theme.Colors.background
                .frame(height: 64)
            ZStack(alignment: .topTrailing) {
                VStack {
                    HStack(alignment: .center) {
                        Text(AppDatesLocalization.Dates.title)
                            .font(Theme.Fonts.displaySmall)
                            .foregroundColor(Theme.Colors.textPrimary)
                            .accessibilityIdentifier("dates_header_text")
                        Spacer()
                    }
                }
                .frameLimit(width: proxy.size.width)
                
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.router.showSettings()
                    }, label: {
                        CoreAssets.settings.swiftUIImage.renderingMode(.template)
                            .foregroundColor(Theme.Colors.accentColor)
                    })
                }
                .padding(.top, 8)
                .offset(x: UIDevice.current.userInterfaceIdiom == .pad ? 1 : 5,
                        y: UIDevice.current.userInterfaceIdiom == .pad ? 4 : -5)
            }
            .listRowBackground(Color.clear)
            .padding(.horizontal, 20)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(AppDatesLocalization.Dates.title)
        }
    }
}

struct DatesEmptyStateView: View {
    @Environment(\.isHorizontal) private var isHorizontal
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
        .padding(.top, isHorizontal ? 20 : 200)
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
    }
}

#if DEBUG
#Preview {
    DatesView(
        viewModel: DatesViewModel(
            interactor: DatesInteractor.mock,
            connectivity: Connectivity(),
            courseManager: CourseStructureManagerMock(),
            analytics: AppDatesAnalyticsMock(),
            router: AppDatesRouterMock()
        )
    )
}
#endif
