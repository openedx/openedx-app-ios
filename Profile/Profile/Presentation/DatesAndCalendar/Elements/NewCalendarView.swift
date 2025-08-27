//
//  NewCalendarView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 07.05.2024.
//

import SwiftUI
import Core
import Theme
import Combine

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
    @EnvironmentObject var themeManager: ThemeManager
    private var beginSyncingTapped: (() -> Void) = {}
    private var onCloseTapped: (() -> Void) = {}
    @State private var calendarName: String = ""
    
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
                       
                }
            } else {
                content
            }
        }
        .onAppear {
            calendarName = viewModel.calendarName
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
            
            Text(ProfileLocalization.Calendar.calendarName)
                .font(Theme.Fonts.bodySmall).bold()
                .padding(.top, 16)
            TextField(viewModel.calendarNameHint, text: $calendarName)
                .onReceive(Just(calendarName), perform: { _ in
                    limitText(40)
                })
                .font(Theme.Fonts.bodyLarge)
                .padding()
                .background(themeManager.theme.colors.background)
                .cornerRadius(8)
                .frame(height: 48)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.theme.colors.textInputStroke, lineWidth: 1)
                        .padding(1)
                )
            
            Text(ProfileLocalization.Calendar.color)
                .font(Theme.Fonts.bodySmall).bold()
                .padding(.top, 16)
            DropDownPicker(selection: $viewModel.colorSelection, state: .bottom, options: viewModel.colors)
            
            Text(ProfileLocalization.Calendar.upcomingAssignments)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(themeManager.theme.colors.textPrimary)
                .padding(.vertical, 13)
                .multilineTextAlignment(.center)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    alignment: .center
                )
                .frame(height: 65)
            
            VStack(spacing: 16) {
                StyledButton(
                    ProfileLocalization.Calendar.cancel,
                    action: {
                        onCloseTapped()
                    },
                    color: themeManager.theme.colors.background,
                    textColor: themeManager.theme.colors.accentColor,
                    borderColor: themeManager.theme.colors.accentColor
                )
                
                StyledButton(ProfileLocalization.Calendar.beginSyncing) {
                    viewModel.calendarName = calendarName
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
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(themeManager.theme.colors.background)
        )
        .padding(24)
    }
    
    func limitText(_ upper: Int) {
        if calendarName.count > upper {
            calendarName = String(calendarName.prefix(upper))
        }
    }
}

#if DEBUG
#Preview {
    NewCalendarView(
        title: .changeSyncOptions,
        viewModel: DatesAndCalendarViewModel(
            router: ProfileRouterMock(),
            interactor: ProfileInteractor(
                repository: ProfileRepositoryMock()
            ),
            profileStorage: ProfileStorageMock(),
            persistence: ProfilePersistenceMock(),
            calendarManager: CalendarManagerMock(),
            connectivity: Connectivity()
        ),
        beginSyncingTapped: {
        },
        onCloseTapped: {}
    )
    .loadFonts()
}
#endif
