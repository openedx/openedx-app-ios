//
//  MenuOption.swift
//  Downloads
//
//  Created by Ivan Stepanok on 22.02.2025.
//

import Theme
import Core
import SwiftUI

enum MenuOption: String, CaseIterable {
    case remove
    case cancel
    
    var text: String {
        switch self {
        case .remove:
            DownloadsLocalization.MenuOption.remove
        case .cancel:
            DownloadsLocalization.MenuOption.cancel
        }
    }
}

struct DropDownMenu: View {
    @State private var expanded: Bool = false
    let isDownloading: Bool
    let onRemoveTap: () -> Void
    let onCancelTap: () -> Void
    
    var body: some View {
        VStack(alignment: .trailing) {
            Button(action: {
                withAnimation(.snappy(duration: 0.2)) {
                    expanded.toggle()
                }
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 24))
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .frame(width: 30, height: 30)
                    .background(Circle().fill(.ultraThinMaterial))
            }
            .padding(8)
            .padding(.bottom, -8)
            
            if expanded {
                VStack(alignment: .leading, spacing: 0) {
                    menuButton(title: MenuOption.remove.text) {
                        expanded = false
                        onRemoveTap()
                    }
                    
                    if isDownloading {
                        Rectangle()
                            .frame(width: 240, height: 1)
                            .foregroundStyle(Theme.Colors.cardViewStroke)
                            .padding(.horizontal, 16)
                        menuButton(title: MenuOption.cancel.text) {
                            expanded = false
                            onCancelTap()
                        }
                    }
                }
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundStyle(Theme.Colors.background)
                        .shadow(radius: 24)
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(style: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Theme.Colors.cardViewStroke)
                }
                .padding(.trailing, 8)
            }
        }
        .onTapBackground(enabled: expanded, { expanded = false })
        .onDisappear { expanded = false }
    }
    
    private func menuButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(Theme.Fonts.labelLarge)
                .foregroundStyle(Theme.Colors.textPrimary)
                .frame(alignment: .leading)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
        }
    }
}
