//
//  CalendarDialogView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Core
import Theme

struct CalendarDialogView: View {
    
    enum CalendarDialogType {
        case calendarAccess
        case disableCalendarSync(calendarName: String)
        
        var title: String {
            switch self {
            case .calendarAccess:
                ProfileLocalization.CalendarDialog.calendarAccess
            case .disableCalendarSync:
                ProfileLocalization.CalendarDialog.disableCalendarSync
            }
        }
        
        var description: String {
            switch self {
            case .calendarAccess:
                ProfileLocalization.CalendarDialog.calendarAccessDescription
            case .disableCalendarSync(let calendarName):
                ProfileLocalization.CalendarDialog.disableCalendarSyncDescription(calendarName)
            }
        }
    }
    
    @Environment(\.isHorizontal) private var isHorizontal
    @EnvironmentObject var themeManager: ThemeManager
    private var onCloseTapped: (() -> Void) = {}
    private var action: (() -> Void) = {}
    private let type: CalendarDialogType
    private let calendarCircleColor: Color?
    private let calendarName: String?
    
    init(
        type: CalendarDialogType,
        calendarCircleColor: Color? = nil,
        calendarName: String? = nil,
        action: @escaping () -> Void,
        onCloseTapped: @escaping () -> Void
    ) {
        self.type = type
        self.calendarCircleColor = calendarCircleColor
        self.calendarName = calendarName
        self.action = action
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
                                .foregroundStyle(themeManager.theme.colors.background)
                        )
                        .padding(24)
                }
            } else {
                content
                    .frame(maxWidth: 400)
                    .padding(24)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .foregroundStyle(themeManager.theme.colors.background)
                    )
                    .padding(24)
            }
        }
    }
    
    private var content: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center) {
                CoreAssets.warningFilled.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(type.title)
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
            
            if let calendarName, let calendarCircleColor {
                HStack {
                    Circle()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(calendarCircleColor)
                    Text(calendarName)
                        .strikethrough()
                        .font(Theme.Fonts.labelLarge)
                        .foregroundStyle(themeManager.theme.colors.textPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer()
                }
                .padding(16)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(themeManager.theme.colors.textInputUnfocusedBackground)
                )
            }
            
            Text(type.description)
                .font(Theme.Fonts.bodySmall)
                .foregroundColor(themeManager.theme.colors.textPrimary)
                .multilineTextAlignment(.leading)
            
            VStack(spacing: 16) {
                switch type {
                case .calendarAccess:
                    StyledButton(
                        ProfileLocalization.CalendarDialog.grantCalendarAccess,
                        action: {
                            action()
                        },
                        iconImage: CoreAssets.calendarAccess.swiftUIImage,
                        iconPosition: .right
                    )
                    StyledButton(
                        ProfileLocalization.CalendarDialog.cancel,
                        action: {
                            onCloseTapped()
                        },
                        color: themeManager.theme.colors.background,
                        textColor: themeManager.theme.colors.accentColor,
                        borderColor: themeManager.theme.colors.accentColor
                    )
                case .disableCalendarSync:
                    StyledButton(
                        ProfileLocalization.CalendarDialog.disableSyncing,
                        action: {
                            action()
                        },
                        color: themeManager.theme.colors.background,
                        textColor: themeManager.theme.colors.accentColor,
                        borderColor: themeManager.theme.colors.accentColor
                    )
                    
                    StyledButton(ProfileLocalization.CalendarDialog.cancel) {
                        onCloseTapped()
                    }
                }
            }
            .padding(.top, 16)
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
    CalendarDialogView(
        type: .disableCalendarSync(calendarName: "Demo Calendar"),
        calendarCircleColor: .red,
        calendarName: "Demo Calendar",
        action: {},
        onCloseTapped: {}
    )
    .loadFonts()
}
#endif
