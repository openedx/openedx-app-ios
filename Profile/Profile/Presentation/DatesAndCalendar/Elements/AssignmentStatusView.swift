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
    
    var statusText: String {
        switch self {
        case .synced:
            ProfileLocalization.AssignmentStatus.synced
        case .failed:
            ProfileLocalization.AssignmentStatus.failed
        case .offline:
            ProfileLocalization.AssignmentStatus.offline
        }
    }
    
    var image: Image {
        switch self {
        case .synced:
            CoreAssets.synced.swiftUIImage
        case .failed:
            CoreAssets.syncFailed.swiftUIImage
        case .offline:
            CoreAssets.syncOffline.swiftUIImage
        }
    }
}

struct AssignmentStatusView: View {
    
    private let title: String
    @Binding private var status: AssignmentStatus
    private let calendarColorImage: Image
    
    init(title: String, status: Binding<AssignmentStatus>, calendarColorImage: Image) {
        self.title = title
        self._status = status
        self.calendarColorImage = calendarColorImage
    }
    
    var body: some View {
        ZStack {
            HStack {
                calendarColorImage
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
            }
            
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
        status: .constant(.synced),
        calendarColorImage: CoreAssets.blueCircle.swiftUIImage
    )
        .loadFonts()
}
#endif
