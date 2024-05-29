//
//  SyncCalendarOptionsView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Theme
import Core

public struct SyncCalendarOptionsView: View {
    
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
                
                VStack(spacing: 8) {
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
                            if let colorSelectionColor = viewModel.colorSelection?.color {
                                optionTitle(ProfileLocalization.CalendarSync.title)
                                    .padding(.top, 24)
                                AssignmentStatusView(
                                    title: viewModel.calendarName,
                                    status: $viewModel.assignmentStatus,
                                    calendarColor: colorSelectionColor
                                )
                                .padding(.horizontal, 24)
                            }
                            ToggleWithDescriptionView(
                                text: ProfileLocalization.CourseCalendarSync.title,
                                description: viewModel.reconnectRequired
                                ? ProfileLocalization.CourseCalendarSync.Description.reconnectRequired
                                : ProfileLocalization.CourseCalendarSync.Description.syncing,
                                toggle: $viewModel.courseCalendarSync,
                                showAlertIcon: $viewModel.reconnectRequired
                            )
                            .padding(.vertical, 24)
                            .padding(.horizontal, 24)
                            
                            StyledButton(
                                viewModel.reconnectRequired
                                ? ProfileLocalization.CourseCalendarSync.Button.reconnect
                                : ProfileLocalization.CourseCalendarSync.Button.changeSyncOptions,
                                action: {
                                    screenDimmed = true
                                    withAnimation(.bouncy(duration: 0.3)) {
                                        if viewModel.reconnectRequired {
                                            viewModel.showCalendaAccessDenided = true
                                        } else {
                                            viewModel.openChangeSyncView = true
                                        }
                                    }
                                },
                                color: viewModel.reconnectRequired
                                ? Theme.Colors.accentColor
                                : Theme.Colors.background,
                                textColor: viewModel.reconnectRequired
                                ? Theme.Colors.styledButtonText
                                : Theme.Colors.accentColor,
                                borderColor: viewModel.reconnectRequired
                                ? .clear
                                : Theme.Colors.accentColor
                            )
                            .padding(.horizontal, 24)
                            if !viewModel.reconnectRequired {
                                optionTitle(ProfileLocalization.CoursesToSync.title)
                                    .padding(.top, 24)
                                coursesToSync
                                    .padding(.bottom, 24)
                            }
                           relativeDatesToggle
                        }
                        .padding(.horizontal, isHorizontal ? 48 : 0)
                        .frameLimit(width: proxy.size.width)
                    }
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
                            viewModel.openChangeSyncView = false
                            viewModel.showCalendaAccessDenided = false
                            screenDimmed = false
                        }
                }
                if viewModel.openChangeSyncView {
                    NewCalendarView(
                        title: .changeSyncOptions,
                        viewModel: viewModel,
                        beginSyncingTapped: {},
                        onCloseTapped: {
                            viewModel.openChangeSyncView = false
                            screenDimmed = false
                        }
                    )
                    .transition(.move(edge: .bottom))
                    .frame(alignment: .center)
                } else if viewModel.showCalendaAccessDenided {
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
                }
                
            }
            .ignoresSafeArea(.all, edges: .horizontal)
        }
    }
    
    // MARK: - Options Title
    
    private func optionTitle(_ text: String) -> some View {
        Text(text)
            .multilineTextAlignment(.leading)
            .font(Theme.Fonts.labelLarge)
            .foregroundStyle(Theme.Colors.textPrimary)
            .padding(.horizontal, 24)
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .leading
            )
    }
    
    // MARK: - Courses to Sync
    @ViewBuilder
    private var coursesToSync: some View {
        
        VStack(alignment: .leading, spacing: 27) {
            Button(action: {
                //                viewModel.trackProfileVideoSettingsClicked()
                viewModel.router.showCoursesToSync()
            },
                   label: {
                HStack {
                    Text(
                        String(
                            format: ProfileLocalization.CoursesToSync.syncingCourses(
                                viewModel.coursesForSync.count
                            )
                        )
                    )
                        .font(Theme.Fonts.titleMedium)
                    Spacer()
                    Image(systemName: "chevron.right")
                }
            })
            .accessibilityIdentifier("courses_to_sync_cell")
            
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ProfileLocalization.settingsVideo)
        .cardStyle(
            bgColor: Theme.Colors.textInputUnfocusedBackground,
            strokeColor: .clear
        )
    }
    
    @ViewBuilder
    private var relativeDatesToggle: some View {
        Divider()
            .padding(.horizontal, 24)
        
        optionTitle(ProfileLocalization.Options.title)
            .padding(.vertical, 16)
        ToggleWithDescriptionView(
            text: ProfileLocalization.Options.useRelativeDates,
            description: ProfileLocalization.Options.showRelativeDates,
            toggle: $viewModel.reconnectRequired
        )
        .padding(.horizontal, 24)
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
struct SyncCalendarOptionsView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = DatesAndCalendarViewModel(
            router: ProfileRouterMock()
        )
        SyncCalendarOptionsView(viewModel: vm)
            .loadFonts()
    }
}
#endif
