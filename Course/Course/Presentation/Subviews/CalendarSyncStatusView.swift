//
//  CalendarSyncStatusView.swift
//  Course
//
//  Created by  Stepanok Ivan on 12.06.2024.
//

import SwiftUI
import Core
import Theme

struct CalendarSyncStatusView: View {
    
    var status: SyncStatus
    let router: CourseRouter
    
    var body: some View {
        HStack {
            icon
            Text(statusText)
                .font(Theme.Fonts.titleSmall)
            Spacer()
        }
        .frame(height: 40)
        .padding(.horizontal, 16)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Theme.Colors.datesSectionStroke, lineWidth: 2)
        )
        .background(Theme.Colors.datesSectionBackground)
        .onTapGesture {
            router.showDatesAndCalendar()
        }
    }
    
    private var icon: Image {
        switch status {
        case .synced:
            return CoreAssets.synced.swiftUIImage
        case .failed:
            return CoreAssets.syncFailed.swiftUIImage
        case .offline:
            return CoreAssets.syncOffline.swiftUIImage
        }
    }
    
    private var statusText: String {
        switch status {
        case .synced:
            return CourseLocalization.CalendarSyncStatus.synced
        case .failed:
            return CourseLocalization.CalendarSyncStatus.failed
        case .offline:
            return CourseLocalization.CalendarSyncStatus.offline
        }
    }
}

#if DEBUG
struct CalendarSyncStatusView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CalendarSyncStatusView(status: .synced, router: CourseRouterMock())
            CalendarSyncStatusView(status: .failed, router: CourseRouterMock())
            CalendarSyncStatusView(status: .offline, router: CourseRouterMock())
        }
        .loadFonts()
        .padding()
    }
}
#endif
