//
//  AssignmentStatusView.swift
//  Profile
//
//  Created by  Stepanok Ivan on 15.05.2024.
//

import SwiftUI
import Core
import Theme

enum AssignmentStatus {
    case synced
    case failed
    case offline
    case loading
    
    var statusText: String {
        switch self {
        case .synced:
            ProfileLocalization.AssignmentStatus.synced
        case .failed:
            ProfileLocalization.AssignmentStatus.failed
        case .offline:
            ProfileLocalization.AssignmentStatus.offline
        case .loading:
            ProfileLocalization.AssignmentStatus.syncing
        }
    }
    
    var image: Image? {
        switch self {
        case .synced:
            CoreAssets.synced.swiftUIImage
        case .failed:
            CoreAssets.syncFailed.swiftUIImage
        case .offline:
            CoreAssets.syncOffline.swiftUIImage
        case .loading:
            nil
        }
    }
}

struct AssignmentStatusView: View {
    
    private let title: String
    @Binding private var status: AssignmentStatus
    private let calendarColor: Color
    
    init(title: String, status: Binding<AssignmentStatus>, calendarColor: Color) {
        self.title = title
        self._status = status
        self.calendarColor = calendarColor
    }
    
    var body: some View {
        ZStack {
            HStack {
                Circle()
                    .frame(width: 18, height: 18)
                    .foregroundStyle(calendarColor)
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(Theme.Fonts.labelLarge)
                        .foregroundStyle(Theme.Colors.textPrimary)
                    Text(status.statusText)
                        .font(Theme.Fonts.labelSmall)
                        .foregroundStyle(Theme.Colors.textSecondary)
                }
                .padding(.vertical, 10)
                .multilineTextAlignment(.leading)
                Spacer()
                status.image
                if status == .loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .foregroundStyle(Theme.Colors.textInputUnfocusedBackground)
        )
    }
}

#if DEBUG
#Preview {
    AssignmentStatusView(
        title: "My Assignments",
        status: .constant(.loading),
        calendarColor: .blue
    )
    .loadFonts()
}
#endif
