//
//  CategoryFilterView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 24.04.2024.
//

import Theme
import Core
import SwiftUI

enum CategoryOption: String, CaseIterable {
    case all
    case inProgress
    case completed
    case expired
    
    var status: String {
        switch self {
        case .all:
            "all"
        case .inProgress:
            "in_progress"
        case .completed:
            "completed"
        case .expired:
            "expired"
        }
    }
    
    var text: String {
        switch self {
        case .all:
            DashboardLocalization.Learn.Category.all
        case .inProgress:
            DashboardLocalization.Learn.Category.inProgress
        case .completed:
            DashboardLocalization.Learn.Category.completed
        case .expired:
            DashboardLocalization.Learn.Category.expired
        }
    }
}

struct CategoryFilterView: View {
    @Binding var selectedOption: CategoryOption
    @Environment (\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                ForEach(Array(CategoryOption.allCases.enumerated()), id: \.offset) { index, option in
                    Button(action: {
                        selectedOption = option
                    },
                           label: {
                        HStack {
                            Text(option.text)
                                .font(Theme.Fonts.titleSmall)
                                .foregroundColor(
                                    option == selectedOption ? Theme.Colors.white : (
                                        colorScheme == .light ? Theme.Colors.accentColor : .white
                                    )
                                )
                        }
                        .padding(.horizontal, 17)
                        .padding(.vertical, 8)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
                                    .foregroundStyle(
                                        option == selectedOption
                                        ? Theme.Colors.accentColor
                                        : Theme.Colors.cardViewBackground
                                    )
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(
                                        colorScheme == .light ? Theme.Colors.accentColor : .clear,
                                        style: .init(lineWidth: 1)
                                    )
                            }
                            .padding(.vertical, 1)
                        }
                    })
                    .padding(.leading, index == 0 ? 16 : 0)
                }
            }
            .fixedSize()
        }
    }
}
