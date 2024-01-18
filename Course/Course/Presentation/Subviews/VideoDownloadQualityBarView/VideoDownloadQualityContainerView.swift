//
//  VideoDownloadQualityContainerView.swift
//  Course
//
//  Created by Eugene Yatsenko on 04.01.2024.
//

import SwiftUI
import Core
import Theme
import Profile

struct VideoDownloadQualityContainerView: View {

    @Environment(\.dismiss) private var dismiss

    private var downloadQuality: DownloadQuality
    private var didSelect: ((DownloadQuality) -> Void)?

    init(downloadQuality: DownloadQuality, didSelect: ((DownloadQuality) -> Void)?) {
        self.downloadQuality = downloadQuality
        self.didSelect = didSelect
    }

    var body: some View {
        NavigationView {
            VideoDownloadQualityView(
                downloadQuality: downloadQuality,
                didSelect: didSelect
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
