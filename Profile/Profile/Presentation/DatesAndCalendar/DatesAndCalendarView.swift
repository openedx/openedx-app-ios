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
//                        relativeDatesToggle
                        }
                        .padding(.horizontal, isHorizontal ? 48 : 0)
                    }
                    .frameLimit(width: proxy.size.width)
                    .roundedBackground(Theme.Colors.background)
                    .ignoresSafeArea(.all, edges: .bottom)
                }
                .navigationBarHidden(true)
                .navigationBarBackButtonHidden(true)
                
                // Error Alert if needed
                if viewModel.showError {
                    ErrorAlertView(errorMessage: $viewModel.errorMessage)
                }
                if screenDimmed {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            viewModel.openNewCalendarView = false
                            screenDimmed = false
                        }
                }
                if viewModel.openNewCalendarView {
                    NewCalendarView(
                        title: .newCalendar,
                        viewModel: viewModel,
                        beginSyncingTapped: {
                            if viewModel.calendarName == "" {
                                viewModel.calendarName = viewModel.calendarNameHint
                            }
                            viewModel.router.showSyncCalendarOptions() },
                        onCloseTapped: {
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
                
                if viewModel.showCalendaAccessDenided {
                    CalendarDialogView(
                        type: .calendarAccess,
                        action: {
                            viewModel.showCalendaAccessDenided = false
                            screenDimmed = false
                            viewModel.openAppSettings()
                        },
                        onCloseTapped: {
                            viewModel.showCalendaAccessDenided = false
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
                    
                    StyledButton(ProfileLocalization.CalendarSync.button, action: {
                        viewModel.requestCalendarPermission()
                    }, horizontalPadding: true)
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

    // MARK: - Options Toggle
    private var relativeDatesToggle: some View {
        VStack(alignment: .leading) {
            Text(ProfileLocalization.Options.title)
                .font(Theme.Fonts.labelLarge)
                .foregroundColor(Theme.Colors.textPrimary)
            HStack(spacing: 16) {
                Toggle("", isOn: $viewModel.useRelativeDates)
                    .frame(width: 50)
                    .tint(Theme.Colors.accentColor)
                Text(ProfileLocalization.Options.useRelativeDates)
                    .font(Theme.Fonts.bodyLarge)
                    .foregroundColor(Theme.Colors.textPrimary)
            }
            Text(ProfileLocalization.Options.showRelativeDates)
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .padding(.horizontal, 24)
        .frame(minWidth: 0,
                maxWidth: .infinity,
                alignment: .top)
        .accessibilityIdentifier("relative_dates_toggle")
    }

    // MARK: - Error Alert View
    private var errorAlertView: some View {
        VStack {
            Spacer()
            SnackBarView(message: viewModel.errorMessage)
                .transition(.move(edge: .bottom))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + Theme.Timeout.snackbarMessageLongTimeout) {
                        viewModel.errorMessage = nil
                    }
                }
        }
    }
}

#if DEBUG
struct DatesAndCalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DatesAndCalendarViewModel(
            router: ProfileRouterMock()
        )
        DatesAndCalendarView(viewModel: vm)
            .loadFonts()
    }
}
#endif

