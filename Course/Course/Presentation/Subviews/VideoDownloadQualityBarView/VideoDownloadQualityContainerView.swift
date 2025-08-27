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
    @EnvironmentObject var themeManager: ThemeManager
    
    private var downloadQuality: DownloadQuality
    private var didSelect: ((DownloadQuality) -> Void)?
    private let analytics: CoreAnalytics
    private let router: CourseRouter
    private var isModal: Bool

    init(
        downloadQuality: DownloadQuality,
        didSelect: ((DownloadQuality) -> Void)?,
        analytics: CoreAnalytics,
        router: CourseRouter,
        isModal: Bool = false
    ) {
        self.downloadQuality = downloadQuality
        self.didSelect = didSelect
        self.analytics = analytics
        self.router = router
        self.isModal = isModal
    }

    var body: some View {
        NavigationView {
            VideoDownloadQualityView(
                downloadQuality: downloadQuality,
                didSelect: didSelect,
                analytics: analytics,
                router: router,
                isModal: isModal
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(themeManager.theme.colors.accentColor)
                    }
                    .accessibilityIdentifier("close_button")
                }
            }
            .padding(.top, 1)
        }
    }
}
