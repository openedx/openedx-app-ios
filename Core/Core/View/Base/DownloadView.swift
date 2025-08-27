//
//  DownloadView.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import SwiftUI
import Theme

public enum DownloadViewState: Sendable {
    case available
    case downloading
    case finished
}

public struct DownloadAvailableView: View {
    public init () {
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CoreAssets.startDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(themeManager.theme.colors.textPrimary)
                .frame(width: 24, height: 24)
        }
        .frame(width: 30, height: 30)
    }
}

public struct DownloadProgressView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    public init () {
    }
    
    public var body: some View {
        ZStack {
            ProgressBar(size: 30, lineWidth: 1.75)
            CoreAssets.stopDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(themeManager.theme.colors.snackbarErrorColor)
                .foregroundColor(themeManager.theme.colors.textPrimary)
        }
    }
}

public struct DownloadFinishedView: View {
    public init () {
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CoreAssets.deleteDownloading.swiftUIImage
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
        }
        .frame(width: 30, height: 30)
    }
}
