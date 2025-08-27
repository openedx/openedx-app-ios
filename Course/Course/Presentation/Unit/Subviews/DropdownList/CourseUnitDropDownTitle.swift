//
//  CourseUnitDropDownTitle.swift
//  Course
//
//  Created by Vadim Kuznetsov on 4.12.23.
//

import SwiftUI
import Theme

struct CourseUnitDropDownTitle: View {
    var title: String
    var isAvailable: Bool
    @Binding var showDropdown: Bool
    @EnvironmentObject var themeManager: ThemeManager
    
    var body: some View {
        if isAvailable {
            Button {
                if isAvailable {
                    showDropdown.toggle()
                }
            } label: {
                HStack {
                    Text(title)
                        .opacity(showDropdown ? 0.7 : 1.0)
                        .lineLimit(1)
                        .font(Theme.Fonts.bodyMedium)
                        .foregroundColor(themeManager.theme.colors.textPrimary)
                    if isAvailable {
                        Image(systemName: "chevron.down").renderingMode(.template)
                            .dropdownArrowRotationAnimation(value: showDropdown)
                            .foregroundColor(themeManager.theme.colors.textPrimary)
                    }
                }
            }
            .buttonStyle(.plain)
        } else {
            Text(title)
                .lineLimit(1)
        }
    }
}

#if DEBUG
struct CourseUnitDropDownTitle_Previews: PreviewProvider {
    static var previews: some View {
        CourseUnitDropDownTitle(
            title: "Dropdown title",
            isAvailable: true,
            showDropdown: .constant(false)
        )
    }
}
#endif
