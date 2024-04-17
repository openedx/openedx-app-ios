//
//  VideoDownloadQualityContainerView.swift
//  Course
//
//  Created by Eugene Yatsenko on 04.01.2024.
//

import SwiftUI
import Core
import Theme

struct VideoDownloadQualityContainerView: View {

    @Environment(\.dismiss) private var dismiss

    private var downloadQuality: DownloadQuality
    private var didSelect: ((DownloadQuality) -> Void)?
    private let analytics: CoreAnalytics
    private let router: CourseRouter

    init(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics,
        router: CourseRouter
    ) {
        self.downloadQuality = downloadQuality
        self.didSelect = didSelect
        self.analytics = analytics
        self.router = router
    }

    var body: some View {
        NavigationView {
            VideoDownloadQualityView(
                downloadQuality: downloadQuality,
                didSelect: didSelect,
                analytics: analytics, 
                router: router
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(Theme.Colors.accentColor)
                    }
                    .accessibilityIdentifier("close_button")
                }
            }
            .padding(.top, 1)
        }
    }
}
