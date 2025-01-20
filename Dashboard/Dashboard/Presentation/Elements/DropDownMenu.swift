//
//  DropDownMenu.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 24.04.2024.
//

import Theme
import Core
import SwiftUI

enum MenuOption: String, CaseIterable {
    case courses
    case programs
    
    var text: String {
        switch self {
        case .courses:
            DashboardLocalization.Learn.DropdownMenu.courses
        case .programs:
            DashboardLocalization.Learn.DropdownMenu.programs
        }
    }
}

struct DropDownMenu: View {
    @Binding var selectedOption: MenuOption
    @State private var expanded: Bool = false
    var analytics: DashboardAnalytics
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack {
                Text(selectedOption.text)
                    .font(Theme.Fonts.titleSmall)
                    .accessibilityIdentifier("dropdown_menu_text")
                Image(systemName: "chevron.down")
                    .rotation3DEffect(
                        .degrees(expanded ? 180 : 0),
                        axis: (x: 1.0, y: 0.0, z: 0.0)
                    )
            }
            .foregroundColor(Theme.Colors.textPrimary)
            .onTapGesture {
                withAnimation(.snappy(duration: 0.2)) {
                    expanded.toggle()
                }
            }
            
            if expanded {
                VStack(spacing: 0) {
                    ForEach(Array(MenuOption.allCases.enumerated()), id: \.offset) { index, option in
                        Button(
                            action: {
                                selectedOption = option
                                expanded = false
                                switch selectedOption {
                                case .courses:
                                    analytics.mainCoursesClicked()
                                case .programs:
                                    analytics.mainProgramsClicked()
                                }
                            }, label: {
                                HStack {
                                    Text(option.text)
                                        .font(Theme.Fonts.titleSmall)
                                        .foregroundColor(
                                            option == selectedOption ? Theme.Colors.primaryButtonTextColor :
                                                Theme.Colors.textPrimary
                                        )
                                    Spacer()
                                }
                                .padding(10)
                                .background {
                                    ZStack {
                                        RoundedCorners(bl: index == MenuOption.allCases.count-1 ? 8 : 0,
                                                       br: index == MenuOption.allCases.count-1 ? 8 : 0)
                                        .foregroundStyle(option == selectedOption
                                                         ? Theme.Colors.accentColor
                                                         : Theme.Colors.cardViewBackground)
                                        RoundedCorners(bl: index == MenuOption.allCases.count-1 ? 8 : 0,
                                                       br: index == MenuOption.allCases.count-1 ? 8 : 0)
                                        .stroke(Theme.Colors.cardViewStroke, style: .init(lineWidth: 1))
                                    }
                                }
                            }
                        )
                    }
                }
                .frame(minWidth: 182)
                .fixedSize()
            }
        }
        .onTapBackground(enabled: expanded, { expanded = false })
        .onDisappear {
            expanded = false
        }
    }
}
