//
//  TotalDownloadedProgressView.swift
//  Course
//
//  Created by  Stepanok Ivan on 17.06.2024.
//

import SwiftUI
import Theme
import Core

public struct TotalDownloadedProgressView: View {
    
    private let downloadedFilesSize: Int
    private let readyToDownload: Int
    private let totalFilesSize: Int
    @Binding var isDownloading: Bool
    
    public init(downloadedFilesSize: Int, totalFilesSize: Int, isDownloading: Binding<Bool>) {
        self.downloadedFilesSize = downloadedFilesSize
        self.totalFilesSize = totalFilesSize
        self.readyToDownload = totalFilesSize - downloadedFilesSize
        self._isDownloading = isDownloading
    }
    
    public var body: some View {
        VStack(alignment: .center, spacing: 6) {
            HStack {
                Text(downloadedFilesSize.formattedFileSize())
                    .foregroundStyle(
                        totalFilesSize == 0
                        ? Theme.Colors.textSecondaryLight
                        : Theme.Colors.success
                    )
                Spacer()
                if totalFilesSize != 0 {
                    Text(readyToDownload.formattedFileSize())
                }
            }
            .font(Theme.Fonts.titleLarge)
            HStack {
                CoreAssets.deleteDownloading.swiftUIImage.renderingMode(.template)
                    .foregroundStyle(
                        totalFilesSize == 0
                        ? Theme.Colors.textSecondaryLight
                        : Theme.Colors.success
                    )
                Text(totalFilesSize == 0
                     ? CourseLocalization.Course.TotalProgress.avaliableToDownload
                     : CourseLocalization.Course.TotalProgress.downloaded)
                .foregroundStyle(
                    totalFilesSize == 0
                    ? Theme.Colors.textSecondaryLight
                    : Theme.Colors.success
                )
                Spacer()
                if totalFilesSize != 0 {
                    CoreAssets.startDownloading.swiftUIImage
                    Text(isDownloading ?
                         CourseLocalization.Course.TotalProgress.downloading
                         : CourseLocalization.Course.TotalProgress.readyToDownload)
                }
            }
            .font(Theme.Fonts.labelLarge)
            .padding(.bottom, 10)
            if totalFilesSize != 0 {
                ZStack(alignment: .leading) {
                    GeometryReader { geometry in
                        RoundedRectangle(cornerRadius: 2.5)
                            .fill(Theme.Colors.textSecondary.opacity(0.5))
                            .frame(width: geometry.size.width, height: 5)
                        
                        RoundedCorners(tl: 2.5, tr: 0, bl: 2.5, br: 0)
                            .fill(Theme.Colors.success)
                            .frame(
                                width: geometry.size.width * CGFloat(
                                    downloadedFilesSize
                                ) / CGFloat(totalFilesSize),
                                height: 5
                            )
                    }
                    .frame(height: 5)
                }
                .cornerRadius(5)
                .padding(.bottom, 10)
            }
        }
        .onChange(of: readyToDownload, perform: { size in
            if size == 0 {
                self.isDownloading = false
            }
        })
    }
}

struct TotalDownloadedProgressView_Previews: PreviewProvider {
    static var previews: some View {
        TotalDownloadedProgressView(
            downloadedFilesSize: 24341324514,
            totalFilesSize: 324324132413,
            isDownloading: .constant(false)
        )
        .loadFonts()
    }
}
