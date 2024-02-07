//
//  DownloadView.swift
//  Core
//
//  Created by  Stepanok Ivan on 08.03.2023.
//

import SwiftUI
import Theme

public enum DownloadViewState {
    case available
    case downloading
    case finished
}


public struct CircleProgressView: View {
    public init () {
    }

    public var body: some View {
        ProgressBar(size: 30, lineWidth: 1.75)
    }
}

public struct DownloadAvailableView: View {
    public init () {
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CoreAssets.startDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(width: 30, height: 30)
    }
}

public struct DownloadProgressView: View {
    public init () {
    }
    
    public var body: some View {
        ZStack {
            ProgressBar(size: 30, lineWidth: 1.75)
            CoreAssets.stopDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Theme.Colors.textPrimary)
        }
    }
}

public struct DownloadFinishedView: View {
    public init () {
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            CoreAssets.deleteDownloading.swiftUIImage.renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(Theme.Colors.textPrimary)
        }
        .frame(width: 30, height: 30)
    }
}
