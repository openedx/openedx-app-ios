//
//  DatesAndCalendarView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 12.04.2024.
//

import SwiftUI
import Theme
import Core

public struct DatesAndCalendarView: View {
    
    @ObservedObject
    private var viewModel: DatesAndCalendarViewModel
    
    @State private var screenDimmed: Bool = false
    
    @Environment(\.isHorizontal) private var isHorizontal
    
    public init(viewModel: DatesAndCalendarViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .top) {
                ThemeAssets.headerBackground.swiftUIImage
                    .resizable()
                    .edgesIgnoringSafeArea(.top)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .accessibilityIdentifier("title_bg_image")
                
                VStack {
                    // MARK: Navigation and Title
                    NavigationTitle(
                        title: ProfileLocalization.DatesAndCalendar.title,
                        backAction: {
                            viewModel.router.back()
                        }
                    )
                    
                    // MARK: Body
                    ScrollView {
                        Group {
                            calendarSyncCard
                            RelativeDatesToggleView(useRelativeDates: $viewModel.profileStorage.useRelativeDates)
                        }
                        .padding(.horizontal, isHorizontal ? 48 : 0)
                    }
                    .frameLimit(width: proxy.size.width)
                    .roundedBackground(Theme.Colors.background)
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                if screenDimmed {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.openNewCalendarView = false
                            screenDimmed = false
                            viewModel.showCalendaAccessDenied = false
                            viewModel.calendarName = viewModel.oldCalendarName
                            viewModel.colorSelection = viewModel.oldColorSelection
                        }
                }
                
                // Error Alert if needed
                if viewModel.showError {
                    ErrorAlertView(errorMessage: $viewModel.errorMessage)
                }
                
                if viewModel.openNewCalendarView {
                    NewCalendarView(
                        title: .newCalendar,
                        viewModel: viewModel,
                        beginSyncingTapped: {
                            guard viewModel.isInternetAvaliable else {
                                viewModel.openNewCalendarView = false
                                screenDimmed = false
                                viewModel.calendarName = viewModel.oldCalendarName
                                viewModel.colorSelection = viewModel.oldColorSelection
                                return
                            }
                            if viewModel.calendarName == "" {
                                viewModel.calendarName = viewModel.calendarNameHint
                            }
                            viewModel.saveCalendarOptions()
                            viewModel.router.back(animated: false)
                            viewModel.router.showSyncCalendarOptions()
                        },
                        onCloseTapped: {
                            viewModel.calendarName = viewModel.oldCalendarName
                            viewModel.colorSelection = viewModel.oldColorSelection
                            viewModel.openNewCalendarView = false
                            screenDimmed = false
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .frame(alignment: .center)
                    .onAppear {
                        screenDimmed = true
                    }
                }
                
                if viewModel.showCalendaAccessDenied {
                    CalendarDialogView(
                        type: .calendarAccess,
                        action: {
                            viewModel.showCalendaAccessDenied = false
                            screenDimmed = false
                            viewModel.openAppSettings()
                        },
                        onCloseTapped: {
                            viewModel.showCalendaAccessDenied = false
                            screenDimmed = false
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .frame(alignment: .center)
                    .onAppear {
                        screenDimmed = true
                    }
                }
                
            }
            .ignoresSafeArea(.all, edges: .horizontal)
        }
    }

    // MARK: - Calendar Sync Card
    private var calendarSyncCard: some View {
        VStack(alignment: .leading) {
            Text(ProfileLocalization.CalendarSync.title)
                .multilineTextAlignment(.leading)
                .padding(.top, 24)
                .padding(.horizontal, 24)
                .font(Theme.Fonts.bodyMedium)
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .center, spacing: 16) {
                    CoreAssets.calendarSyncIcon.swiftUIImage
                        .foregroundStyle(Theme.Colors.textPrimary)
                        .padding(.bottom, 16)
                    
                    Text(ProfileLocalization.CalendarSync.title)
                        .font(Theme.Fonts.bodyLarge)
                        .bold()
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityIdentifier("calendar_sync_title")
                    
                    Text(ProfileLocalization.CalendarSync.description)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundColor(Theme.Colors.textPrimary)
                        .accessibilityIdentifier("calendar_sync_description")
                    
                    StyledButton(
                        ProfileLocalization.CalendarSync.button,
                        action: {
                            Task {
                                await viewModel.requestCalendarPermission()
                            }
                        },
                        horizontalPadding: true
                    )
                    .fixedSize()
                    .accessibilityIdentifier("calendar_sync_button")
                }
                .frame(minWidth: 0,
                       maxWidth: .infinity,
                       alignment: .top)
                .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.top, 24)
            .cardStyle(bgColor: Theme.Colors.textInputUnfocusedBackground, strokeColor: .clear)
        }
    }
}

#if DEBUG
struct DatesAndCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DatesAndCalendarViewModel(
            router: ProfileRouterMock(),
            interactor: ProfileInteractor(repository: ProfileRepositoryMock()),
            profileStorage: ProfileStorageMock(),
            persistence: ProfilePersistenceMock(),
            calendarManager: CalendarManagerMock(),
            connectivity: Connectivity()
        )
        DatesAndCalendarView(viewModel: vm)
            .loadFonts()
    }
}
#endif
