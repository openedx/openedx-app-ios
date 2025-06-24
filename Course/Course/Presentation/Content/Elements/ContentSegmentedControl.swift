//
//  ContentSegmentedControl.swift
//  Course
//
//  Created by  Stepanok Ivan on 24.06.2025.
//

import SwiftUI
import Theme

enum ContentTab: CaseIterable {
    case all
    case videos
    case assignments
    
    var title: String {
        switch self {
        case .all:
            return CourseLocalization.CourseContent.all
        case .videos:
            return CourseLocalization.CourseContent.videos
        case .assignments:
            return CourseLocalization.CourseContent.assignments
        }
    }
}

struct ContentSegmentedControl: View {
    @Binding var selectedTab: ContentTab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(ContentTab.allCases.enumerated()), id: \.element) { index, tab in
                Button(action: {
                    selectedTab = tab
                }) {
                    Text(tab.title)
                        .font(Theme.Fonts.titleSmall)
                        .foregroundColor(selectedTab == tab ? .white : Theme.Colors.accentColor)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        .background(
                            selectedTab == tab ? Theme.Colors.accentColor : Theme.Colors.background
                        )
                }
                .disabled(selectedTab == tab)
                
                if index < ContentTab.allCases.count - 1 {
                    Rectangle()
                        .fill(Theme.Colors.accentColor)
                        .frame(width: 1, height: 40)
                }
            }
        }
        .background(Theme.Colors.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.accentColor, lineWidth: 1)
        )
    }
}

#if DEBUG
#Preview {
    @State var selectedTab: ContentTab = .all
    
    return VStack(spacing: 20) {
        ContentSegmentedControl(selectedTab: $selectedTab)
            .padding(.horizontal, 16)
        
        Text("Selected: \(selectedTab.title)")
            .font(Theme.Fonts.titleMedium)
        
        Spacer()
    }
    .padding()
    .background(Theme.Colors.background)
}
#endif
