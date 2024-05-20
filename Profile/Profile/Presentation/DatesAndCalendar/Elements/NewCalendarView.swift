//
//  NewCalendarView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 07.05.2024.
//

import SwiftUI
import Core
import Theme

struct NewCalendarView: View {
    
    enum Title {
        case newCalendar
        case changeSyncOptions
        
        var text: String {
            switch self {
            case .newCalendar:
                ProfileLocalization.Calendar.newCalendar
            case .changeSyncOptions:
                ProfileLocalization.Calendar.changeSyncOptions
            }
        }
    }
    
    @ObservedObject
    private var viewModel: DatesAndCalendarViewModel
    @Environment(\.isHorizontal) private var isHorizontal
    private var beginSyncingTapped: (() -> Void) = {}
    private var onCloseTapped: (() -> Void) = {}
    
    private let title: Title
    
    init(
        title: Title,
        viewModel: DatesAndCalendarViewModel,
        beginSyncingTapped: @escaping () -> Void,
        onCloseTapped: @escaping () -> Void
    ) {
        self.title = title
        self.viewModel = viewModel
        self.beginSyncingTapped = beginSyncingTapped
        self.onCloseTapped = onCloseTapped
    }
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            if isHorizontal {
                ScrollView {
                    content
                        .frame(maxWidth: 400)
                        .padding(24)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(Theme.Colors.background)
                        )
                        .padding(24)
                }
            } else {
                content
                    .frame(maxWidth: 400)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(Theme.Colors.background)
                    )
                    .padding(24)
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Text(title.text)
                    .font(Theme.Fonts.titleLarge)
                    .bold()
                Spacer()
                Button(action: {
                    onCloseTapped()
                }, label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .frame(width: 12, height: 12)
                })
            }
            .padding(.bottom, 20)
            Text(ProfileLocalization.Calendar.account)
                .font(Theme.Fonts.bodySmall).bold()
            DropDownPicker(selection: $viewModel.accountSelection, state: .bottom, options: viewModel.accounts)
            
            Text(ProfileLocalization.Calendar.calendarName)
                .font(Theme.Fonts.bodySmall).bold()
                .padding(.top, 16)
            TextField(viewModel.calendarNameHint, text: $viewModel.calendarName)
                .font(Theme.Fonts.bodyLarge)
                .padding()
                .background(Theme.Colors.background)
                .cornerRadius(8)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Theme.Colors.textInputStroke, lineWidth: 1)
                        .padding(1)
                )
            
            Text(ProfileLocalization.Calendar.color)
                .font(Theme.Fonts.bodySmall).bold()
                .padding(.top, 16)
            DropDownPicker(selection: $viewModel.colorSelection, state: .bottom, options: viewModel.colors)
            
            Text(ProfileLocalization.Calendar.upcomingAssignments)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(.vertical, 16)
                .multilineTextAlignment(.center)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .center
                )
            
            VStack(spacing: 16) {
                StyledButton(ProfileLocalization.Calendar.cancel,
                             action: {
                    onCloseTapped()
                },
                             color: Theme.Colors.background,
                             textColor: Theme.Colors.accentColor,
                             borderColor: Theme.Colors.accentColor
                )
                
                StyledButton(ProfileLocalization.Calendar.beginSyncing) {
                    beginSyncingTapped()
                }
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                alignment: .center
            )
        }
        .frame(maxWidth: 360)
    }
}

#if DEBUG
#Preview {
    NewCalendarView(
        title: .newCalendar,
        viewModel: DatesAndCalendarViewModel(router: ProfileRouterMock()),
        beginSyncingTapped: {},
        onCloseTapped: {}
    )
    .loadFonts()
}
#endif
