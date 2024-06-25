//
//  OfflineContentView.swift
//  Course
//
//  Created by  Stepanok Ivan on 22.06.2024.
//

import SwiftUI
import Core
import Theme

public struct OfflineContentView: View {
    
    enum OfflineContentState {
        case notDownloaded
        case notAvailableOffline

        var title: String {
            switch self {
            case .notDownloaded:
                return CourseLocalization.Offline.NotDownloaded.title
            case .notAvailableOffline:
                return CourseLocalization.Offline.NotAvaliable.title
            }
        }

        var description: String {
            switch self {
            case .notDownloaded:
                return CourseLocalization.Offline.NotDownloaded.description
            case .notAvailableOffline:
                return CourseLocalization.Offline.NotAvaliable.description
            }
        }
    }
    
    @State private var contentState: OfflineContentState
    
    public init(isDownloadable: Bool) {
        contentState = isDownloadable ? .notDownloaded : .notAvailableOffline
    }

    public var body: some View {
        VStack(spacing: 0) {
            Spacer()
            CoreAssets.notAvaliable.swiftUIImage
            Text(contentState.title)
                .font(Theme.Fonts.titleLarge)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 40)
            Text(contentState.description)
                .font(Theme.Fonts.bodyLarge)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
            Spacer()
        }
        .padding(24)
    }
}
