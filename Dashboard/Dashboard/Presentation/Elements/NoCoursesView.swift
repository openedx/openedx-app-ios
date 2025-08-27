//
//  NoCoursesView.swift
//  Dashboard
//
//  Created by  Stepanok Ivan on 02.05.2024.
//

import SwiftUI
import Core
import Theme

struct NoCoursesView: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    enum NoCoursesType {
        case primary
        case inProgress
        case completed
        case expired
        
        var title: String {
            switch self {
            case .primary:
                DashboardLocalization.Learn.NoCoursesView.noCourses
            case .inProgress:
                DashboardLocalization.Learn.NoCoursesView.noCoursesInProgress
            case .completed:
                DashboardLocalization.Learn.NoCoursesView.noCompletedCourses
            case .expired:
                DashboardLocalization.Learn.NoCoursesView.noExpiredCourses
            }
        }
        
        var description: String? {
            switch self {
            case .primary:
                DashboardLocalization.Learn.NoCoursesView.noCoursesDescription
            case .inProgress, .completed, .expired:
                nil
            }
        }
    }
    
    private let type: NoCoursesType
    private var openDiscovery: (() -> Void)
    
    init(openDiscovery: @escaping (() -> Void)) {
        self.type = .primary
        self.openDiscovery = openDiscovery
    }
    
    init(selectedMenu: CategoryOption) {
        switch selectedMenu {
        case .all:
            type = .inProgress
        case .inProgress:
            type = .inProgress
        case .completed:
            type = .completed
        case .expired:
            type = .expired
        }
        openDiscovery = {}
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            CoreAssets.learnEmpty.swiftUIImage
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundStyle(themeManager.theme.colors.textSecondaryLight)
            Text(type.title)
                .foregroundStyle(themeManager.theme.colors.textPrimary)
                .font(Theme.Fonts.titleMedium)
            if let description = type.description {
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(themeManager.theme.colors.textPrimary)
                    .font(Theme.Fonts.labelMedium)
                    .frame(width: 245)
            }
            Spacer()
            if type == .primary {
                StyledButton(DashboardLocalization.Learn.NoCoursesView.findACourse, action: { openDiscovery() })
                    .padding(24)
            }
        }
    }
}
