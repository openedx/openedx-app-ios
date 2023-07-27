//
//  DownloadView.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import SwiftUI

public enum DownloadViewState {
    case available
    case downloading
    case finished
}

public struct DownloadAvailableView: View {
    public init () {
    }
    
    public var body: some View {
        CoreAssets.startDownloading.swiftUIImage.renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(Theme.Colors.textPrimary)
    }
}

public struct DownloadProgressView: View {
    public init () {
    }
    
    public var body: some View {
        ZStack {
            ProgressBar(size: 36, lineWidth: 1.75)
            CoreAssets.stopDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Theme.Colors.textPrimary)
                .padding(6)
        }
    }
}

public struct DownloadFinishedView: View {
    public init () {
    }
    
    public var body: some View {
        CoreAssets.deleteDownloading.swiftUIImage.renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(Theme.Colors.textPrimary)
    }
}
