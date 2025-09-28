//
//  ToggleWithDescriptionView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Theme
import Core

struct ToggleWithDescriptionView: View {
    
    let text: String
    let description: String
    @Binding var toggle: Bool
    @Binding var showAlertIcon: Bool
    
    init(
        text: String,
        description: String,
        toggle: Binding<Bool>,
        showAlertIcon: Binding<Bool> = .constant(false)
    ) {
        self.text = text
        self.description = description
        self._toggle = toggle
        self._showAlertIcon = showAlertIcon
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
//            HStack(spacing: 12) {
                Toggle(isOn: $toggle, label: {
                    HStack {
                        Text(text)
                            .font(Theme.Fonts.bodyLarge)
                            .foregroundColor(Theme.Colors.textPrimary)
                        if showAlertIcon {
                            CoreAssets.warningFilled.swiftUIImage
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                })
                .tint(Theme.Colors.accentColor)
//                CustomToggle(isOn: $toggle)
//                    .padding(.leading, 10)
//                Text(text)
//                    .font(Theme.Fonts.bodyLarge)
//                    .foregroundColor(Theme.Colors.textPrimary)
//                if showAlertIcon {
//                    CoreAssets.warningFilled.swiftUIImage
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                }
//            }
            Text(description)
                .font(Theme.Fonts.labelMedium)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(minWidth: 0,
               maxWidth: .infinity,
               alignment: .leading)
        .accessibilityIdentifier("\(text)_toggle")
    }
}

#Preview {
    ToggleWithDescriptionView(
        text: "Use relative dates",
        description: "Show relative dates like “Tomorrow” and “Yesterday”",
        toggle: .constant(true),
        showAlertIcon: .constant(true)
    )
    .loadFonts()
}

struct CustomToggle: View {
    @Binding var isOn: Bool
    var body: some View {
        Button(action: {
            isOn.toggle()
        }) {
            RoundedRectangle(cornerRadius: 10)
                .fill(isOn ? Theme.Colors.accentColor : Color.gray)
                .frame(width: 37, height: 20)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 16, height: 16)
                        .offset(x: isOn ? 8 : -8)
                        .animation(.easeInOut(duration: 0.2), value: isOn)
                )
        }
    }
}
