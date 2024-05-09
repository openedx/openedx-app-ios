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
            case .inProgress:
                nil
            case .completed:
                nil
            case .expired:
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
            self.type = .inProgress
        case .inProgress:
            self.type = .inProgress
        case .completed:
            self.type = .completed
        case .expired:
            self.type = .expired
        }
        self.openDiscovery = {}
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Spacer()
            CoreAssets.learnBig.swiftUIImage
                .resizable()
                .frame(width: 96, height: 96)
                .foregroundStyle(Theme.Colors.textSecondaryLight)
            Text(type.title)
                .foregroundStyle(Theme.Colors.textPrimary)
                .font(Theme.Fonts.titleMedium)
            if let description = type.description {
                Text(description)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.Colors.textPrimary)
                    .font(Theme.Fonts.labelMedium)
                    .frame(width: 245)
            }
            Spacer()
            if type == .primary {
                StyledButton(DashboardLocalization.Learn.NoCoursesView.findACourse, action: {
                    openDiscovery()
                }).padding(24)
            }
        }
    }
}
